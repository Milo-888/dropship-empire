Write-Host ""
Write-Host "n8n Workflow Setup" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path "n8n_workflow_dropshipping_pipeline.json")) {
    Write-Host "ERROR: Workflow file not found" -ForegroundColor Red
    exit 1
}

$status = railway status --json 2>&1 | ConvertFrom-Json
$n8nService = $status.services.edges | Where-Object { $_.node.name -eq "n8n" }

if ($n8nService) {
    $domains = $n8nService.node.serviceInstances.edges[0].node.domains.serviceDomains
    if ($domains.Count -gt 0) {
        $url = "https://$($domains[0].domain)"
        Write-Host "n8n URL: $url" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Environment Variables Required:" -ForegroundColor Yellow
Write-Host "  N8N_HOST=${{RAILWAY_PUBLIC_DOMAIN}}" -ForegroundColor Gray
Write-Host "  N8N_PROTOCOL=https" -ForegroundColor Gray
Write-Host "  N8N_PORT=5678" -ForegroundColor Gray
Write-Host "  DB_TYPE=postgresdb" -ForegroundColor Gray
Write-Host "  DB_POSTGRESDB_HOST=${{Postgres.PGHOST}}" -ForegroundColor Gray
Write-Host "  DB_POSTGRESDB_PORT=${{Postgres.PGPORT}}" -ForegroundColor Gray
Write-Host "  DB_POSTGRESDB_DATABASE=${{Postgres.PGDATABASE}}" -ForegroundColor Gray
Write-Host "  DB_POSTGRESDB_USER=${{Postgres.PGUSER}}" -ForegroundColor Gray
Write-Host "  DB_POSTGRESDB_PASSWORD=${{Postgres.PGPASSWORD}}" -ForegroundColor Gray
Write-Host "  N8N_BASIC_AUTH_ACTIVE=true" -ForegroundColor Gray
Write-Host "  N8N_BASIC_AUTH_USER=admin" -ForegroundColor Gray
Write-Host "  N8N_BASIC_AUTH_PASSWORD=<your-password>" -ForegroundColor Gray
Write-Host ""
Write-Host "After deployment:" -ForegroundColor Yellow
Write-Host "  1. Access n8n at the URL above" -ForegroundColor Gray
Write-Host "  2. Login with credentials" -ForegroundColor Gray
Write-Host "  3. Import n8n_workflow_dropshipping_pipeline.json" -ForegroundColor Gray
Write-Host "  4. Update service URLs in workflow" -ForegroundColor Gray
Write-Host ""
