@echo off
setlocal
net session >nul 2>&1
if %errorlevel% == 0 (
    echo Success: Run with Administrative Mode.
) else (
    echo Failure,Please run this script as an Administrator Mode.
    timeout /t 5
    exit /b
)
:: Login sample \\107.101.101.31\000. Initial Programs
set SHARE="Path Share Drive"
set USER="Username"
set PWD="Password"

:: ========== Map the shared drive ==========
net use %SHARE% %PWD% /user:%USER%
:: ==========================================

:: ========== Update Date & Time ========== 
@echo off
:: Update the time zone to UTC+07:00
tzutil /s "SE Asia Standard Time"

:: Stop the Windows Time service to apply new settings
net stop w32time

pushd %SHARE%\"88-Other\Regedit"
regedit /s TimeDate.reg
popd
if %errorlevel% equ 0 (
    echo Registry update complete
) else (
    echo Registry update Failed
    popd
)

:: Configure the system to use Google's NTP server
w32tm /config /manualpeerlist:"pool.ntp.org" /syncfromflags:manual /reliable:YES /update

:: Start the Windows Time service
net start w32time

:: Force the system to synchronize the time with the NTP server
w32tm /resync


echo "Date & Time Complete....."
timeout /t 5
:: =====================================

:: ========== Disconnect the shared drive ========== 
net use %SHARE% /delete

endlocal
:: =================================================
exit
