# Script to help push to GitHub
# Run this script after configuring Git user

Write-Host "=== Wallet Service - Push to GitHub ===" -ForegroundColor Cyan
Write-Host ""

# Check Git user config
$userName = git config user.name
$userEmail = git config user.email

if (-not $userName -or $userName -eq "Your Name") {
    Write-Host "[WARNING] Git user.name not configured" -ForegroundColor Yellow
    Write-Host "  Run: git config user.name 'Your Name'" -ForegroundColor White
}
if (-not $userEmail -or $userEmail -eq "your.email@example.com") {
    Write-Host "[WARNING] Git user.email not configured" -ForegroundColor Yellow
    Write-Host "  Run: git config user.email 'your.email@example.com'" -ForegroundColor White
}

Write-Host ""
Write-Host "Step 1: Add all files" -ForegroundColor Yellow
Write-Host "  git add ." -ForegroundColor White

Write-Host ""
Write-Host "Step 2: Create commit" -ForegroundColor Yellow
Write-Host "  git commit -m 'Initial commit: Wallet Service API'" -ForegroundColor White

Write-Host ""
Write-Host "Step 3: Create GitHub repository at https://github.com" -ForegroundColor Yellow
Write-Host "  - Click '+' -> 'New repository'" -ForegroundColor White
Write-Host "  - Name: wallet-service" -ForegroundColor White
Write-Host "  - DO NOT initialize with README" -ForegroundColor White

Write-Host ""
Write-Host "Step 4: Add remote and push" -ForegroundColor Yellow
Write-Host "  git remote add origin https://github.com/YOUR_USERNAME/wallet-service.git" -ForegroundColor White
Write-Host "  git branch -M main" -ForegroundColor White
Write-Host "  git push -u origin main" -ForegroundColor White

Write-Host ""
Write-Host "See GITHUB_DEPLOYMENT.md for detailed instructions!" -ForegroundColor Cyan
