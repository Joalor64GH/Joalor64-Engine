@echo off

title Joalor64 Engine Setup
echo Before continuing, please install the latest version of Haxe (v4.2.4).
echo https://haxe.org/download/
echo Press any key to install the following libraries...
pause >nul
title Joalor64 Engine Setup - Installing libraries
echo Installing haxelib libraries...
haxelib install lime
haxelib install openfl
haxelib install flixel
haxelib install flixel-tools
haxelib install flixel-ui
haxelib install flixel-demos
haxelib install flixel-addons
title Joalor64 Engine Setup - User action required
cls
haxelib run flixel-tools setup
haxelib run lime setup flixel
cls
echo Make sure you have git installed. You can download it here: https://git-scm.com/downloads
echo Press any key to install necessary libraries.
pause >nul
title Joalor64 Engine Setup - Installing libraries
haxelib install tjson
haxelib install hxjsonast
haxelib git hxCodec https://github.com/polybiusproxy/hxcodec
haxelib git SScript https://github.com/TahirRollingArch/SScript.git
haxelib git linc_luajit https://github.com/nebulazorua/linc_luajit
haxelib git hxvm-luajit https://github.com/nebulazorua/hxvm-luajit
haxelib install hscript 
haxelib git hscript-ex https://github.com/ianharrigan/hscript-ex
haxelib install firetongue
haxelib install polymod 1.5.2
haxelib install swf 3.1.0
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib git extension-webm https://github.com/KadeDev/extension-webm
haxelib run lime rebuild extension-webm windows
haxelib git systools https://github.com/haya3218/systools
haxelib install actuate
cls
goto CommunitySetup

:CommunitySetup
cls
title FNF Setup - User action required
set /p menu="Would you like to install Visual Studio Community and components? (Necessary to compile/ 5.5GB) [Y/N]"
       if %menu%==Y goto InstallVSCommunity
       if %menu%==y goto InstallVSCommunity
       if %menu%==N goto SkipVSCommunity
       if %menu%==n goto SkipVSCommunity
       cls


:SkipVSCommunity
cls
title Joalor64 Engine Setup - Success
echo Setup successful. Press any key to exit.
pause >nul
exit

:InstallVSCommunity
title Joalor64 Engine Setup - Installing Visual Studio Community
curl -# -O https://download.visualstudio.microsoft.com/download/pr/3105fcfe-e771-41d6-9a1c-fc971e7d03a7/8eb13958dc429a6e6f7e0d6704d43a55f18d02a253608351b6bf6723ffdaf24e/vs_Community.exe
vs_Community.exe --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK.19041 -p
del vs_Community.exe
goto SkipVSCommunity
