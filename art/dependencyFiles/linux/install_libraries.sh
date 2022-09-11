#!/bin/bash

# hxCodec Stuff
echo "Installing hxCodec Necessities..."
sudo apt-get install libvlc-dev
sudo apt-get install libvlccore-dev

## https://haxe.org/download/linux/
echo "Installing Haxe..."
sudo add-apt-repository ppa:haxe/releases -y
sudo apt-get update
sudo apt-get install haxe -y
mkdir ~/haxelib && haxelib setup ~/haxelib

echo "Installing Haxe libraries..."

# Regular Haxe Stuff
haxelib install lime
haxelib install openfl
haxelib install flixel
haxelib install flixel-tools
haxelib install flixel-ui
haxelib install flixel-demos
haxelib install flixel-addons
# Not Sure what These are For
haxelib install tjson
haxelib install hxjsonast
# hxCodec
haxelib git hxCodec https://github.com/polybiusproxy/hxcodec
# Scripting and Stuff
haxelib git SScript https://github.com/TahirRollingArch/SScript.git
haxelib git linc_luajit https://github.com/nebulazorua/linc_luajit
haxelib git hxvm-luajit https://github.com/nebulazorua/hxvm-luajit
haxelib install hscript
haxelib git hscript-ex https://github.com/ianharrigan/hscript-ex
# Polymod
haxelib install polymod 1.5.2
# SWF Support
haxelib install swf 3.1.0
# Discord RPC
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
# Systools
haxelib git systools https://github.com/haya3218/systools
# This is for extension-webm but WHATEVER
haxelib install actuate

echo "Joalor64 Engine highly recommends installing Visual Studio Code, which is a free and open-source IDE."
echo "Download it here: https://code.visualstudio.com/"
echo "Once installed, open the command line and type 'code' to open the IDE."

echo ""
echo "Setup is complete. Have fun!"