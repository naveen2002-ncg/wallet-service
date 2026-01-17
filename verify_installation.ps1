# Verification Script - Check if Docker and PostgreSQL are installed

Write-Host "=== Installation Verification ===" -ForegroundColor Cyan
Write-Host ""

$allGood = $true

# Check Docker
Write-Host "Checking Docker Desktop..." -ForegroundColor Yellow
$docker = Get-Command docker -ErrorAction SilentlyContinue
if ($docker) {
    Write-Host "[OK] Docker is installed" -ForegroundColor Green
    docker --version
} else {
    Write-Host "[MISSING] Docker is not installed" -ForegroundColor Red
    Write-Host "  Install with: winget install Docker.DockerDesktop" -ForegroundColor Yellow
    $allGood = $false
}

Write-Host ""

# Check Docker Compose
Write-Host "Checking Docker Compose..." -ForegroundColor Yellow
$dockerCompose = Get-Command docker-compose -ErrorAction SilentlyContinue
if ($dockerCompose) {
    Write-Host "[OK] Docker Compose is installed" -ForegroundColor Green
    docker-compose --version
} else {
    # Try 'docker compose' (newer syntax)
    $dockerComposeV2 = Get-Command docker -ErrorAction SilentlyContinue
    if ($dockerComposeV2) {
        try {
            docker compose version 2>$null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[OK] Docker Compose V2 is available" -ForegroundColor Green
            } else {
                Write-Host "[WARNING] Docker Compose not available (but Docker is installed)" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "[WARNING] Could not verify Docker Compose" -ForegroundColor Yellow
        }
    } else {
        Write-Host "[MISSING] Docker Compose is not installed" -ForegroundColor Red
        $allGood = $false
    }
}

Write-Host ""

# Check PostgreSQL (optional - not needed if using Docker)
Write-Host "Checking PostgreSQL (optional - Docker provides this)..." -ForegroundColor Yellow
$psql = Get-Command psql -ErrorAction SilentlyContinue
if ($psql) {
    Write-Host "[OK] PostgreSQL is installed locally" -ForegroundColor Green
    psql --version
} else {
    Write-Host "[INFO] PostgreSQL not installed locally (OK if using Docker)" -ForegroundColor Cyan
}

Write-Host ""

# Check Docker service
Write-Host "Checking Docker service..." -ForegroundColor Yellow
$dockerService = Get-Service -Name "*docker*" -ErrorAction SilentlyContinue
if ($dockerService) {
    $running = $dockerService | Where-Object { $_.Status -eq 'Running' }
    if ($running) {
        Write-Host "[OK] Docker service is running" -ForegroundColor Green
    } else {
        Write-Host "[WARNING] Docker service is not running" -ForegroundColor Yellow
        Write-Host "  Start Docker Desktop from Start Menu" -ForegroundColor Yellow
    }
} else {
    Write-Host "[INFO] Docker service not found (Docker may not be installed)" -ForegroundColor Cyan
}

Write-Host ""

# Check .env file
Write-Host "Checking .env file..." -ForegroundColor Yellow
if (Test-Path .env) {
    Write-Host "[OK] .env file exists" -ForegroundColor Green
} else {
    Write-Host "[WARNING] .env file not found" -ForegroundColor Yellow
    Write-Host "  Create from .env.example" -ForegroundColor Yellow
    $allGood = $false
}

Write-Host ""

# Summary
if ($allGood -and $docker) {
    Write-Host "=== Verification Complete ===" -ForegroundColor Green
    Write-Host ""
    Write-Host "You're ready to start the application!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Ensure Docker Desktop is running" -ForegroundColor White
    Write-Host "2. Run: docker-compose up --build" -ForegroundColor White
} else {
    Write-Host "=== Installation Needed ===" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please install Docker Desktop:" -ForegroundColor Yellow
    Write-Host "  winget install Docker.DockerDesktop" -ForegroundColor White
    Write-Host ""
    Write-Host "See INSTALLATION.md or QUICK_INSTALL.md for details" -ForegroundColor Cyan
}
