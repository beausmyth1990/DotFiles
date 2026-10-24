# Unregister all WSL distributions
# WARNING: This will permanently delete all WSL distributions and their data

Write-Host "Checking for WSL distributions..." -ForegroundColor Cyan

# Get list of all WSL distributions with proper UTF-16 encoding handling
$wslOutput = wsl --list --quiet
$distros = @()

if ($wslOutput) {
    # Convert from UTF-16 and split into lines
    $lines = $wslOutput -split "`r?`n" | ForEach-Object { 
        # Remove null characters and trim whitespace
        ($_ -replace "`0", "").Trim() 
    } | Where-Object { $_ -ne "" }
    
    $distros = $lines
}

if ($distros.Count -eq 0) {
    Write-Host "No WSL distributions found." -ForegroundColor Green
    exit 0
}

Write-Host "`nFound $($distros.Count) WSL distribution(s):" -ForegroundColor Yellow
foreach ($distro in $distros) {
    Write-Host "  - $distro" -ForegroundColor Yellow
}

Write-Host "`nWARNING: This will permanently delete all data in these distributions!" -ForegroundColor Red
$confirmation = Read-Host "Type 'yes' to proceed"

if ($confirmation -ne "yes") {
    Write-Host "Operation cancelled." -ForegroundColor Green
    exit 0
}

Write-Host "`nUnregistering distributions..." -ForegroundColor Cyan

foreach ($distro in $distros) {
    Write-Host "Unregistering $distro..." -ForegroundColor Yellow
    wsl --unregister $distro
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  Successfully unregistered $distro" -ForegroundColor Green
    } else {
        Write-Host "  Failed to unregister $distro" -ForegroundColor Red
    }
}

Write-Host "`nVerifying cleanup..." -ForegroundColor Cyan
$wslOutput = wsl --list --quiet
$remaining = @()

if ($wslOutput) {
    $lines = $wslOutput -split "`r?`n" | ForEach-Object { 
        ($_ -replace "`0", "").Trim() 
    } | Where-Object { $_ -ne "" }
    
    $remaining = $lines
}

if ($remaining.Count -eq 0) {
    Write-Host "All WSL distributions have been removed." -ForegroundColor Green
} else {
    Write-Host "Warning: Some distributions remain:" -ForegroundColor Yellow
    foreach ($distro in $remaining) {
        Write-Host "  - $distro" -ForegroundColor Yellow
    }
}
