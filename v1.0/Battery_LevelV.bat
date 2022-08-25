@echo off
WMIC PATH Win32_Battery Get EstimatedChargeRemaining | find /I /V "estimated" > tmp_val.txt
set /p level=< tmp_val.txt
set /A level=%level%
WMIC Path Win32_Battery Get BatteryStatus | find /I /V "battery" > tmp_val.txt
set /p status=< tmp_val.txt
set /A status=%status%
WMIC PATH Win32_Battery Get EstimatedRunTime | find /I /V "runtime" > tmp_val.txt
if %status%==2 (goto :skip)
set /p runtime=< tmp_val.txt
set /A runtime=%runtime%
set /A hr=0
set /A min=0
if %runtime% GEQ 60 (
	set /A hr= %runtime%/60 & set /A min= %runtime% %% 60
)
:skip
del tmp_val.txt
echo Battery level is %level% percent> Battery_Info.txt
if %status%==2 (goto :charging)
if %runtime% LSS 60 (
	call :adjustMin
) else (
	call :adjustHrMin
)
set /A wait=11
goto :common
:charging
echo Plugged in, charging>> Battery_Info.txt
set /A wait=7
:common
start Battery_Speech.vbs
ping 127.0.0.1 -n %wait% > nul
:del_BI
if exist Battery_Info.txt (
	del Battery_Info.txt & goto :del_BI
)
exit /b %errorlevel%
:adjustMin
if %runtime% LEQ 1 (
	echo Estimated time left is %runtime% minute>> Battery_Info.txt
) else (
	echo Estimated time left is %runtime% minutes>> Battery_Info.txt
)
exit /b 0
:adjustHrMin
if %hr% EQU 1 (
	set /p "=Estimated time left is %hr% hour " <nul >> Battery_Info.txt & goto :adMin
)
set /p "=Estimated time left is %hr% hours " <nul >> Battery_Info.txt
:adMin
if %min% LEQ 1 (
	echo %min% minute>> Battery_Info.txt
) else (
	echo %min% minutes>> Battery_Info.txt
)
exit /b 0
