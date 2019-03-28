if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
#
# Setup script to run to do some initial setup of a Windows desktop
#
# -----------------------------------------------------------------------------
# Some supporting functions/constants for testing this out
Write-Host ""
Write-Host "Preparing to setup..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
function not-exist { -not (Test-Path $args) }
Set-Alias !exist not-exist -Option "Constant, AllScope" -Force
Set-Alias exist Test-Path -Option "Constant, AllScope" -Force

$myCode = "$HOME\code\personal"
$realHome = [Environment]::GetEnvironmentVariable("HOME")
if (!$realHome -Or (!exist $HOME)) {
    Write-Host ""
    Write-Host 'Unable to determine if $HOME is set!' -ForegroundColor Red
    Write-Host ""
    Write-Host 'Try running the following first, assuming $HOME resolves for you in this shell:'
    Write-Host ""
    Write-Host '[Environment]::SetEnvironmentVariable("HOME", "$HOME", "User")'
    Write-Host ""
    Exit
}
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Disable Sleep on AC Power..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Powercfg /Change monitor-timeout-ac 20
Powercfg /Change standby-timeout-ac 0
# -----------------------------------------------------------------------------
# Write-Host ""
# Write-Host "Add 'This PC' Desktop Icon..." -ForegroundColor Green
# Write-Host "------------------------------------" -ForegroundColor Green
# $thisPCIconRegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
# $thisPCRegValname = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
# $item = Get-ItemProperty -Path $thisPCIconRegPath -Name $thisPCRegValname -ErrorAction SilentlyContinue
# if ($item) {
#     Set-ItemProperty  -Path $thisPCIconRegPath -name $thisPCRegValname -Value 0
# }
# else {
#     New-ItemProperty -Path $thisPCIconRegPath -Name $thisPCRegValname -Value 0 -PropertyType DWORD  | Out-Null
# }
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Removing Edge Desktop Icon..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
$edgeLink = $env:USERPROFILE + "\Desktop\Microsoft Edge.lnk"
if (exist $edgeLink) {
    Remove-Item $edgeLink
}
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Enable Windows 10 Developer Mode..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" /t REG_DWORD /f /v "AllowDevelopmentWithoutDevLicense" /d "1"
# -----------------------------------------------------------------------------
# Write-Host ""
# Write-Host "Enable Remote Desktop..." -ForegroundColor Green
# Write-Host "------------------------------------" -ForegroundColor Green
# Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\" -Name "fDenyTSConnections" -Value 0
# Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp\" -Name "UserAuthentication" -Value 1
# Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Setting up emacs..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
if (-not (Test-Path "$myCode")) {
    New-Item -ItemType Directory -Path "$myCode"
} else {
    Write-Host "  Skipping personal code dir creation, exists!" -ForegroundColor Yellow
}
if (-not (Test-Path "$myCode\spacemacs")) {
    git clone https://github.com/syl20bnr/spacemacs.git "$myCode\spacemacs"
} else {
    Write-Host "  Skipping spacemacs clone, it exists!" -ForegroundColor Yellow
}
if (-not (Test-Path "$myCode\emacs-spacemacs")) {
    git clone https://github.com/justinmills/emacs-spacemacs.git "$myCode\emacs-spacemacs"
} else {
    Write-Host "  Skipping my emacs config clone, it exists!" -ForegroundColor Yellow
}
if (-not (Test-Path "$HOME\.emacs.d")) {
    New-Item -Path $HOME/.emacs.d -ItemType SymbolicLink -Value "$myCode\spacemacs"
} else {
    Write-Host "  Skipping symlink ~/.emacs.d, it exists!" -ForegroundColor Yellow
}
if (-not (Test-Path "$HOME\.spacemacs.d")) {
    New-Item -Path $HOME/.spacemacs.d -ItemType SymbolicLink -Value "$myCode\emacs-spacemacs\dot.spacemacs.d"
} else {
    Write-Host "  Skipping symlink ~/.spacemacs.d, it exists!" -ForegroundColor Yellow
}
Set-PSReadLineOption -EditMode Emacs
# -----------------------------------------------------------------------------
Write-Host ""
Write-Host "Setting up PowerShell Profile..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
if (-not (Test-Path "$myCode\machine-setup")) {
    git clone https://github.com/justinmills/machine-setup.git "$myCode\machine-setup"
} else {
    Write-Host "  Skipping machine-setup clone, it exists!" -ForegroundColor Yellow
}
if (-not (Test-Path "$PROFILE")) {
    New-Item -Path $PROFILE -ItemType SymbolicLink -Value "$myCode\machine-setup\windows\PowerShell-profile.ps1"
} else {
    Write-Host "  Skipping symlink $PROFILE, it exists!" -ForegroundColor Yellow
}
# Write-Host "------------------------------------" -ForegroundColor Green
# Read-Host -Prompt "Setup is done, restart is needed, press [ENTER] to restart computer."
# Restart-Computer
