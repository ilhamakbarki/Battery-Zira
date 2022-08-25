@echo off
set "TAB=        "
echo.
echo %TAB%Starting BATTERY MONITOR . . .
echo.
set "folder=body"
if exist %folder% (
	goto :chkFile
) else (
	echo Folder "%folder%" NOT FOUND !
)
echo.
goto :end
:chkFile
cd /d "%folder%"
set "file=Run_BAT.vbs"
if exist %file% (
	start %file%
) else (
	echo File "%file%" NOT FOUND !
)
echo.
:end
