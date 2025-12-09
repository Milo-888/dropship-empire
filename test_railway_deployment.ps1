Write-Host ""
Write-Host "Railway Deployment Status" -ForegroundColor Cyan
Write-Host ""

$status = railway status --json 2>&1 | ConvertFrom-Json
Write-Host "Project: $($status.name)" -ForegroundColor White
Write-Host ""

$passed = 0
$warnings = 0

foreach ($edge in $status.services.edges) {
    $name = $edge.node.name
    $deployment = $edge.node.serviceInstances.edges[0].node.latestDeployment
    
    Write-Host "[$name]" -ForegroundColor Yellow
    if ($deployment -and $deployment.status -eq "SUCCESS") {
        Write-Host "  Status: Running" -ForegroundColor Green
        $passed++
    } elseif ($null -eq $deployment) {
        Write-Host "  Status: Not deployed" -ForegroundColor Yellow
        $warnings++
    } else {
        Write-Host "  Status: $($deployment.status)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Summary: $passed running, $warnings pending" -ForegroundColor Cyan
Write-Host ""
