--[[----------------------------------------------------------------------------

BlipfotoPluginInfoProvider.lua
Plugin info provider description for Blipfoto uploader

--------------------------------------------------------------------------------

ADOBE SYSTEMS INCORPORATED
 Copyright 2007-2008 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE: Adobe permits you to use, modify, and distribute this file in accordance
with the terms of the Adobe license agreement accompanying it. If you have received
this file from a source other than Adobe, then your use, modification, or distribution
of it requires the prior written permission of Adobe.

------------------------------------------------------------------------------]]

local LrBinding = import 'LrBinding'
local LrView = import 'LrView'
local LrDialogs = import 'LrDialogs'
local LrErrors = import 'LrErrors'
local LrFunctionContext = import 'LrFunctionContext'
local LrHttp = import 'LrHttp'
local LrDate = import 'LrDate'
local LrFileUtils = import 'LrFileUtils'

local logger = import 'LrLogger'('BlipLR')
local debug, info, warn, err = logger:quick( 'debug', 'info', 'warn', 'err' )

--============================================================================--

local bind = LrView.bind

--------------------------------------------------------------------------------

local props =
{
	major = 1,
	minor = 7,
	revision = 0,
	build = 20140108,
	display = "1.7",
	pluginUrl = "http://www.jrc313.com/bliplr-lightroom-plugin/",
	versionUrl = "http://www.jrc313.com/projects/lightroom/bliplr/version.txt"
};

--------------------------------------------------------------------------------

Version = {}

--------------------------------------------------------------------------------

function Version.newVersionIsAvailable()

	info("Calling: ", props.versionUrl);
	local versionResponse = LrHttp.get(props.versionUrl);
	info(string.format("Got %s version back.", versionResponse));
	
	local availableVersion = tonumber(versionResponse);
	info(string.format("Got %d numeric version back.", availableVersion));
	
	return availableVersion > props.build;

end



function Version.checkVersion(propertyTable)

	propertyTable.newVersionIsAvailable = false;
	propertyTable.newVersionText = LOC('$$$/Blipfoto/PluginInfo/Version/CheckingVersion=Checking for a new version ...');
	
	LrFunctionContext.postAsyncTaskWithContext( 'BlipLR Version Check',
		function(context)
			if Version.newVersionIsAvailable() then
				propertyTable.newVersionText = LOC('$$$/Blipfoto/PluginInfo/Version/NewVersion=A new version is available!');
				propertyTable.newVersionIsAvailable = true;
			else
				propertyTable.newVersionText = LOC('$$$/Blipfoto/PluginInfo/Version/NoNewVersion=You have the latest version.');
				propertyTable.newVersionIsAvailable = false;
			end
		end
	);
	
end



function Version.getLatestVersion()

	LrHttp.openUrlInBrowser(props.pluginUrl);
	
end

--------------------------------------------------------------------------------

return {

	startDialog = function(propertyTable)

		Version.checkVersion(propertyTable);
		
	end,
	
	endDialog = function(propertyTable)

	end,

	sectionsForTopOfDialog = function(f, propertyTable)
		return {
			{
				
				bind_to_object = propertyTable,
				title = LOC("$$$/Blipfoto/PluginInfo/Title=BlipLR Version Check"),
				synopsis =	bind
							{
								key = 'newVersionText',
								object = propertyTable
							},

				f:row {
					spacing = f:control_spacing(),

					f:static_text
					{
						title = bind('newVersionText'),
						fill_horizontal = 1,
						wraps = true
					},
					
					f:push_button
					{
						title = LOC("$$$/Blipfoto/PluginInfo/Version/UpgradeButton=Visit download page"),
						visible = bind("newVersionIsAvailable"),
						action = function()
						
							Version.getLatestVersion()
						
						end
					}

				},
			}
		};
	end,
	
	sectionsForBottomOfDialog = function(f, propertyTable) end
};
