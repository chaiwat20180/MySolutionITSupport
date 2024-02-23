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
:: Login
set SHARE="\\107.101.101.31\000. Initial Programs"
set USER="chaiwat.k"
set PWD="sds@th20230"

:: ========== Map the shared drive ==========
net use %SHARE% %PWD% /user:%USER%
:: ==========================================

:: ============== Install Standard Software =======================
:: Software 1 Certificate
pushd %SHARE%\"00.Certificate Software (SDS)"
start /wait cert.exe /SILENT
popd
if %errorlevel% equ 0 (
    echo Certificate Install Complete
) else (
    echo Certificate Install Failed
    popd
)

:: Software 2 Microsoft Office
pushd %SHARE%\"01 MS Office\MS Office 2016\MS_Office_2016_64bit_eng"
start /wait setup.exe 
popd
if %errorlevel% equ 0 (
    echo MS Office 2016 Install Complete
) else (
    echo MS Office 2016 Install Failed
    popd
)

:: Software 3 PDF
pushd %SHARE%\"08 PDF Reader\Adobe Acrobat Reader DC"
start /wait AcroRdrDC2100120155_en_US.exe /SILENT
popd
if %errorlevel% equ 0 (
    echo Adobe Acrobat Reader DC Install Complete
) else (
    echo Adobe Acrobat Reader DC Install Failed
    popd
)

:: Software 4 Foxit
pushd %SHARE%\"08 PDF Reader\Foxit Reader"
start /wait FoxitReader101_Setup_Prom_IS.exe /SILENT
popd
if %errorlevel% equ 0 (
    echo Foxit Reader Install Complete
) else (
    echo Foxit Reader Install Failed
    popd
)

:: Software 5 7-Zip
pushd %SHARE%\"09 7-Zip"
start /wait 7z1805-x64.exe /SILENT
popd
if %errorlevel% equ 0 (
    echo 7-Zip Install Complete
) else (
    echo 7-Zip Install Failed
    popd
)

:: Software 6 Google Chrome
pushd %SHARE%\"23.Chrome 32 bit"
start /wait ChromeStandaloneSetup.exe /silent /install
popd

if %errorlevel% equ 0 (
    ren "C:\Program Files (x86)\Google\Update" "Update.bak"
    echo Google Chrome Install Complete
) else (
    echo Google Chrome Install Failed 
    popd
)

:: =====================================

:: ========== SAP ======================
pushd %SHARE%\"11. SAP\SAP 760 for PU\SAPGUI_760"
start /wait SetupAll.exe
popd
if %errorlevel% equ 0 (
    echo SAP Install Complete
) else (
    echo SAP Install Failed
    popd
)

pushd %SHARE%\"11. SAP\SAP 760 for PU"
start /wait GUI760_7-80003144.exe
popd
if %errorlevel% equ 0 (
    echo GUI760 Install Complete
) else (
    echo GUI760 Install Failed
    popd
)

pushd %SHARE%\"11. SAP\SAP 760 for PU"
start /wait NWBC700_9-70003080.exe
popd
if %errorlevel% equ 0 (
    echo NWBC Install Complete
) else (
    echo NWBC Install Failed
    popd
)

start "" "C:\Program Files (x86)\SAP\FrontEnd\SapGui\saplogon.exe"
timeout /t 10 /nobreak
taskkill /IM saplogon.exe /F

pushd %SHARE%\"11. SAP\SAP 760 for PU\hosts_files"
copy SAPUILandscape.xml "C:\Users\%USERNAME%\AppData\Roaming\SAP\Common"
if %errorlevel% equ 0 (
    echo Copy SAPUILandscape.xml Files Complete
) else (
    echo Copy SAPUILandscape.xml Files Failed
)

pushd %SHARE%\"11. SAP\SAP 760 for PU\hosts_files"
copy hosts "C:\Windows\System32\drivers\etc"
if %errorlevel% equ 0 (
    echo Copy hosts Files Complete
) else (
    echo Copy hosts Files Failed
)
:: =====================================

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

:: ========== Add Register Files ========== 
pushd %SHARE%\"88-Other\Regedit"
regedit /s FixPolicyWindowsUpdate_SDS.reg
popd
if %errorlevel% equ 0 (
    echo Registry update complete
) else (
    echo Registry update Failed
    popd
)
:: =====================================

:: ==========  Set password for a local user account ========== 
set "local_user=SDSTH"
set "local_password=sdsth"
net user "%local_user%" "%local_password%"
if %errorlevel% equ 0 (
    echo The Password has been successfully set to "sdsth".
) else (
    echo Failed to set password for user USERNAME. Because user not found
)

:: ========== Disconnect the shared drive ========== 
net use %SHARE% /delete

endlocal
:: =================================================
