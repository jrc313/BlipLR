--[[----------------------------------------------------------------------------

BlipfotoUploadTask.lua
Upload photos to Blipfoto

--------------------------------------------------------------------------------

------------------------------------------------------------------------------]]

	-- Lightroom API
local LrDialogs = import 'LrDialogs'
local LrErrors = import 'LrErrors'
local LrFileUtils = import 'LrFileUtils'
local LrHttp = import 'LrHttp'
local LrPathUtils = import 'LrPathUtils'
local LrDate = import 'LrDate'
local LrFunctionContext = import 'LrFunctionContext'

local logger = import 'LrLogger'('BlipLR')
local debug, info, warn, err = logger:quick( 'debug', 'info', 'warn', 'err' )

	-- Blipfoto plug-in
require 'BlipfotoAPI'
require 'BlipfotoUser'


--============================================================================--

BlipfotoUploadTask = {}

--------------------------------------------------------------------------------

local function processDescription(description)
	
	description = string.gsub(description, LOC("$$$/Blipfoto/noloc=^U+2028"), LOC("$$$/Blipfoto/noloc=^n"));
	
	return description;
	
end

--------------------------------------------------------------------------------

local function getPhotoDetails(photo)

	local title, description, tags, captureDate, captureTime;
	
	photo.catalog:withReadAccessDo(
		function()
			
			captureDate = photo:getRawMetadata('dateTimeOriginalISO8601');
			captureTime = photo:getRawMetadata('dateTimeOriginal');
			-- We only need the date component
			captureDate = string.sub(captureDate, 1, 10);
			
			title = photo:getFormattedMetadata('title') or "";

			description = processDescription(photo:getFormattedMetadata('caption') or "");
			tags = photo:getFormattedMetadata('keywordTagsForExport') or "";
			
		end
	);
	
	info("Title: ", title);
	info("Description: ", description);
	info("Tags: ", tags);
	info("Capture Date: ", captureDate);
	info("Capture Time: ", captureTime);
	
	return title, description, tags, captureDate, captureTime;
	
end

--------------------------------------------------------------------------------

function BlipfotoUploadTask.processRenderedPhotos(functionContext, exportContext)

	-- Get the export session
	local exportSession = exportContext.exportSession;
	-- Make a local reference to the export parameters.
	local exportParams = exportContext.propertyTable;
	
	info("Details source is ", exportParams.detailsSource);
	
	-- Set progress title.
	
	local photoCount = exportSession:countRenditions();

	local progressScope = exportContext:configureProgress({
						title = photoCount == 1
									and LOC("$$$/Blipfoto/Upload/Progress=Sending your entry to Blipfoto")
									or LOC("$$$/Blipfoto/Upload/ProgressPlural=Sending ^1 entries to Blipfoto", photoCount)
					});

	local photo, title, description, tags, captureDate, captureTime;
	local sendDetails = true;

	local lastUploadedEntryDate;
	local uploadCount = 0;
	local failCount = 0;
	local messageList = {};

	for i, rendition in exportContext:renditions({stopIfCanceled = true}) do

		photo = rendition.photo;
		
		progressScope:setCaption(string.format("Rendering entry %d of %d", i, photoCount));
		
		local success, pathOrMessage = rendition:waitForRender();
		
		progressScope:setPortionComplete(i * 3 - 2, photoCount * 3);
		
		
		-- Check for cancellation again after photo has been rendered.
	
		if progressScope:isCanceled() then break end
	
		if success then
	
			title, description, tags, captureDate, captureTime = getPhotoDetails(photo);

			progressScope:setCaption(string.format("Checking entry date for entry %d of %d", i, photoCount));

			if BlipfotoAPI.canPostForDate(captureDate) then
		
				progressScope:setPortionComplete(i * 3 - 1, photoCount * 3);
		
				if exportParams.detailsSource == 'dialog' then
			
					title = exportParams.entryTitle or "";
					description = processDescription(exportParams.entryDescription or "");
					tags = exportParams.entryTags or "";
		
				elseif exportParams.detailsSource == 'blip' then
			
					sendDetails = false;
			
				end

				progressScope:setCaption(string.format("Uploading entry %d of %d", i, photoCount));

				local entryId, message = BlipfotoAPI.uploadPhoto({
					photoOnly = not sendDetails,
					path = pathOrMessage,
					filename = LrPathUtils.leafName(pathOrMessage),
					title = title,
					description = description,
					tags = tags,
					captureDate = captureDate
				});
	
				info("Photo uploaded: ");
				info("EntryID: ", entryId);
				info("message: ", message);

				if entryId then
					uploadCount = uploadCount + 1;
					lastUploadedEntryDate = captureDate;
				end

				if #message > 0 then
		
					messageList[captureTime] = message;
		
				end
			
			else
			
				messageList[captureTime] = LOC("$$$/Blipfoto/Upload/EntryExists=An entry already exists for this date.");
				
			end
			
			progressScope:setPortionComplete(i * 3, photoCount * 3);
			
		end
		
	end
	
	
	LrFunctionContext.postAsyncTaskWithContext( 'Blipfoto Upload',
		function(context)
	
			local plural;
			if photoCount > 1 then plural = "s" else plural = "" end
	
			local message = LOC("$$$/Blipfoto/Upload/Finished=Finished uploading ^1 photo^2", photoCount, plural);
			local messageInfo = "";
			local i, date;
	
			for date, blipMessage in pairs(messageList) do
				date = LrDate.timeToUserFormat(date, "%e %b %Y");
				messageInfo = string.format("%s%s - %s\n", messageInfo, date, blipMessage);
			end
	
			LrDialogs.message(message, messageInfo);
	
		end
	);

	if sendDetails then
		if lastUploadedEntryDate then
			local entryUrl = string.format("http://www.blipfoto.com/%s-%s", BlipfotoUser.getUsername(), lastUploadedEntryDate);
			LrHttp.openUrlInBrowser(entryUrl);
		end
		
	else
	
		local nextStageUrl = string.format("http://www.blipfoto.com/newentry1.5.php");
		LrHttp.openUrlInBrowser(nextStageUrl);
	end
	
	

end
