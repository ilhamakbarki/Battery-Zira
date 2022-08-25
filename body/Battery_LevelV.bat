:: Start
@echo off
:: Create TEMP File
set "tmp_val=tmp_val.txt"
WMIC PATH Win32_Battery Get EstimatedChargeRemaining | find /I /V "estimated" > %tmp_val%
set /p level=< %tmp_val%
set /A level=%level%
WMIC Path Win32_Battery Get BatteryStatus | find /I /V "battery" > %tmp_val%
set /p status=< %tmp_val%
set /A status=%status%
if %status%==2 (goto :skip)
WMIC PATH Win32_Battery Get EstimatedRunTime | find /I /V "runtime" > %tmp_val%
set /p runtime=< %tmp_val%
set /A runtime=%runtime%
set /A hr=0
set /A min=0
if %runtime% GEQ 60 (
	set /A hr= %runtime%/60 & set /A min= %runtime% %% 60
)
:skip
:: Delete TEMP File
del %tmp_val%
set "setBI=Battery_Info.txt"
echo %level% percent> %setBI%
if %status%==2 (goto :charging)
if %runtime% LSS 60 (
	call :adjustMin
) else (
	call :adjustHrMin
)
goto :common
:charging
echo charging>> %setBI%
:common
set "file=Battery_Speech.vbs"
if exist %file% (
	wscript /nologo %file%
)
:del_BI
if exist %setBI% (
	del %setBI% & goto :del_BI
)
exit /b %errorlevel%
:: End of Main Function
:adjustMin
if %runtime% LEQ 1 (
	echo %runtime% minute>> %setBI%
) else (
	echo %runtime% minutes>> %setBI%
)
exit /b 0
:adjustHrMin
if %hr% EQU 1 (
	set /p "=%hr% hour " <nul >> %setBI%
) else (
	set /p "=%hr% hours " <nul >> %setBI%
)
if %min% LEQ 1 (
	echo %min% minute>> %setBI%
) else (
	echo %min% minutes>> %setBI%
)
exit /b 0
