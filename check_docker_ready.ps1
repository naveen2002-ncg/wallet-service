# Check if Docker Desktop is ready
Write-Host "Checking Docker Desktop status..." -ForegroundColor Cyan
Write-Host ""

$maxAttempts = 30
$attempt = 0

while ($attempt -lt $maxAttempts) {
    try {
        $result = docker ps 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[OK] Docker Desktop is running and ready!" -ForegroundColor Green
            Write-Host ""
            docker info | Select-String -Pattern "Server Version|Operating System" | Select-Object -First 2
            exit 0
        } else {
            Write-Host "Waiting for Docker Desktop... ($attempt/$maxAttempts)" -ForegroundColor Yellow
            Start-Sleep -Seconds 2
            $attempt++
        }
    } catch {
        Write-Host "Waiting for Docker Desktop... ($attempt/$maxAttempts)" -ForegroundColor Yellow
        Start-Sleep -Seconds 2
        $attempt++
    }
}

Write-Host ""
Write-Host "[WARNING] Docker Desktop is still starting..." -ForegroundColor Yellow
Write-Host "Please ensure Docker Desktop is fully started (check system tray for whale icon)" -ForegroundColor Yellow
Write-Host ""
Write-Host "You can:" -ForegroundColor Cyan
Write-Host "1. Wait a bit longer and run this script again" -ForegroundColor White
Write-Host "2. Manually start Docker Desktop from Start Menu" -ForegroundColor White
Write-Host "3. Check Docker Desktop status in the application window" -ForegroundColor White
