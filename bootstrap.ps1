# bootstrap.ps1
# Sets up a fresh Ubuntu WSL instance (latest LTS) with DotFiles

$dotfilesRepo = "https://github.com/beausmyth1990/DotFiles.git"
$dotfilesPath = "~/repos/DotFiles"

# Find the latest Ubuntu LTS from available distros
$available = wsl --list --online | ForEach-Object { ($_ -replace "`0", "").Trim() -split "\s+" | Select-Object -First 1 }
$distro = $available |
  Where-Object { $_ -match "^Ubuntu-\d+\.04$" } |
  Sort-Object -Descending |
  Select-Object -First 1

if (-not $distro) {
  Write-Host "Could not find a Ubuntu LTS distro. Run 'wsl --list --online' to check availability."
  exit 1
}

Write-Host "Latest Ubuntu LTS found: $distro"

# Install distro
Write-Host "Installing $distro..."
wsl --install -d $distro

# Wait for distro to be registered and ready
Write-Host ""
Write-Host "Waiting for $distro to be set up (complete username + password in the new window)..."
do {
  Start-Sleep -Seconds 3
  $ready = wsl --list --quiet | ForEach-Object { ($_ -replace "`0", "").Trim() } | Where-Object { $_ -eq $distro }
} until ($ready)

Write-Host "$distro is ready."

# Install git and clone DotFiles
Write-Host "Installing git..."
wsl bash -c "sudo apt update -y && sudo apt install -y git"

Write-Host "Cloning DotFiles..."
wsl bash -c "mkdir -p ~/repos && git clone $dotfilesRepo $dotfilesPath"

# Copy bootstrap.ps1 and setup.sh into the repo on WSL
$scriptPath = $MyInvocation.MyCommand.Path
$setupPath = Join-Path (Split-Path $scriptPath) "setup.sh"
$wslScriptPath = $scriptPath -replace "\\", "/" -replace "^C:", "/mnt/c"
$wslSetupPath = $setupPath -replace "\\", "/" -replace "^C:", "/mnt/c"
wsl bash -c "cp '$wslScriptPath' $dotfilesPath/bootstrap.ps1 && cp '$wslSetupPath' $dotfilesPath/setup.sh"
Write-Host "Scripts copied into repo."

# Run setup script
Write-Host "Running setup.sh..."
wsl bash -c "cd $dotfilesPath && bash setup.sh"

# Deploy WezTerm config to the Windows home dir.
# WezTerm runs on Windows and reads %USERPROFILE%\.wezterm.lua, so the repo
# template must be rendered here with the real distro name and WSL username.
Write-Host "Deploying WezTerm config..."
$wslUser = (wsl bash -c "whoami").Trim()
$weztermTemplate = (wsl bash -c "cat $dotfilesPath/.wezterm.lua")
$weztermConfig = $weztermTemplate `
  -replace "__WSL_DISTRO__", $distro `
  -replace "__WSL_USER__", $wslUser
$weztermDest = Join-Path $env:USERPROFILE ".wezterm.lua"
Set-Content -Path $weztermDest -Value $weztermConfig -Encoding UTF8
Write-Host "WezTerm config written to $weztermDest (distro=$distro, user=$wslUser)."

Write-Host ""
Write-Host "All done! Open a new WSL terminal to get started."
