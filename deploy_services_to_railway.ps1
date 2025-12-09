Write-Host ""
Write-Host "Deploy Services to Railway" -ForegroundColor Cyan
Write-Host ""

$status = railway status --json 2>&1 | ConvertFrom-Json
$projectId = $status.id

$gitRemote = git remote get-url origin 2>&1
if ($gitRemote -match "github.com[:/]([^/]+)/([^/]+?)(.git)?$") {
    $owner = $matches[1]
    $repo = $matches[2]
    Write-Host "GitHub: $owner/$repo" -ForegroundColor Green
} else {
    Write-Host "ERROR: No GitHub remote found" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Dashboard: https://railway.com/project/$projectId" -ForegroundColor Cyan
Write-Host ""
Write-Host "Services to deploy:" -ForegroundColor Yellow
Write-Host "  1. video-factory (root: video-factory)" -ForegroundColor White
Write-Host "  2. store-platform (root: store-platform)" -ForegroundColor White
Write-Host "  3. marketing-suite (root: marketing-suite/apps/platform)" -ForegroundColor White
Write-Host "  4. research-bot (root: research-bot)" -ForegroundColor White
Write-Host "  5. n8n (root: n8n-service)" -ForegroundColor White
Write-Host ""
Write-Host "For each service:" -ForegroundColor Yellow
Write-Host "  - Click service in Railway Dashboard" -ForegroundColor Gray
Write-Host "  - Settings > Source > Connect Repo" -ForegroundColor Gray
Write-Host "  - Select: $owner/$repo" -ForegroundColor Gray
Write-Host "  - Set root directory as shown above" -ForegroundColor Gray
Write-Host "  - Add environment variables (see docs/ENVIRONMENT_VARIABLES.md)" -ForegroundColor Gray
Write-Host ""
