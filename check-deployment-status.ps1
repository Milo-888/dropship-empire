# Check Deployment Status Script

Write-Host "`n🔍 Dropshipping Platform - Deployment Status Check" -ForegroundColor Cyan
Write-Host "==================================================`n" -ForegroundColor Cyan

# Check running containers
Write-Host "📦 Running Containers:" -ForegroundColor Yellow
docker ps --filter "name=dropship-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

Write-Host "`n📊 Service Health:" -ForegroundColor Yellow
docker ps --filter "name=dropship-" --format "{{.Names}}" | ForEach-Object {
    $status = docker inspect $_ --format='{{.State.Status}}'
    $health = docker inspect $_ --format='{{.State.Health.Status}}' 2>$null
    
    if ($status -eq "running") {
        if ($health -eq "healthy") {
            Write-Host "✅ $_ : Running (Healthy)" -ForegroundColor Green
        } elseif ($health -eq "unhealthy") {
            Write-Host "⚠️  $_ : Running (Unhealthy)" -ForegroundColor Yellow
        } else {
            Write-Host "🟢 $_ : Running" -ForegroundColor Green
        }
    } else {
        Write-Host "❌ $_ : $status" -ForegroundColor Red
    }
}

Write-Host "`n🌐 Available Services:" -ForegroundColor Yellow
Write-Host "==================" -ForegroundColor Yellow

$services = @{
    "dropship-postgres" = "Database (PostgreSQL):  localhost:5432"
    "dropship-mysql" = "Database (MySQL):       localhost:3307"
    "dropship-redis" = "Cache (Redis):          localhost:6380"
    "dropship-n8n" = "n8n Workflow:           http://localhost:5679"
    "dropship-marketing-api" = "Marketing API:          http://localhost:3030"
    "dropship-marketing-ui" = "Marketing UI:           http://localhost:3031"
    "dropship-video-api" = "Video Factory API:      http://localhost:8082"
    "dropship-video-webui" = "Video Factory WebUI:    http://localhost:8502"
    "dropship-store" = "Store Platform:         http://localhost:8083"
}

docker ps --filter "name=dropship-" --format "{{.Names}}" | ForEach-Object {
    if ($services.ContainsKey($_)) {
        $svcInfo = $services[$_]
        Write-Host "  $svcInfo" -ForegroundColor White
    }
}

Write-Host ""
