# Dropshipping Empire - Automated Railway Deployment Script
# This script deploys all services to Railway.app

param(
    [switch]$SkipInstall,
    [string]$ProjectName = "dropship-empire"
)

Write-Host "╔════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     Dropshipping Empire - Railway Deployment Script 🚂           ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Check if Railway CLI is installed
if (-not $SkipInstall) {
    Write-Host "[1/8] Checking Railway CLI..." -ForegroundColor Yellow
    
    $railwayInstalled = Get-Command railway -ErrorAction SilentlyContinue
    
    if (-not $railwayInstalled) {
        Write-Host "   Railway CLI not found. Installing..." -ForegroundColor Yellow
        Write-Host "   Run: npm install -g @railway/cli" -ForegroundColor Cyan
        Write-Host "   Or visit: https://docs.railway.app/develop/cli" -ForegroundColor Cyan
        exit 1
    }
    
    Write-Host "   ✓ Railway CLI installed" -ForegroundColor Green
}

# Check if logged in
Write-Host "`n[2/8] Checking Railway authentication..." -ForegroundColor Yellow
try {
    railway whoami 2>&1 | Out-Null
    Write-Host "   ✓ Logged in to Railway" -ForegroundColor Green
} catch {
    Write-Host "   ✗ Not logged in. Running 'railway login'..." -ForegroundColor Red
    railway login
}

# Create new Railway project
Write-Host "`n[3/8] Creating Railway project..." -ForegroundColor Yellow
Write-Host "   Project name: $ProjectName" -ForegroundColor Cyan

$projectCreated = $false
try {
    railway init --name $ProjectName 2>&1 | Out-Null
    $projectCreated = $true
    Write-Host "   ✓ Project created" -ForegroundColor Green
} catch {
    Write-Host "   ! Project may already exist, continuing..." -ForegroundColor Yellow
}

# Store service URLs
$serviceUrls = @{}

# Deploy PostgreSQL
Write-Host "`n[4/8] Deploying PostgreSQL database..." -ForegroundColor Yellow
Write-Host "   This will be shared across services" -ForegroundColor Cyan
Write-Host "   Run manually: railway add" -ForegroundColor Yellow
Write-Host "   Select: PostgreSQL" -ForegroundColor Yellow
Write-Host "   Press Enter when done..." -ForegroundColor Cyan
Read-Host

# Deploy Redis
Write-Host "`n[5/8] Deploying Redis cache..." -ForegroundColor Yellow
Write-Host "   Run manually: railway add" -ForegroundColor Yellow
Write-Host "   Select: Redis" -ForegroundColor Yellow
Write-Host "   Press Enter when done..." -ForegroundColor Cyan
Read-Host

# Deploy Video Factory
Write-Host "`n[6/8] Deploying Video Factory (MoneyPrinterTurbo)..." -ForegroundColor Yellow
cd "$HOME\dropship-empire\video-factory"

