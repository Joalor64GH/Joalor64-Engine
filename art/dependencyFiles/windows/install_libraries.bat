@echo off

title Joalor64 Engine Setup
echo Before continuing, please install the latest version of Haxe (v4.2.4).
echo https://haxe.org/download/
echo Press any key to continue...
pause >nul

REM Install dependencies

echo Installing Haxe libraries...

REM Regular Haxe Stuff
haxelib install lime
haxelib install openfl
haxelib install flixel
haxelib install flixel-tools
haxelib install flixel-ui
haxelib install flixel-demos
haxelib install flixel-addons
REM Not Sure what These are For
haxelib install tjson
haxelib install hxjsonast
REM hxCodec
haxelib git hxCodec https://github.com/polybiusproxy/hxcodec
REM Scripting and Stuff
haxelib git SScript https://github.com/TahirRollingArch/SScript.git
haxelib git linc_luajit https://github.com/nebulazorua/linc_luajit
haxelib git hxvm-luajit https://github.com/nebulazorua/hxvm-luajit
haxelib install hscript 
haxelib git hscript-ex https://github.com/ianharrigan/hscript-ex
REM Polymod
haxelib install polymod 1.5.2
REM SWF Support
haxelib install swf 3.0.2
REM Discord RPC
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
REM extension-webm
haxelib git extension-webm https://github.com/KadeDev/extension-webm
haxelib run lime rebuild extension-webm windows
REM Systools
haxelib git systools https://github.com/haya3218/systools
REM Also extension-webm
haxelib install actuate

REM Install Visual Studio tools
echo Visual Studio Community Edition and Windows 10 SDK 1901 are required dependencies for Enigma Engine.
echo Total required disk space: ~5.5GB
echo If you have already successfully built Friday Night Funkin' mods in the past, you can skip this step.
echo Would you like to install them now?
CHOICE /C YN 
IF %ERRORLEVEL% EQU 1 goto InstallWindowsSDK
IF %ERRORLEVEL% EQU 2 goto SkipInstallWindowsSDK

:InstallWindowsSDK
echo Installing Windows 10 SDK...
curl -# -O https://download.visualstudio.microsoft.com/download/pr/7aa16be3-9952-4bd2-8ecf-eae91faa0a06/14fe35fa35c305b03032a885ff3ebefaf88fce5051ee84183d4c5de75783339e/vs_Community.exe
vs_Community.exe --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK.19041 -p
del vs_Community.exe

:SkipInstallWindowsSDK

echo Joalor64 Engine highly recommends installing Visual Studio Code, which is a free and open-source IDE.
echo Would you like to install it now?
CHOICE /C YN
IF %ERRORLEVEL% EQU 1 goto InstallVSCode
IF %ERRORLEVEL% EQU 2 goto SkipInstallVSCode

:InstallVSCode
echo Installing Visual Studio Code...
curl -# -o vs_code.exe -O https://code.visualstudio.com/sha/download?build=stable&os=win32-x64
vs_code.exe
del vs_code.exe

:SkipInstallVSCode

echo Setup is complete. Have fun!