--[[----------------------------------------------------------------------------

BlipfotoUser.lua
Blipfoto user account management

--------------------------------------------------------------------------------

------------------------------------------------------------------------------]]

	-- Lightroom SDK
local LrBinding = import 'LrBinding'
local LrView = import 'LrView'
local LrFunctionContext = import 'LrFunctionContext'
local LrDialogs = import 'LrDialogs'

local prefs = import 'LrPrefs'.prefsForPlugin()

local logger = import 'LrLogger'('BlipLR')
logger:enable( "print" )
local debug, info, warn, err = logger:quick( 'debug', 'info', 'warn', 'err' )

--============================================================================--

BlipfotoUser = {}

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

local function userHasAuthenticated()
	
	info("Checking if user has authenticated.")
	return prefs.identityToken and prefs.username and prefs.userSecret
	
end

local function setUser(identityToken, username, secret)

	info("Setting user details: ", identityToken, username);
	prefs.identityToken = identityToken;
	prefs.username = username;
	prefs.userSecret = secret;
	
end

--------------------------------------------------------------------------------

local function resetUser(propertyTable)
	
	info("Resetting user.");
	prefs.identityToken = nil
	prefs.username = nil
	prefs.userSecret = nil
	
	propertyTable.authStatus = LOC("$$$/Blipfoto/AuthStatus/NotAuthenticated=Link Lightroom to your Blipfoto account to get started.")
	propertyTable.isAuthenticated = false
	propertyTable.authButtonTitle = LOC("$$$/Blipfoto/AuthButton/Authenticate=Authenticate");
	propertyTable.authButtonEnabled = true
	
end

--------------------------------------------------------------------------------

function BlipfotoUser.getUsername()
	return prefs.username;
end

--------------------------------------------------------------------------------

function BlipfotoUser.verifyAuthentication(propertyTable)

	if userHasAuthenticated() then
		
		propertyTable.authStatus =
			LOC("$$$/Blipfoto/AuthStatus/Authenticated=Logged in as ^1", prefs.username);
		propertyTable.authButtonTitle = LOC("$$$/Blipfoto/AuthButton/Deauthenticate=Deauthenticate");
		propertyTable.authButtonEnabled = true;
		propertyTable.isAuthenticated = true;
		
		info("Authenticated as ", prefs.username);
		
	else
		resetUser(propertyTable);
	end
	
end

--------------------------------------------------------------------------------

function BlipfotoUser.deauthenticate(propertyTable)
	
	resetUser(propertyTable);
	
end

--------------------------------------------------------------------------------

local isAuthenticating = false

function BlipfotoUser.authenticate(propertyTable)

	info("Starting authentication process");
	if isAuthenticating then
		info("Bailing - already authenticating.");
		return
	end
	isAuthenticating = true
	
	propertyTable.authButtonTitle = LOC("$$$/Blipfoto/AuthButton/Authenticating=Authenticating")
	propertyTable.authButtonEnabled = false

	LrFunctionContext.postAsyncTaskWithContext( 'Blipfoto Authentication',
		function(context)

			LrDialogs.attachErrorDialogToFunctionContext(context)
			context:addCleanupHandler( function()
				info("Cleaning up authentication process");
				isAuthenticating = false

				if not userHasAuthenticated() then
					resetUser(propertyTable)
				end

			end )

			require 'BlipfotoAPI'

			if not userHasAuthenticated() then

				info("User hasn't authenticated");
				
				propertyTable.authStatus = LOC("$$$/Blipfoto/AuthStatus/RequestingPermission=Requesting permission to authenticate with Blipfoto");
				
				local authRequestDialogResult = LrDialogs.confirm(
					LOC "$$$/Blipfoto/AuthRequestDialog/Message=Lightroom needs your permission to upload images to Blipfoto.",
					LOC "$$$/Blipfoto/AuthRequestDialog/HelpText=Hit the Authenticate button if you want to upload images from Lightroom. You'll then be taken to a web page from which you can authorise Lightroom to upload images to your journal.",
					LOC "$$$/Blipfoto/AuthRequestDialog/AuthButtonText=Authenticate",
					LOC "$$$/LrDialogs/Cancel=Cancel" )
					
				if authRequestDialogResult == 'cancel' then
					info("Cancel?");
					return
				end

				-- Display the permissions web page
				
				BlipfotoAPI.openAuthUrl()
			
				-- Display a dialog for the user to enter the 6 digit token
				local f = LrView.osFactory()
				propertyTable.authCode = ''
				info("Building contents");
				
				local contents =
					f:column
					{
						spacing = f:control_spacing(),
						bind_to_object = propertyTable,
					
						f:row
						{
							f:static_text
							{
								title = LOC("$$$/Blipfoto/AuthRequestDialog/PleaseEnterCode=Please enter your 6-digit Blipfoto permission code below"),
								alignment = 'left',
								fill_horizontal = 1,
							},
						},
						f:row {f:spacer {}},
						f:row
						{
							spacing = f:label_spacing(),
							
							f:static_text
							{
								title = LOC("$$$/Blipfoto/AuthRequestDialog/AuthCodeLabel=6-digit code:"),
								alignment = 'left'
							},
							f:edit_field
							{
								width_in_chars = 6,
								value = LrView.bind 'authCode'
							}
						},
						f:row {f:spacer {}},
						f:row {f:separator {fill_horizontal = 1}},
						f:row {f:spacer {}},
						f:row
						{
							f:static_text
							{
								title = LOC('$$$/Blipfoto/AuthRequestDialog/PermissionPageProblem=If the permission web page did not appear^nplease visit this address in your browser:'),
							}
						},
						f:row
						{
							f:static_text
							{
								title = BlipfotoAPI.getPermissionsUrl(),
								selectable = true
							}
						}
					}
				
				info("Displaying modal dialog");
				
				local authTokenDialogResult = LrDialogs.presentModalDialog({
					title = LOC("$$$/Blipfoto/AuthTokenDialog/Title=Blipfoto 6-Digit Code"),
					contents = contents,
					actionVerb = LOC("$$$/Blipfoto/AuthTokenDialog/Authenticate=Authenticate")
				})
				
				info(string.format("Checking result, authCode: %s", propertyTable.authCode));
				
				if authTokenDialogResult == 'cancel' then
					info("Cancelled!");
					return
				end
				
				info("Everything is dandy!");
				
				local identityToken, username, secret = BlipfotoAPI.getToken(propertyTable.authCode);
				setUser(identityToken, username, secret);
				BlipfotoUser.verifyAuthentication(propertyTable)
			
			end

			

		end)
end
