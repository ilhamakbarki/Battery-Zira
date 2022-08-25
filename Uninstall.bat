@echo off
echo.
set "tab=        "
set /A choice=0
set /p tmp_ch="Confirm Uninstall [y/n] ? "
if "%tmp_ch%"=="y" (
	set "choice=1"
)
if "%tmp_ch%"=="Y" (
	set "tmp_ch=1"
)
if "%tmp_ch%"=="n" (
	set "choice=0"
)
if "%tmp_ch%"=="N" (
	set "choice=0"
)
set /A choice=%choice%
echo.
if %choice%==1 (
	goto :oktp
) else (
	call :dispSkip & goto :end
)
:oktp
set "short=Launch_BAT - SC.lnk"
set "target=%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
set "pathS=%target%\%short%"
if exist "%pathS%" (
	call :execTask
) else (
	call :failTask
)
:end
echo.
pause
exit /b %errorlevel%
:: End of Main
:execTask
del "%pathS%"
set /A choice=1
set /p tmp_ch="Do you want to RESTART [y/n] ? "
if "%tmp_ch%"=="y" (
	set "choice=1"
)
if "%tmp_ch%"=="Y" (
	set "tmp_ch=1"
)
if "%tmp_ch%"=="n" (
	set "choice=0"
)
if "%tmp_ch%"=="N" (
	set "choice=0"
)
set /A choice=%choice%
echo.
if %choice%==1 (
	call :dispSuccess
) else (
	echo %tab%Please RESTART Manually to COMPLETE Uninstall . . .
)
exit /b 0
:failTask
echo %tab%Uninstall ABORTED !
exit /b 0
:dispSuccess
echo %tab%Uninstall INITIATED !
shutdown /r
exit /b 0
:dispSkip
echo %tab%Uninstall SKIPPED !
exit /b 0
