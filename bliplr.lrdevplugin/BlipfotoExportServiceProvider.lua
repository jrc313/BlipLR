--[[----------------------------------------------------------------------------

BlipfotoExportServiceProvider.lua
Export service provider description for Blipfoto Flickr uploader

--------------------------------------------------------------------------------

ADOBE SYSTEMS INCORPORATED
 Copyright 2007-2008 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE: Adobe permits you to use, modify, and distribute this file in accordance
with the terms of the Adobe license agreement accompanying it. If you have received
this file from a source other than Adobe, then your use, modification, or distribution
of it requires the prior written permission of Adobe.

------------------------------------------------------------------------------]]

	-- Lightroom SDK
local LrColor = import "LrColor"

	-- Blipfoto plug-in
require 'BlipfotoExportDialogSections'
require 'BlipfotoUploadTask'


--============================================================================--

return {
	
	showSections = {'exportLocation', 'fileNaming', 'fileSettings', 'imageSettings', 'metadata', 'outputSharpening'},
	
	allowFileFormats = {'JPEG'},
	
	allowColorSpaces = {'sRGB'},
	
	hidePrintResolution = true,

	canExportToTemporaryLocation = true,
	
	image = "bliplr-logo.png",
	image_alignment = "flush_left",
	
	exportPresetFields = {
		{ key = 'title',			default = '' },
		{ key = 'description',		default = '' },
		{ key = 'tags',				default = '' },
	},

	startDialog = BlipfotoExportDialogSections.startDialog,
	sectionsForTopOfDialog = BlipfotoExportDialogSections.sectionsForTopOfDialog,

	
	processRenderedPhotos = BlipfotoUploadTask.processRenderedPhotos
	
}