if (Test-Path "railway.json") {
    Write-Host "   ✓ railway.json exists" -ForegroundColor Green
} else {
    Write-Host "   Creating railway.json..." -ForegroundColor Cyan
    @"
{
  "`$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "DOCKERFILE"
  },
  "deploy": {
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
"@ | Out-File -FilePath "railway.json" -Encoding UTF8
}

Write-Host "   Deploying..." -ForegroundColor Cyan
railway up --service video-factory

Write-Host "   Setting environment variables..." -ForegroundColor Cyan
railway variables set LLM_PROVIDER=gemini --service video-factory
railway variables set GEMINI_API_KEY=AIzaSyBy7kLZ-2ZaIRQ6cHgPnCa7frNiksdGXfk --service video-factory
railway variables set PEXELS_API_KEY=TMh4U0MrkQeVOnolFyh4993AgT9kPCQrnx2Jlo1JlCgasDUmZMaMzKxe --service video-factory
railway variables set PORT=8501 --service video-factory

$videoUrl = railway domain --service video-factory
$serviceUrls['video-factory'] = $videoUrl
Write-Host "   ✓ Video Factory deployed: $videoUrl" -ForegroundColor Green

# Deploy n8n
Write-Host "`n[7/8] Deploying n8n Workflow Engine..." -ForegroundColor Yellow
Write-Host "   Using Railway template..." -ForegroundColor Cyan
Write-Host "   Run manually: railway add" -ForegroundColor Yellow
Write-Host "   Search: n8n" -ForegroundColor Yellow
Write-Host "   Or deploy from Docker Hub: n8nio/n8n:latest" -ForegroundColor Yellow
Write-Host "   Press Enter when done..." -ForegroundColor Cyan
Read-Host

# Deploy Store Platform
Write-Host "`n[8/8] Deploying Store Platform (Bagisto)..." -ForegroundColor Yellow
cd "$HOME\dropship-empire\store-platform"

# Create Procfile if doesn't exist
if (-not (Test-Path "Procfile")) {
    Write-Host "   Creating Procfile..." -ForegroundColor Cyan
    "web: php artisan serve --host=0.0.0.0 --port=`$PORT" | Out-File -FilePath "Procfile" -Encoding ASCII
}

# Create nixpacks.toml if doesn't exist
if (-not (Test-Path "nixpacks.toml")) {
    Write-Host "   Creating nixpacks.toml..." -ForegroundColor Cyan
    @"
[phases.setup]
nixPkgs = ["php82", "php82Packages.composer"]

[phases.install]
cmds = ["composer install --no-dev --optimize-autoloader"]

[phases.build]
cmds = [
  "php artisan config:cache",
  "php artisan route:cache",
  "php artisan view:cache"
]

[start]
cmd = "php artisan serve --host=0.0.0.0 --port=`$PORT"
"@ | Out-File -FilePath "nixpacks.toml" -Encoding UTF8
}

Write-Host "   Deploying..." -ForegroundColor Cyan
railway up --service store-platform

Write-Host "   Setting environment variables..." -ForegroundColor Cyan
railway variables set APP_ENV=production --service store-platform
railway variables set APP_DEBUG=false --service store-platform

$storeUrl = railway domain --service store-platform
$serviceUrls['store-platform'] = $storeUrl
Write-Host "   ✓ Store Platform deployed: $storeUrl" -ForegroundColor Green

Write-Host "   Running migrations..." -ForegroundColor Cyan
railway run php artisan migrate --force --service store-platform
railway run php artisan db:seed --force --service store-platform
Write-Host "   ✓ Database initialized" -ForegroundColor Green

# Summary
Write-Host "`n╔════════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║              DEPLOYMENT COMPLETE! ✅                               ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Green

Write-Host "🎉 Your Dropshipping Empire is now live on Railway!`n" -ForegroundColor Cyan

Write-Host "📊 Deployed Services:" -ForegroundColor Yellow
foreach ($service in $serviceUrls.Keys) {
    Write-Host "   • $service : $($serviceUrls[$service])" -ForegroundColor White
}

Write-Host "`n🔗 Next Steps:" -ForegroundColor Magenta
Write-Host "   1. Visit Railway Dashboard: https://railway.app/dashboard" -ForegroundColor White
Write-Host "   2. Configure custom domains (optional)" -ForegroundColor White
Write-Host "   3. Update n8n workflow with new URLs" -ForegroundColor White
Write-Host "   4. Test all services" -ForegroundColor White
Write-Host "   5. Monitor logs and metrics" -ForegroundColor White

Write-Host "`n💰 Estimated Monthly Cost: ~$39" -ForegroundColor Cyan
Write-Host "   (Includes $5 Hobby plan credit)`n" -ForegroundColor White

Write-Host "📝 Save these URLs for your records!" -ForegroundColor Yellow
Write-Host "   You can also find them in Railway Dashboard`n" -ForegroundColor White
