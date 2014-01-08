--[[----------------------------------------------------------------------------

ExportToBlip.lua
Main script to drive Blipfoto export process

--------------------------------------------------------------------------------

------------------------------------------------------------------------------]]

	-- Lightroom SDK
local LrApplication = import 'LrApplication'
local LrExportSession = import 'LrExportSession'
local LrTasks = import 'LrTasks'


LrTasks.startAsyncTask( function()

	local activeCatalog = LrApplication.activeCatalog()
	local filmstrip = activeCatalog.targetPhotos
	
	local exportSession = LrExportSession{
								exportSettings = {
									LR_exportServiceProvider = 'com.jrc313.lightroom.export.blipfoto'
								},
								photosToExport = filmstrip }
	
	exportSession:doExportOnCurrentTask()

end )
