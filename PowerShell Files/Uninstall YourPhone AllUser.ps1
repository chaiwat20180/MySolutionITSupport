# Check PowerShell if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    # Relaunch Powershell with run admin
    Start-Process PowerShell -ArgumentList "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Uninstall YourPhone App for All Users
Get-AppxPackage -AllUsers Microsoft.YourPhone | Remove-AppxPackage

# Optional: Remove the provisioning package to prevent the app from being installed on new user profiles
Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -like "*YourPhone*"} | Remove-AppxProvisionedPackage -Online
Write-Host "======================== Uninstall YourPhone Complete ================================="
Start-Sleep -Seconds 3
