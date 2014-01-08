--[[----------------------------------------------------------------------------

BlipfotoAPI.lua
Common code to initiate Blipfoto API requests

--------------------------------------------------------------------------------

------------------------------------------------------------------------------]]

	-- Lightroom SDK
local LrErrors = import 'LrErrors'
local LrHttp = import 'LrHttp'
local LrMD5 = import 'LrMD5'
local LrDate = import 'LrDate'
local LrPathUtils = import 'LrPathUtils'

local prefs = import 'LrPrefs'.prefsForPlugin()

local JSON = loadfile(LrPathUtils.child(_PLUGIN.path, "JSON.lua"))()

local logger = import 'LrLogger'('BlipLR')
local debug, info, warn, err = logger:quick( 'debug', 'info', 'warn', 'err' )

require 'Utils'
require 'JSON'


--============================================================================--

BlipfotoAPI = {}

--------------------------------------------------------------------------------

--[[
Get the App's API Key
--]]
local function getKey()
	return Utils.getFileContents("api-key");
end

--[[
Get the App's Secret
--]]
local function getSecret()
	return Utils.getFileContents("secret");
end

local props = {
	initialised = false,
	apiKey = getKey(),
	secret = getSecret(),
	apiUrl = "api.blipfoto.com",
	apiVersion = 3,
	apiFormat = "json",
	permissionsUrl = "http://www.blipfoto.com/getpermission/v3/340389",
	timeDifference = 0,
	calculatedTimeDifference = false,
	randomised = false
}

--------------------------------------------------------------------------------

