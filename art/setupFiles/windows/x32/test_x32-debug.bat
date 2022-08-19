@echo off
color 0a
cd ..
echo BUILDING GAME
lime test windows -32 -debug -D 32bits
echo.
echo done.
pause