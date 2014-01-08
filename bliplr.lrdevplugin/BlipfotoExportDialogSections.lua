--[[----------------------------------------------------------------------------

BlipExportDialogSections.lua
Export dialog customization for Lightroom Blipfoto uploader

--------------------------------------------------------------------------------


------------------------------------------------------------------------------]]

	-- Lightroom SDK
local LrApplication = import "LrApplication"
local LrBinding = import "LrBinding"
local LrView = import "LrView"
local LrTasks = import "LrTasks"
local prefs = import 'LrPrefs'.prefsForPlugin();

local bind = LrView.bind
local share = LrView.share

local logger = import 'LrLogger'('BlipLR')
local debug, info, warn, err = logger:quick( 'debug', 'info', 'warn', 'err' )


--============================================================================--

BlipfotoExportDialogSections = {}

-------------------------------------------------------------------------------

function BlipfotoExportDialogSections.startDialog(propertyTable)

	-- Can't export until we've validated the login.

	info("Starting dialog");

	propertyTable.isAuthenticated = false;
	propertyTable.LR_canExport = false;
	propertyTable.LR_cantExportBecause = LOC("$$$/Blipfoto/ExportDialog/NoLogin=You haven't logged into Blipfoto yet.");
	
	if WIN_ENV then
		propertyTable.EntryDescriptionHelpMsg = LOC("$$$/Blipfoto/ExportDialog/EntryDescriptionHelpWIN=Use CTRL+J to add a new line.");
	else
		propertyTable.EntryDescriptionHelpMsg = LOC("$$$/Blipfoto/ExportDialog/EntryDescriptionHelpOSX=Use ALT+Enter to add a new line.");
	end
	
	-- Find out how many photos we'll be rendering
	local activeCatalog = LrApplication.activeCatalog()
	activeCatalog:withReadAccessDo(
		function()
			local filmstrip = activeCatalog.targetPhotos;
			propertyTable.photoCount = #filmstrip;
			
			info("Counted ", propertyTable.photoCount, " filmstrip photos.");
			if #filmstrip == 1 then
				LrTasks.startAsyncTask(
					function ()
						local activeCatalog = LrApplication.activeCatalog()
						activeCatalog:withReadAccessDo(
							function()
								local photo = filmstrip[1];
								propertyTable.entryTitle = photo:getFormattedMetadata('title');
								propertyTable.entryDescription = photo:getFormattedMetadata('caption');
								propertyTable.entryTags = photo:getFormattedMetadata('keywordTagsForExport');
							end
						);
						
					end
				);
			end
			
			propertyTable.filmstripIsSingleImage = propertyTable.photoCount == 1
			info("We'll be rendering ", propertyTable.photoCount, " photos");
			info("Filmstrip is single image? ", propertyTable.filmstripIsSingleImage);
		end
		
	);
	
	

	propertyTable:addObserver('isAuthenticated',
		function(propertyTable, key, newValue)
			info("isAuthenticated: ", key, ", ", newValue);
			
			setLR_canExport(propertyTable);
		end
	);
	
	propertyTable:addObserver('detailsSource',
		function(propertyTable, key, newValue)
			info("detailsSource: ", key, ", ", newValue);
			propertyTable.showDetailsFields = (newValue == "dialog");
			prefs.detailsSource = newValue;
			
			setLR_canExport(propertyTable)
		end
	);
	
	propertyTable:addObserver('readyToExport',
		function(propertyTable, key, newValue)

			info("readyToExport: ", key, ", ", newValue);

			setLR_canExport(propertyTable);
		end
	);

	-- Make sure we're logged in.
	require 'BlipfotoUser';
	BlipfotoUser.verifyAuthentication(propertyTable);

	propertyTable.detailsSource = propertyTable.filmstripIsSingleImage and prefs.detailsSource or "photo";
	propertyTable.showDetailsFields = (propertyTable.detailsSource == "dialog");
	propertyTable.readyToExport = false;
	
	setLR_canExport(propertyTable);

end

--[[

Only allow the individual to export if they are authenticated and they have checked the readyToSubmit button.
The latter condition is only appropriate if they are entering the photo's details on the export dialog.

--]]
function setLR_canExport(propertyTable)

	info("setLR_canExport:\n isAuthenticated: ", propertyTable.isAuthenticated
	  	, "\ndetailsSource: ", propertyTable.detailsSource
	  	, "\nreadyToExport: ", propertyTable.readyToExport);

	propertyTable.LR_canExport =
		propertyTable.isAuthenticated
		and (propertyTable.detailsSource == "photo" or propertyTable.readyToExport);
	
	if not propertyTable.isAuthenticated then
		propertyTable.LR_cantExportBecause = LOC("$$$/Blipfoto/ExportDialog/NoLogin=You haven't logged into Blipfoto yet.");
	elseif not (propertyTable.detailsSource == "photo" or propertyTable.readyToExport) then
		propertyTable.LR_cantExportBecause = LOC('$$$/Blipfoto/ExportDialog/NotReadyToSubmit=Export is disabled until you mark the "Ready to export" checkbox.');
	else
		propertyTable.LR_cantExportBecause = nil;
	end

