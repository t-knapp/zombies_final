@echo off

set coddir=C:\Games\Call of Duty 1.1\main

goto wtf

echo **** Updating...
echo.

echo ./zombies
cd ../../../zombies
copy /Y *.* "%coddir%\zombies"
echo ./modules
cd ../modules
copy /Y *.* "%coddir%\modules"
echo ./maps/mp/gametypes
cd ../maps/mp/gametypes
copy /Y *.* "%coddir%\maps\mp\gametypes"

echo.
echo **** Update complete.
pause

:wtf
cd ./code
7z a -tzip __zombies.pk3 *
copy /Y __zombies.pk3 "%coddir%\"
del __zombies.pk3
cd ..
pause