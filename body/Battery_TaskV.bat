:: Start of the Program
@echo off
set /A chk_voice=1
set /A low_level=40
set /A cr_level=20
set /A max_level=80
set /A full_level=100
set /A sz_time=60
set /A low_not=1
set /A cr_not=1
set /A max_not=1
set /A full_not=1
set "setBL=Set_Battery_Level.txt"
if exist %setBL% (
	goto :checkV
) else (
	goto :break
)
:checkV
set /p chk_voice=< %setBL%
set /A chk_voice=%chk_voice%
:break
set "batLV=Battery_LevelV.bat"
if %chk_voice%==1 (
	if exist %batLV% (
		cmd /c %batLV%
	)
)
:loop
if exist %setBL% (
	call :setBatteryLevel
)
set /A wait=%sz_time%
:: Create TEMP File
set "tmp_val=tmp_val.txt"
WMIC Path Win32_Battery Get BatteryStatus | find /I /V "battery" > %tmp_val%
set /p status=< %tmp_val%
set /A status=%status%
:: SET All Status
set "lowcr_stat=Set_LowCr_Rem.txt"
set "maxfl_stat=Set_MaxFl_Rem.txt"
if %status%==2 (goto :SET_MAXFL_REM)
:: Set Low and Critical Reminder Status
if exist %lowcr_stat% (call :setLowCrRem)
goto :reset
:SET_MAXFL_REM
:: Set Maximum and Full Reminder Status
if exist %maxfl_stat% (call :setMaxFlRem)
:: RESET All Status
:reset
if %status%==1 (goto :RESET_MAXFL_REM)
:: Reset Low and Critical Reminder Status
if exist %lowcr_stat% (call :resetLowCrRem)
goto :continue
:RESET_MAXFL_REM
:: Reset Maximum and Full Reminder Status
if exist %maxfl_stat% (call :resetMaxFlRem)
:continue
:: Check for Voice Files
set "low_voice=Get_Low_Notify.vbs"
set "cr_voice=Get_Critical_Notify.vbs"
set "max_voice=Get_Max_Notify.vbs"
set "full_voice=Get_Full_Notify.vbs"
if exist %low_voice% (goto :chk_crV) else (goto :stop)
:chk_crV
if exist %cr_voice% (goto :chk_maxV) else (goto :stop)
:chk_maxV
if exist %max_voice% (goto :chk_fullV) else (goto :stop)
:chk_fullV
if exist %full_voice% (goto :compl_chkV) else (goto :stop)
:compl_chkV
WMIC PATH Win32_Battery Get EstimatedChargeRemaining | find /I /V "estimated" > %tmp_val%
set /p level=< %tmp_val%
:: Delete TEMP File
del %tmp_val%
set /A level=%level%
if %status%==2 (goto :GET_MAX_REM)
:: Check Low Reminder Status
if %level% GTR %low_level% (goto :end)
if %low_not%==0 (goto :check_critical)
if %level% GTR %cr_level% (
	start %low_voice% & goto :addV
)
:: Check Critical Reminder Status
:check_critical
if %cr_not%==0 (goto :end)
if %level% LEQ %cr_level% (
	start %cr_voice% & goto :addV
)
goto :end
:GET_MAX_REM
:: Check Maximum Reminder Status
if %level% LSS %max_level% (goto :end)
if %max_not%==0 (goto :check_full)
if %level% LSS %full_level% (
	start %max_voice% & goto :addV
)
:: Check Full Reminder Status
:check_full
if %full_not%==0 (goto :end)
if %level% GEQ %full_level% (
	start %full_voice% & goto :addV
)
goto :end
:addV
if %chk_voice%==0 (
	goto :end
)
:: User prompts stay for 10s
set /A wait=%wait% + 10
if exist %batLV% (
	cmd /c %batLV%
)
:end
ping 127.0.0.1 -n %wait% > nul
goto :loop
:stop
exit /b %errorlevel%
:: End of Main Function
:: Battery Level Initialization Function
:setBatteryLevel
set /A count=0
for /f "tokens=*" %%a in (%setBL%) do (
	call :setValue %%a
)
exit /b 0
:setValue
set /A count=%count% + 1
if %count%==1 (
	set /A chk_voice=%~1
)
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
	set /A sz_time=%~1
)
exit /b 0
:: Status SET Functions
:: Set Low and Critical Reminder Status Function
:setLowCrRem
set /A count=0
for /f "tokens=*" %%a in (%lowcr_stat%) do (
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
for /f "tokens=*" %%a in (%maxfl_stat%) do (
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
del %lowcr_stat%
set /A low_not=1
set /A cr_not=1
exit /b 0
:: Reset Maximum and Full Reminder Status Function
:resetMaxFlRem
del %maxfl_stat%
set /A max_not=1
set /A full_not=1
exit /b 0
:: End of the Program
