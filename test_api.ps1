# Quick API Test Script
Write-Host "=== Wallet Service API Test ===" -ForegroundColor Cyan
Write-Host ""

$baseUrl = "http://localhost:5000/api/v1"

# Test 1: Register a new user
Write-Host "1. Registering new user..." -ForegroundColor Yellow
$registerBody = @{
    email = "demo@example.com"
    password = "demo123"
} | ConvertTo-Json

try {
    $registerResponse = Invoke-RestMethod -Uri "$baseUrl/auth/register" -Method POST -Body $registerBody -ContentType "application/json"
    Write-Host "   [OK] User registered: $($registerResponse.message)" -ForegroundColor Green
} catch {
    Write-Host "   [INFO] User may already exist (this is OK)" -ForegroundColor Yellow
}

Write-Host ""

# Test 2: Login
Write-Host "2. Logging in..." -ForegroundColor Yellow
$loginBody = @{
    email = "demo@example.com"
    password = "demo123"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "$baseUrl/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
    $token = $loginResponse.access_token
    Write-Host "   [OK] Login successful!" -ForegroundColor Green
    Write-Host "   Token: $($token.Substring(0, 30))..." -ForegroundColor Gray
} catch {
    Write-Host "   [ERROR] Login failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Test 3: Get Wallet Balance
Write-Host "3. Getting wallet balance..." -ForegroundColor Yellow
$headers = @{
    Authorization = "Bearer $token"
}

try {
    $walletResponse = Invoke-RestMethod -Uri "$baseUrl/wallet" -Method GET -Headers $headers
    Write-Host "   [OK] Current balance: $($walletResponse.balance)" -ForegroundColor Green
} catch {
    Write-Host "   [ERROR] Failed to get balance: $_" -ForegroundColor Red
}

Write-Host ""

# Test 4: Credit Money
Write-Host "4. Crediting 1000 to wallet..." -ForegroundColor Yellow
$creditBody = @{
    amount = 1000
} | ConvertTo-Json

try {
    $creditResponse = Invoke-RestMethod -Uri "$baseUrl/transactions/credit" -Method POST -Body $creditBody -ContentType "application/json" -Headers $headers
    Write-Host "   [OK] $($creditResponse.message)" -ForegroundColor Green
    Write-Host "   New balance: $($creditResponse.new_balance)" -ForegroundColor Green
} catch {
    Write-Host "   [ERROR] Credit failed: $_" -ForegroundColor Red
}

Write-Host ""

# Test 5: Debit Money
Write-Host "5. Debiting 250 from wallet..." -ForegroundColor Yellow
$debitBody = @{
    amount = 250
} | ConvertTo-Json

try {
    $debitResponse = Invoke-RestMethod -Uri "$baseUrl/transactions/debit" -Method POST -Body $debitBody -ContentType "application/json" -Headers $headers
    Write-Host "   [OK] $($debitResponse.message)" -ForegroundColor Green
    Write-Host "   New balance: $($debitResponse.new_balance)" -ForegroundColor Green
} catch {
    Write-Host "   [ERROR] Debit failed: $_" -ForegroundColor Red
}

Write-Host ""

# Test 6: Get Transaction History
Write-Host "6. Getting transaction history..." -ForegroundColor Yellow
try {
    $transactions = Invoke-RestMethod -Uri "$baseUrl/transactions" -Method GET -Headers $headers
    Write-Host "   [OK] Found $($transactions.Count) transactions" -ForegroundColor Green
    foreach ($tx in $transactions) {
        Write-Host "   - $($tx.type): $($tx.amount) at $($tx.created_at)" -ForegroundColor Gray
    }
} catch {
    Write-Host "   [ERROR] Failed to get transactions: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== All Tests Complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "API is running at: $baseUrl" -ForegroundColor Green
