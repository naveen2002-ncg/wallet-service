# Installation Script for Docker Desktop and PostgreSQL
# Run this script as Administrator

Write-Host "=== Docker & PostgreSQL Installation Script ===" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "WARNING: Not running as Administrator" -ForegroundColor Yellow
    Write-Host "Some installations may require administrator privileges." -ForegroundColor Yellow
    Write-Host ""
}

# Check if Docker is already installed
Write-Host "Checking for Docker Desktop..." -ForegroundColor Cyan
$dockerInstalled = Get-Command docker -ErrorAction SilentlyContinue

if ($dockerInstalled) {
    Write-Host "✓ Docker Desktop is already installed" -ForegroundColor Green
    docker --version
} else {
    Write-Host "Docker Desktop not found. Installing..." -ForegroundColor Yellow
    try {
        winget install Docker.DockerDesktop --accept-source-agreements --accept-package-agreements
        Write-Host "✓ Docker Desktop installation initiated" -ForegroundColor Green
        Write-Host "  Please complete the installation wizard and restart your computer." -ForegroundColor Yellow
    } catch {
        Write-Host "✗ Failed to install Docker Desktop: $_" -ForegroundColor Red
        Write-Host "  You may need to install manually from: https://www.docker.com/products/docker-desktop/" -ForegroundColor Yellow
    }
}

Write-Host ""

# Check if PostgreSQL is already installed
Write-Host "Checking for PostgreSQL..." -ForegroundColor Cyan
$pgInstalled = Get-Command psql -ErrorAction SilentlyContinue

if ($pgInstalled) {
    Write-Host "✓ PostgreSQL is already installed" -ForegroundColor Green
    psql --version
} else {
    Write-Host "PostgreSQL not found." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Note: If you install Docker Desktop, you don't need to install PostgreSQL separately!" -ForegroundColor Cyan
    Write-Host "The docker-compose.yml will handle PostgreSQL automatically." -ForegroundColor Cyan
    Write-Host ""
    
    $installPg = Read-Host "Do you want to install PostgreSQL locally? (y/n)"
    if ($installPg -eq 'y' -or $installPg -eq 'Y') {
        try {
            winget install PostgreSQL.PostgreSQL --accept-source-agreements --accept-package-agreements
            Write-Host "✓ PostgreSQL installation initiated" -ForegroundColor Green
            Write-Host "  During installation, set password to 'postgres' for this project." -ForegroundColor Yellow
        } catch {
            Write-Host "✗ Failed to install PostgreSQL: $_" -ForegroundColor Red
            Write-Host "  You may need to install manually from: https://www.postgresql.org/download/windows/" -ForegroundColor Yellow
        }
    } else {
        Write-Host "Skipping PostgreSQL installation. Using Docker for PostgreSQL is recommended." -ForegroundColor Cyan
    }
}

Write-Host ""
Write-Host "=== Installation Summary ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. If Docker Desktop was installed, RESTART your computer" -ForegroundColor White
Write-Host "2. Start Docker Desktop from Start Menu" -ForegroundColor White
Write-Host "3. Navigate to project directory: cd d:\wallet-service" -ForegroundColor White
Write-Host "4. Run: docker-compose up --build" -ForegroundColor White
Write-Host ""
Write-Host "For detailed instructions, see INSTALLATION.md" -ForegroundColor Cyan
