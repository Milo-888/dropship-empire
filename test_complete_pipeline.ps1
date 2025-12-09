Write-Host ""
Write-Host "Complete Pipeline Test" -ForegroundColor Cyan
Write-Host ""

$status = railway status --json 2>&1 | ConvertFrom-Json
$serviceUrls = @{}

foreach ($edge in $status.services.edges) {
    $name = $edge.node.name
    $domains = $edge.node.serviceInstances.edges[0].node.domains.serviceDomains
    if ($domains.Count -gt 0) {
        $serviceUrls[$name] = "https://$($domains[0].domain)"
    }
}

$passed = 0
$failed = 0

foreach ($service in @("video-factory", "store-platform", "marketing-suite", "research-bot", "n8n")) {
    Write-Host "[$service]" -ForegroundColor Yellow
    if ($serviceUrls.ContainsKey($service)) {
        $url = $serviceUrls[$service]
        try {
            $response = Invoke-WebRequest -Uri $url -Method GET -TimeoutSec 5 -ErrorAction Stop
            Write-Host "  OK: $url" -ForegroundColor Green
            $passed++
        } catch {
            Write-Host "  FAIL: $($_.Exception.Message)" -ForegroundColor Red
            $failed++
        }
    } else {
        Write-Host "  Not deployed" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Summary: $passed passed, $failed failed" -ForegroundColor Cyan
Write-Host ""
