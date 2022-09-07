@echo off
set /A stp_pgm=0
set /A low_level=40
set /A cr_level=20
set /A max_level=80
set /A sz_time=1
set /A chk_voice=0
set /A get_spkr=1
set /A get_rate=2
set "setBL=body\Set_Battery_Level.txt"
if exist %setBL% (
	call :setBatteryLevel
)
if %stp_pgm%==1 (
	set /A stp_pgm=0 & goto :setLowLevel
)
:: Stop or, Continue
echo.
set /p tmp_stp="Want to STOP Battery-Zira [y/n] ? "
if "%tmp_stp%"=="y" (
	set "stp_pgm=1"
)
if "%tmp_stp%"=="Y" (
	set "stp_pgm=1"
)
if "%tmp_stp%"=="n" (
	set "stp_pgm=0"
)
if "%tmp_stp%"=="N" (
	set "stp_pgm=0"
)
set /A stp_pgm=%stp_pgm%
if %stp_pgm%==1 (goto :skipS)
:setLowLevel
set /A tmp_low=%low_level%
echo.
set /p tmp_low="Enter Battery LOW LEVEL (in %%) : "
set /A tmp_low=%tmp_low%
if %tmp_low% LEQ 0 (goto :setLowLevel)
set /A low_level=%tmp_low%
:setCrLevel
set /A tmp_cr=%cr_level%
echo.
set /p tmp_cr="Enter Battery CRITICAL LEVEL (in %%) : "
set /A tmp_cr=%tmp_cr%
if %tmp_cr% LEQ 0 (goto :setCrLevel)
if %tmp_cr% GEQ %tmp_low% (goto :setLowLevel)
set /A cr_level=%tmp_cr%
:setMaxLevel
set /A tmp_max=%max_level%
echo.
set /p tmp_max="Enter Battery MAXIMUM LEVEL (< 100 in %%) : "
set /A tmp_max=%tmp_max%
if %tmp_max% LEQ 0 (goto :setMaxLevel)
if %tmp_max% LEQ %tmp_low% (goto :setLowLevel)
if %tmp_max% GEQ 100 (goto :setMaxLevel)
set /A max_level=%tmp_max%
:setSzTime
set /A tmp_sz=%sz_time%
echo.
set /p tmp_sz="Enter SNOOZE TIME (in minute(s)) : "
set /A tmp_sz=%tmp_sz%
if %tmp_sz% LEQ 0 (goto :setSzTime)
set /A sz_time=%tmp_sz%
:: Get Voice
echo.
set /p tmp_cv="Do you want VOICE [y/n] ? "
if "%tmp_cv%"=="y" (
	set "chk_voice=1"
)
if "%tmp_cv%"=="Y" (
	set "chk_voice=1"
)
if "%tmp_cv%"=="n" (
	set "chk_voice=0"
)
if "%tmp_cv%"=="N" (
	set "chk_voice=0"
)
set /A chk_voice=%chk_voice%
:: Get Speaker
if %chk_voice%==0 (goto :skipS)
echo.
set /p tmp_gs="Wanna hear ZIRA or, DAVID [z/d] ? "
if "%tmp_gs%"=="z" (
	set "get_spkr=1"
)
if "%tmp_gs%"=="Z" (
	set "get_spkr=1"
)
if "%tmp_gs%"=="d" (
	set "get_spkr=0"
)
if "%tmp_gs%"=="D" (
	set "get_spkr=0"
)
set /A get_spkr=%get_spkr%
:setRate
set /A tmp_gr=%get_rate%
echo.
set /p tmp_gr="Enter VOICE RATE : "
set /A tmp_gr=%tmp_gr%
if %tmp_gr% LEQ 0 (goto :setRate)
set /A get_rate=%tmp_gr%
:skipS
set /A choice=0
echo.
set /p choice="Enter 1 to CONFIRM INITIALIZATION : "
set /A choice=%choice%
if %choice% EQU 1 (goto :confirm) else (goto :end)
:confirm
set /A sz_time=%sz_time% * 60
echo %chk_voice% > %setBL%
echo %low_level%>> %setBL%
echo %cr_level%>> %setBL%
echo %max_level%>> %setBL%
echo %sz_time%>> %setBL%
echo %get_spkr% >> %setBL%
echo %get_rate% >> %setBL%
echo %stp_pgm% >> %setBL%
echo.
echo Values have been saved SUCCESSFULLY !
echo.
pause
:end
exit /b %errorlevel%
:: End of Main Function
:setBatteryLevel
set /A count=0
for /f "tokens=*" %%a in (%setBL%) do (
	call :setValue %%a
)
exit /b 0
:setValue
set /A count=%count% + 1
::if %count%==1 (
::	set /A chk_voice=%~1
::)
if %count%==2 (
	set /A low_level=%~1
)
if %count%==3 (
	set /A cr_level=%~1
)
if %count%==4 (
	set /A max_level=%~1
)
if %count%==5 (
	set /A sz_time=%~1 & call :convMin
)
if %count%==6 (
	set /A get_spkr=%~1
)
if %count%==7 (
	set /A get_rate=%~1
)
if %count%==8 (
	set /A stp_pgm=%~1
)
exit /b 0
:convMin
set /A sz_time=%sz_time% / 60
exit /b 0
