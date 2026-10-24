# Unregister all WSL distributions
# WARNING: This will permanently delete all WSL distributions and their data

Write-Host "Checking for WSL distributions..." -ForegroundColor Cyan

# Get list of all WSL distributions
$distros = wsl --list --quiet | Where-Object { $_.Trim() -ne "" }

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
        Write-Host "  ✓ Successfully unregistered $distro" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Failed to unregister $distro" -ForegroundColor Red
    }
}

Write-Host "`nVerifying cleanup..." -ForegroundColor Cyan
$remaining = wsl --list --quiet | Where-Object { $_.Trim() -ne "" }

if ($remaining.Count -eq 0) {
    Write-Host "All WSL distributions have been removed." -ForegroundColor Green
} else {
    Write-Host "Warning: Some distributions remain:" -ForegroundColor Yellow
    foreach ($distro in $remaining) {
        Write-Host "  - $distro" -ForegroundColor Yellow
    }
}
