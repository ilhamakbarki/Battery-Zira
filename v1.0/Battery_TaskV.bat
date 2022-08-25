:: Start of the Program
@echo off
cmd /c Battery_LevelV.bat
set /A low_level=40
set /A cr_level=20
set /A max_level=80
set /A full_level=100
set /A sz_time=60
set /A low_not=1
set /A cr_not=1
set /A max_not=1
set /A full_not=1
:loop
if exist Set_Battery_Level.txt (
	call :setBatteryLevel
)
set /A wait=%sz_time%
WMIC Path Win32_Battery Get BatteryStatus | find /I /V "battery" > tmp_val.txt
set /p status=< tmp_val.txt
set /A status=%status%
:: SET All Status
if %status%==2 (goto :SET_MAXFL_REM)
:: Set Low and Critical Reminder Status
if exist Set_LowCr_Rem.txt (call :setLowCrRem)
goto :reset
:SET_MAXFL_REM
:: Set Maximum and Full Reminder Status
if exist Set_MaxFl_Rem.txt (call :setMaxFlRem)
:: RESET All Status
:reset
if %status%==1 (goto :RESET_MAXFL_REM)
:: Reset Low and Critical Reminder Status
if exist Set_LowCr_Rem.txt (call :resetLowCrRem)
goto :continue
:RESET_MAXFL_REM
:: Reset Maximum and Full Reminder Status
if exist Set_MaxFl_Rem.txt (call :resetMaxFlRem)
:continue
WMIC PATH Win32_Battery Get EstimatedChargeRemaining | find /I /V "estimated" > tmp_val.txt
set /p level=< tmp_val.txt
del tmp_val.txt
set /A level=%level%
if %status%==2 (goto :GET_MAX_REM)
:: Check Low Reminder Status
if %level% GTR %low_level% (goto :end)
if %low_not%==0 (goto :check_critical)
if %level% GTR %cr_level% (
	start Get_Low_Notify.vbs & goto :addV
)
:: Check Critical Reminder Status
:check_critical
if %cr_not%==0 (goto :end)
if %level% LEQ %cr_level% (
	start Get_Critical_Notify.vbs & goto :addV
)
goto :end
:GET_MAX_REM
:: Check Maximum Reminder Status
if %level% LSS %max_level% (goto :end)
if %max_not%==0 (goto :check_full)
if %level% LSS %full_level% (
	start Get_Max_Notify.vbs & goto :addV
)
:: Check Full Reminder Status
:check_full
if %full_not%==0 (goto :end)
if %level% GEQ %full_level% (
	start Get_Full_Notify.vbs & goto :addV
)
goto :end
:addV
set /A wait=%wait% + 10
cmd /c Battery_LevelV.bat
:end
ping 127.0.0.1 -n %wait% > nul
goto :loop
exit /b %errorlevel%
:: End of Main Function
:: Battery Level Initialization Function
:setBatteryLevel
set /A count=0
for /f "tokens=*" %%a in (Set_Battery_Level.txt) do (
	call :setValue %%a
)
exit /b 0
:setValue
set /A count=%count% + 1
if %count%==1 (
	set /A low_level=%~1
)
if %count%==2 (
	set /A cr_level=%~1
)
if %count%==3 (
	set /A max_level=%~1
)
if %count%==4 (
	set /A sz_time=%~1
)
exit /b 0
:: Status SET Functions
:: Set Low and Critical Reminder Status Function
:setLowCrRem
set /A count=0
for /f "tokens=*" %%a in (Set_LowCr_Rem.txt) do (
	call :setLCValue %%a
)
exit /b 0
:setLCValue
set /A count=%count% + 1
if %count%==1 (
	set /A low_not=%~1
)
if %count%==2 (
	set /A cr_not=%~1
)
exit /b 0
:: Set Maximum and Full Reminder Status Function
:setMaxFlRem
set /A count=0
for /f "tokens=*" %%a in (Set_MaxFl_Rem.txt) do (
	call :setMFValue %%a
)
exit /b 0
:setMFValue
set /A count=%count% + 1
if %count%==1 (
	set /A max_not=%~1
)
if %count%==2 (
	set /A full_not=%~1
)
exit /b 0
:: Status RESET Functions
:: Reset Low and Critical Reminder Status Function
:resetLowCrRem
del Set_LowCr_Rem.txt
set /A low_not=1
set /A cr_not=1
exit /b 0
:: Reset Maximum and Full Reminder Status Function
:resetMaxFlRem
del Set_MaxFl_Rem.txt
set /A max_not=1
set /A full_not=1
exit /b 0
:: End of the Program
