Write-Host "=== Wallet Service Auto Runner ===" -ForegroundColor Cyan
Write-Host ""

# Ensure we are in the script directory (project root)
Set-Location -Path (Split-Path -Parent $MyInvocation.MyCommand.Path)

# 1. Ensure .env exists
if (-not (Test-Path ".env")) {
    if (Test-Path ".env.example") {
        Write-Host "[INFO] .env not found, creating from .env.example" -ForegroundColor Yellow
        Copy-Item ".env.example" ".env"
        Write-Host "[OK] Created .env. Please edit it later to set strong SECRET_KEY values." -ForegroundColor Green
    } else {
        Write-Host "[ERROR] .env and .env.example not found. Cannot continue." -ForegroundColor Red
        exit 1
    }
}

Write-Host ""

# 2. Verify Docker & basic setup
if (Test-Path ".\verify_installation.ps1") {
    Write-Host "Running verification script..." -ForegroundColor Cyan
    & powershell -ExecutionPolicy Bypass -File ".\verify_installation.ps1"
} else {
    Write-Host "[WARN] verify_installation.ps1 not found, skipping verification." -ForegroundColor Yellow
}

Write-Host ""

# 3. Make sure Docker Desktop is ready
if (Test-Path ".\check_docker_ready.ps1") {
    Write-Host "Checking Docker Desktop readiness..." -ForegroundColor Cyan
    & powershell -ExecutionPolicy Bypass -File ".\check_docker_ready.ps1"
} else {
    Write-Host "[WARN] check_docker_ready.ps1 not found, assuming Docker is ready." -ForegroundColor Yellow
}

Write-Host ""

# 4. Start the application with Docker Compose
Write-Host "Starting Wallet Service with docker-compose..." -ForegroundColor Cyan
Write-Host "This may take a few minutes on first run." -ForegroundColor Yellow
Write-Host ""

docker-compose up --build

