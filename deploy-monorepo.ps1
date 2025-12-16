# Dropshipping Platform - Monorepo Deployment Script
# This script builds and deploys all services using Docker Compose

Write-Host "🚀 Dropshipping Platform - Monorepo Deployment" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is running
Write-Host "🔍 Checking Docker status..." -ForegroundColor Yellow
try {
    docker info | Out-Null
    Write-Host "✅ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not running. Please start Docker Desktop first." -ForegroundColor Red
    exit 1
}

# Check for existing containers on required ports
Write-Host ""
Write-Host "🔍 Checking for port conflicts..." -ForegroundColor Yellow
$portsToCheck = @(3030, 3031, 5679, 8082, 8502, 8083, 5432, 3307, 6380)
$conflicts = @()

foreach ($port in $portsToCheck) {
    $connection = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
    if ($connection) {
        $conflicts += $port
        Write-Host "⚠️  Port $port is in use" -ForegroundColor Yellow
    }
}

if ($conflicts.Count -gt 0) {
    Write-Host ""
    Write-Host "⚠️  Warning: The following ports are in use: $($conflicts -join ', ')" -ForegroundColor Yellow
    Write-Host "You may want to stop conflicting services or modify ports in docker-compose.monorepo.yml" -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "Continue anyway? (y/n)"
    if ($continue -ne 'y') {
        Write-Host "Deployment cancelled." -ForegroundColor Red
        exit 0
    }
}

# Stop any existing dropship containers
Write-Host ""
Write-Host "🛑 Stopping existing dropship containers..." -ForegroundColor Yellow
docker-compose -f docker-compose.monorepo.yml down

# Pull base images
Write-Host ""
Write-Host "📥 Pulling base images..." -ForegroundColor Yellow
docker pull postgres:16-alpine
docker pull mysql:8.0.36
docker pull redis:alpine
docker pull php:8.3-apache
docker pull python:3.11-slim

# Build all services
Write-Host ""
Write-Host "🔨 Building Docker images for all services..." -ForegroundColor Yellow
Write-Host "This may take 10-15 minutes on first run..." -ForegroundColor Cyan

docker-compose -f docker-compose.monorepo.yml build --parallel

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ Build failed. Please check the errors above." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "✅ All images built successfully" -ForegroundColor Green

# Start services
Write-Host ""
Write-Host "🚀 Starting all services..." -ForegroundColor Yellow
docker-compose -f docker-compose.monorepo.yml up -d

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ Deployment failed. Please check the errors above." -ForegroundColor Red
    exit 1
}

# Wait for services to be healthy
Write-Host ""
Write-Host "⏳ Waiting for services to be healthy (this may take 1-2 minutes)..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

# Check service status
Write-Host ""
Write-Host "📊 Service Status:" -ForegroundColor Cyan
Write-Host "==================" -ForegroundColor Cyan
docker-compose -f docker-compose.monorepo.yml ps

Write-Host ""
Write-Host "✅ Deployment Complete!" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 Service URLs:" -ForegroundColor Cyan
Write-Host "==================" -ForegroundColor Cyan
Write-Host "📊 Marketing Suite API:  http://localhost:3030" -ForegroundColor White
Write-Host "💻 Marketing Suite UI:   http://localhost:3031" -ForegroundColor White
Write-Host "🔄 n8n Workflow:         http://localhost:5679" -ForegroundColor White
Write-Host "🎬 Video Factory API:    http://localhost:8082" -ForegroundColor White
Write-Host "🎨 Video Factory WebUI:  http://localhost:8502" -ForegroundColor White
Write-Host "🛒 Store Platform:       http://localhost:8083" -ForegroundColor White
Write-Host ""
Write-Host "📝 Default Credentials:" -ForegroundColor Cyan
Write-Host "==================" -ForegroundColor Cyan
Write-Host "Marketing Suite: admin@example.com / admin123" -ForegroundColor White
Write-Host "n8n:            admin / admin123" -ForegroundColor White
Write-Host ""
Write-Host "📋 Useful Commands:" -ForegroundColor Cyan
Write-Host "==================" -ForegroundColor Cyan
Write-Host "View logs:      docker-compose -f docker-compose.monorepo.yml logs -f" -ForegroundColor White
Write-Host "Stop services:  docker-compose -f docker-compose.monorepo.yml down" -ForegroundColor White
Write-Host "Restart:        docker-compose -f docker-compose.monorepo.yml restart" -ForegroundColor White
Write-Host "View status:    docker-compose -f docker-compose.monorepo.yml ps" -ForegroundColor White
Write-Host ""
