#!/usr/bin/env bash

rm -rf bliplr.lrplugin
rm bliplr.lrplugin.zip
cp -R bliplr.lrdevplugin bliplr.lrplugin

LUAFILES=bliplr.lrplugin/*.lua

for luaFile in ${LUAFILES}
do
	
	luac -o ${luaFile}c ${luaFile}
	rm ${luaFile}
	mv ${luaFile}c ${luaFile}
	
done

rm bliplr.lrplugin/.DS_Store

zip -r bliplr.lrplugin.zip bliplr.lrplugin

echo "Done!"