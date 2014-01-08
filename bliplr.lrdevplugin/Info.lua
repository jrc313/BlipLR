--[[----------------------------------------------------------------------------

Info.lua
bliplr plugin
Summary information for Bliplr Export Filter plugin
--------------------------------------------------------------------------------

------------------------------------------------------------------------------]]

return
{

	LrPluginName = "BlipLR",

	LrSdkVersion = 2.0,
	LrSdkMinimumVersion = 2.0, -- minimum SDK version required by this plug-in

	LrToolkitIdentifier = 'com.jrc313.lightroom.export.blipfoto',
	
	LrPluginInfoUrl = "http://www.jrc313.com/bliplr-lightroom-plugin/",
	
	LrPluginInfoProvider = "BlipfotoPluginInfo.lua",
	
	LrLibraryMenuItems = {
		title = LOC("$$$/Blipfoto/ExportUsingDefaults=Export to Blipfoto Using Defaults"),
		file = 'ExportToBlip.lua',
		enabledWhen = 'photosSelected',
	},
	
	LrExportMenuItems = {
		{
			title = LOC("$$$/Blipfoto/ExportUsingDefaults=Export to Blipfoto Using Defaults"),
			file = 'ExportToBlip.lua',
			enabledWhen = 'photosSelected',
		},
	},
	
	LrExportServiceProvider = {
		title = LOC("$$$/Blipfoto/Blipfoto=Blipfoto"),
		file = 'BlipfotoExportServiceProvider.lua',
		builtInPresetsDir = "presets",
	},

	VERSION =
	{
		display = "1.7"
	},

}
