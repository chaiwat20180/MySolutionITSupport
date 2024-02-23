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
@echo off
:: Update the time zone to UTC+07:00
tzutil /s "SE Asia Standard Time"

:: Stop the Windows Time service to apply new settings
net stop w32time

:: Configure the system to use Google's NTP server
w32tm /config /manualpeerlist:"pool.ntp.org" /syncfromflags:manual /reliable:YES /update

:: Start the Windows Time service
net start w32time

:: Force the system to synchronize the time with the NTP server
w32tm /resync

:: Set short date format to dd-MMM-yy
reg add "HKCU\Control Panel\International" /v sShortDate /t REG_SZ /d "dd-MMM-yy" /f

:: Set long date format to d MMMM, yyyy
reg add "HKCU\Control Panel\International" /v sLongDate /t REG_SZ /d "d MMMM, yyyy" /f

:: Set short time format to HH:mm
reg add "HKCU\Control Panel\International" /v sTimeFormat /t REG_SZ /d "H:mm" /f

:: Set long time format to HH:mm:ss
reg add "HKCU\Control Panel\International" /v sLongTime /t REG_SZ /d "HH:mm:ss" /f
	
echo Time zone updated to UTC+07:00 and system time synchronized with pool.ntp.org NTP server.


echo "Date & Time Complete....."
timeout /t 5

:: ========== Disconnect the shared drive ========== 
net use %SHARE% /delete

endlocal
:: =================================================
exit