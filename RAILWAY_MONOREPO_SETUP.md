# Railway Monorepo Configuration

## What Was Done

### 1. Created Railway Monorepo Configuration
Created `railway.toml` at the root of the repository to tell Railway where each service is located:

```toml
[[services]]
name = "video-factory"
root = "video-factory"
dockerfile = "video-factory/Dockerfile"

[[services]]
name = "research-bot"
root = "research-bot"
dockerfile = "research-bot/Dockerfile"

[[services]]
name = "n8n"
root = "n8n-service"
dockerfile = "n8n-service/Dockerfile"

[[services]]
name = "marketing-suite"
root = "marketing-suite/apps/platform"
dockerfile = "marketing-suite/apps/platform/Dockerfile"

[[services]]
name = "store-platform"
root = "store-platform"
```

### 2. Created Missing railway.json Files
Added `railway.json` configuration files for:
- `marketing-suite/apps/platform/railway.json` - Dockerfile builder
- `store-platform/railway.json` - Nixpacks builder

### 3. Pushed to GitHub
All configuration files have been committed and pushed to the main branch.

## Next Steps

### Option 1: Verify Root Directory in Railway Dashboard (RECOMMENDED)

Railway may need manual configuration via the dashboard. For each service:

1. Open: https://railway.app/project/0430886a-da4f-414d-8305-4aaa3d734959
2. Click on each service
3. Go to **Settings → Source**
4. Verify **Root Directory** is set correctly:
   - `video-factory` → `video-factory`
   - `research-bot` → `research-bot`
   - `n8n` → `n8n-service`
   - `marketing-suite` → `marketing-suite/apps/platform`
   - `store-platform` → `store-platform`
5. Click **Deploy** to trigger redeployment

### Option 2: Wait for Automatic Redeployment

Railway should automatically detect the changes from GitHub and redeploy all services with the correct configuration from `railway.toml`.

## Monitoring Deployment

Use the monitoring script to check deployment progress:

```powershell
.\tmp_rovodev_monitor_railway.ps1
```

Or check individual service logs:

```bash
railway logs --service video-factory
railway logs --service research-bot
railway logs --service n8n
railway logs --service marketing-suite
railway logs --service store-platform
```

## Expected Behavior

After proper configuration, each service should:
1. Build from its specific directory (not the monorepo root)
2. Use the correct Dockerfile or nixpacks.toml
3. Deploy successfully with environment variables
4. Show "RUNNING" status in Railway dashboard

## Troubleshooting

If services still fail:

1. **Check Root Directory**: Ensure it's set in Railway Dashboard (Settings → Source)
2. **Check Build Logs**: Look for the correct directory structure in build output
3. **Verify Dockerfile Path**: Should show the service's own files, not the entire monorepo
4. **Environment Variables**: Ensure all required env vars are set (see railway_env_variables.txt)

## Files Modified/Created

- ✅ `railway.toml` - Root configuration for monorepo
- ✅ `marketing-suite/apps/platform/railway.json` - Service configuration
- ✅ `store-platform/railway.json` - Service configuration
- ✅ All files pushed to GitHub main branch
