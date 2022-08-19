@echo off
color 0a
cd ..
echo BUILDING GAME
lime build windows -32 -debug -D 32bits
echo.
echo done.
pause
pwd
explorer.exe export\32bit\debug\windows\bin