-- Convert a table to a querystring
local function paramsToQueryString(params)

	local queryString = {};

	for name, value in pairs(params) do

		-- URL encode each of the params.

		value = string.gsub(value, '([^ !#-$&-*,%-%.0-;@-~])',
			function(c)
				return string.format('%%%02X', string.byte(c))
			end);
		value = string.gsub(value, ' ', '+');
		params[name] = value;

		queryString[#queryString + 1] = string.format('%s=%s', name, value);

	end
	
	return table.concat(queryString, "&");

end

-- Convert a table of params to a collection of MIME chunks that will be understood by LrHttp.postMultipart
local function paramsToMimeChunks(params)

	local mimeChunks = {};

	 for name, data in pairs(params) do

 		local chunk = {name = name};

 		if type(data) == "table" then
 			chunk.value = data.value;
 			chunk.filePath = data.filePath;
 			chunk.fileName = data.filename;
 		else
 			chunk.value = data;
 		end

	 	mimeChunks[#mimeChunks + 1] = chunk;


	 end

	 return mimeChunks;

end

--------------------------------------------------------------------------------

local function getLocalTime()

	return math.floor(LrDate.currentTime());

end

--------------------------------------------------------------------------------

local function calculateTimeDifference()

	local result = BlipfotoAPI.makeRequest("get", "time", {});
	
	local apiTime = tostring(result.timestamp);
	local localTime = getLocalTime();
	
	info("Blip API time is ", apiTime);
	info("Local time is ", localTime);
	props.timeDifference = apiTime - localTime;
	props.calculatedTimeDifference = true;
	info("Time difference is ", props.timeDifference);

end

--------------------------------------------------------------------------------

local function getTimeDifference()

	if props.calculatedTimeDifference == false then
		calculateTimeDifference();
	end

	return props.timeDifference;

end

--------------------------------------------------------------------------------

local function getNonce()

	if not props.randomised then
		info("Initialising randomseed.");
		math.randomseed(LrDate.currentTime());
		props.randomised = true
	end

	math.random(); math.random(); math.random();
	
	local rand1 = math.random() * getTimeDifference();
	local rand2 = math.random() * LrDate.currentTime();
	local rand3 = math.random() * (rand1 / (rand2 + 1));
	
	local nonce = LrMD5.digest(rand1 .. rand2 .. rand3);
	
	info("Generated nonce: " .. nonce);
	
	return nonce;
	
end

--------------------------------------------------------------------------------

local function makeAuthSignature(useUserSecret)
	
	if useUserSecret == nil then
		useUserSecret = false
	end

	local timestamp = getLocalTime() + getTimeDifference();
	local nonce = getNonce();
	local identityToken;
	local secret;

	if useUserSecret then
		identityToken = prefs.identityToken;
		secret = prefs.userSecret;
	else
		identityToken = "";
		secret = props.secret;
	end

	
	local signature = LrMD5.digest(timestamp .. nonce .. identityToken .. secret);

	info(string.format("Signature components are %s,%s,%s,%s", timestamp, nonce, identityToken, secret));
	info("Generated signature: " .. signature);
	
	return nonce, timestamp, identityToken, signature;
	
end

--------------------------------------------------------------------------------

function BlipfotoAPI.getPermissionsUrl()

	return props.permissionsUrl;

end

--------------------------------------------------------------------------------

function BlipfotoAPI.getBlipfotoApiKeyAndSecret()

	return props.apiKey, props.secret

end

--------------------------------------------------------------------------------

--[[

	Make a request

--]]
function BlipfotoAPI.makeRequest(method, resource, params)

	info("Making request: ", method, resource, table.tostring(params));
	-- Get the apiKey and add it to the params
	local apiKey, secret = BlipfotoAPI.getBlipfotoApiKeyAndSecret();
	params.api_key = apiKey;
	
	-- Build the URL
	-- token resource requires HTTPS
	local protocol = "http";
	if resource == "token" then
		protocol = protocol .. "s";
	end
	local url = string.format("%s://%s/v%s/%s.%s", protocol, props.apiUrl, props.apiVersion, resource, props.apiFormat);
	
	local response, headers;

	if method == "get" then
		local queryString = paramsToQueryString(params);
		url = string.format("%s?%s", url, queryString);
		
		info("Making get request: ", url, queryString);
		response, headers = LrHttp.get(url);

	elseif method == "post" then
		local postBody = paramsToQueryString(params);

		info("Making post request: ", url, postBody);
		response, headers = LrHttp.post(url, postBody);

	elseif method == "multi" then
		local mimeChunks = paramsToMimeChunks(params);

		info("Making multi request: ", url, table.tostring(mimeChunks));
		response, headers = LrHttp.postMultipart(url, mimeChunks);
	end
	
	info("Got headers:", table.tostring(headers));
	info("Got response: ", response);
	
	-- Parse the response
	local responseTable = JSON:decode(response);
	
	if responseTable == nil then
		responseTable = {data = nil, error = nil};
	end

	if responseTable.error == nil then
		responseTable.error = {code = nil, message = nil};
		info("request completed successfully");
	end

	return responseTable.data, responseTable.error;

end

--------------------------------------------------------------------------------

--[[

	Make an authenticated request

--]]
function BlipfotoAPI.makeAuthRequest(type, resource, params, isUserRequest)
	if isUserRequest == nil then
		isUserRequest = false
	end

	-- Add auth data to params
	params.nonce, params.timestamp, params.token, params.signature = makeAuthSignature(isUserRequest);
	return BlipfotoAPI.makeRequest(type, resource, params);
end

function BlipfotoAPI.makeUserAuthRequest(type, resource, params)
	
	assert(prefs.identityToken);
	return BlipfotoAPI.makeAuthRequest(type, resource, params, true)
	
end

--------------------------------------------------------------------------------

function BlipfotoAPI.getToken(authCode)

	info("Getting token: ", authCode);
	local result, rError = BlipfotoAPI.makeAuthRequest("get", "token", {temp_token = authCode});
	
	if rError.message then
		local errorString = tostring(rError.message);
		LrErrors.throwUserError(errorString);
	else
		return tostring(result.token), tostring(result.display_name), tostring(result.secret);
	end
	
end

--------------------------------------------------------------------------------

function BlipfotoAPI.uploadPhoto(entry)

	info("Sending photo");
	
	local resource = "image";
	
	local params =
	{
		date = entry.captureDate,
		image = {filePath = entry.path, filename = entry.filename}
	};

	if not entry.photoOnly then
		params.title = entry.title;
		params.description = entry.description;
		params.tags = entry.tags;
	end
	
	local result, rError = BlipfotoAPI.makeUserAuthRequest("multi", resource, params);
	
	if rError.message then
		local errorString = tostring(rError.message);
		LrErrors.throwUserError(errorString);
	else
		return tostring(result.entry_id), tostring(result.message);
	end
	
end

--------------------------------------------------------------------------------

function BlipfotoAPI.canPostForDate(date)
	
	local result, rError = BlipfotoAPI.makeUserAuthRequest("get", "datevalidation", {date = date});
	
	if rError.message then
		return false;
	else
		return true;
	end
	
end

--------------------------------------------------------------------------------

function BlipfotoAPI.openAuthUrl()

	info("Opening authentication URL in browser.");
	LrHttp.openUrlInBrowser(props.permissionsUrl)

end

