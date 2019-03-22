if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
#
# Setup script to run to do some initial setup of a Windows desktop
#
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Disable Sleep on AC Power..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Powercfg /Change monitor-timeout-ac 20
Powercfg /Change standby-timeout-ac 0
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Add 'This PC' Desktop Icon..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
$thisPCIconRegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
$thisPCRegValname = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
$item = Get-ItemProperty -Path $thisPCIconRegPath -Name $thisPCRegValname -ErrorAction SilentlyContinue
if ($item) {
    Set-ItemProperty  -Path $thisPCIconRegPath -name $thisPCRegValname -Value 0
}
else {
    New-ItemProperty -Path $thisPCIconRegPath -Name $thisPCRegValname -Value 0 -PropertyType DWORD  | Out-Null
}
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Removing Edge Desktop Icon..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
$edgeLink = $env:USERPROFILE + "\Desktop\Microsoft Edge.lnk"
Remove-Item $edgeLink
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Enable Windows 10 Developer Mode..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Enable Remote Desktop..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\" -Name "fDenyTSConnections" -Value 0
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\" -Name "UserAuthentication" -Value 1
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Setting up emacs..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
New-Item -ItemType Directory -Force -Path ~\code\personal
git clone https://github.com/syl20bnr/spacemacs.git ~\code\personal\spacemacs
git clone https://github.com/justinmills/emacs-spacemacs.git ~\code\personal\emacs-spacemacs
New-Item -Path ~/.emacs.d -ItemType SymbolicLink -Value ~\code\personal\spacemacs
New-Item -Path ~/.spacemacs.d -ItemType SymbolicLink -Value ~\code\personal\emacs-spacemacs\dot.spacemacs.d

Set-PSReadLineOption -EditMode Emacs
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Setting up PowerShell Profile..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
git clone https://github.com/justinmills/machine-setup.git ~\code\personal\machine-setup
New-Item -Path $PROFILE -ItemType SymbolicLink -Value ~\code\personal\machine-setup\windows\PowerShell-profile.ps1

# Write-Host "------------------------------------" -ForegroundColor Green
# Read-Host -Prompt "Setup is done, restart is needed, press [ENTER] to restart computer."
# Restart-Computer
