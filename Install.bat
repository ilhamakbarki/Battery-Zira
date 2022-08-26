@echo off
echo.
set "tab=        "
set "short=Launch_BAT - SC.lnk"
set "target=%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
set "pathS=%target%\%short%"
if exist "%pathS%" (
	call :reinstall
) else (
	call :install
)
echo.
pause
exit /b %errorlevel%
:: End of Main
:install
set /A choice=0
set /p tmp_ch="Confirm Install [y/n] ? "
if "%tmp_ch%"=="y" (
	set "choice=1"
)
if "%tmp_ch%"=="Y" (
	set "choice=1"
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
	call :execTask
) else (
	call :dispSkip
)
exit /b 0
:reinstall
set /A choice=0
set /p tmp_ch="Want to Re-Install [y/n] ? "
if "%tmp_ch%"=="y" (
	set "choice=1"
)
if "%tmp_ch%"=="Y" (
	set "choice=1"
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
	call :trigger
) else (
	call :dispSkip
)
exit /b 0
:execTask
set "file=Create_ShortLB.vbs"
if exist %file% (
	wscript /nologo %file% & goto :oktp
) else (
	echo %tab%Couldn't Create SHORTCUT !
)
goto :exitET
:oktp
if exist "%short%" (
	goto :checkTarget
) else (
	call :failTask & goto :exitET
)
:checkTarget
if exist "%target%" (
	call :loopMove & call :trigger
) else (
	call :failTask
)
:exitET
exit /b 0
:loopMove
echo.
if exist "%short%" (
	move /y "%short%" "%target%" & goto :loopMove
)
exit /b 0
:trigger
if exist "%pathS%" (
	cmd /c "%pathS%" & call :dispSuccess
) else (
	echo %tab%Installation ABORTED !
)
exit /b 0
:failTask
echo %tab%Installation FAILED !
exit /b 0
:dispSuccess
echo %tab%Installation COMPLETE !
echo.
exit /b 0
:dispSkip
echo %tab%Installation SKIPPED !
exit /b 0