end

-------------------------------------------------------------------------------

function BlipfotoExportDialogSections.sectionsForTopOfDialog(f, propertyTable)

	return {
	
		{
			title = LOC "$$$/Blipfoto/ExportDialog/Account=Your Blipfoto Account",
			
			synopsis = bind 'authStatus',

			f:row {
				spacing = f:control_spacing(),

				f:static_text {
					title = bind('authStatus'),
					alignment = 'right',
					fill_horizontal = 1,
					wraps = true
				},
				
				f:push_button {
					width = 130,
					title = bind('authButtonTitle'),
					enabled = bind('authButtonEnabled'),
					action = function()
						require 'BlipfotoUser'
						if propertyTable.isAuthenticated then
							BlipfotoUser.deauthenticate(propertyTable)
						else
							BlipfotoUser.authenticate(propertyTable)
						end
					end,
				},

			},
		},
		{
			title = LOC("$$$/Blipfoto/ExportDialog/EntryDetails=Entry Details"),
			synopsis = bind('entryDetailsStatus'),
			
			f:row
			{
				spacing = f:control_spacing(),
				f:radio_button
				{
					title = LOC("$$$/Blipfoto/ExportDialog/UsePhotoMetada=Use photo's details"),
					value = bind("detailsSource"),
					checked_value = 'photo'
				},
				f:radio_button
				{
					title = LOC("$$$/Blipfoto/ExportDialog/UseEnteredDetails=Enter details below"),
					value = bind("detailsSource"),
					checked_value = 'dialog',
					enabled = bind("filmstripIsSingleImage")
				},
				--[[
				f:radio_button
				{
					title = LOC("$$$/Blipfoto/ExportDialog/EnterOnBlip=Enter details on Blipfoto.com"),
					value = bind("detailsSource"),
					checked_value = 'blip',
					enabled = bind("filmstripIsSingleImage")
				}
				]]--
			},
			f:row {f:spacer {}},
			
			f:row
			{
				f:static_text {
					visible = bind("showDetailsFields"),
					title = LOC("$$$/Blipfoto/ExportDialog/EntryTitle=Entry Title:"),
					alignment = 'right',
					width = share 'labelWidth',
				},

				f:edit_field {
					visible = bind("showDetailsFields"),
					value = bind 'entryTitle',
					fill_horizontal = 1,
				},
			},
			f:row {f:spacer {}},
		
			f:row
			{
				f:static_text {
					visible = bind("showDetailsFields"),
					title = LOC("$$$/Blipfoto/ExportDialog/EntryDescription=Entry Description:"),
					alignment = 'right',
					width = share 'labelWidth',
				},

				f:edit_field {
					visible = bind("showDetailsFields"),
					value = bind 'entryDescription',
					fill_horizontal = 1,
					height_in_lines = 5
				},
			},
			f:row
			{
				f:spacer {
					visible = bind("showDetailsFields"),
					width = share 'labelWidth',
				},
				f:static_text {
					visible = bind("showDetailsFields"),
					title = bind("EntryDescriptionHelpMsg"),
				}
			},
			f:row {f:spacer {}},
		
			f:row
			{
				f:static_text {
					visible = bind("showDetailsFields"),
					title = LOC("$$$/Blipfoto/ExportDialog/EntryTags=Entry Tags:"),
					alignment = 'right',
					width = share 'labelWidth',
				},

				f:edit_field {
					visible = bind("showDetailsFields"),
					value = bind 'entryTags',
					fill_horizontal = 1,
					height_in_lines = 2
				},
			},
			f:row
			{
				f:spacer {
					visible = bind("showDetailsFields"),
					width = share 'labelWidth',
				},

				f:static_text {
					visible = bind("showDetailsFields"),
					title = LOC("$$$/Flickr/ExportDialog/EntryTagsNote=Separate each with a comma.")
				},
			},
			f:row {f:spacer {}},
			
			f:row
			{
				f:spacer {
					visible = bind("showDetailsFields"),
					width = share 'labelWidth',
				},
				f:checkbox
				{
					visible = bind("showDetailsFields"),
					title = LOC("$$$/Blipfoto/ExportDialog/SuppressSubmitOnReturn=Ready to export"),
					value = bind 'readyToExport',
					checked_value = true
				}
			}
		}
	
	}

end

