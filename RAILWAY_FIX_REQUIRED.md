# ⚠️ CRITICAL: Manual Railway Configuration Required

## Current Status

**All services are FAILING** because Railway is building from the monorepo root instead of individual service directories.

### Evidence from Logs:
```
./
├── .github/
├── docs/
├── marketing-suite/
├── n8n-service/
├── research-bot/
├── store-platform/
├── video-factory/
```

This shows Railway is looking at the entire repository, not the service-specific folders.

## Why This Is Happening

Railway's `railway.toml` monorepo configuration file **does not automatically set root directories** for existing services. It only works when creating NEW services.

Since the services were created via CLI first, they don't have root directories set, and the `railway.toml` file won't apply to them retroactively.

## REQUIRED FIX (5 minutes)

You **MUST** manually set the root directory for each service in the Railway Dashboard:

### Step-by-Step Instructions:

1. **Open Railway Dashboard:**
   - Go to: https://railway.app/project/0430886a-da4f-414d-8305-4aaa3d734959

2. **For EACH of the 5 services, do the following:**

   #### Service: video-factory
   - Click on **video-factory** service
   - Click **Settings** (left sidebar)
   - Scroll to **Source** section
   - Click **Edit** next to "Root Directory"
   - Set to: `video-factory`
   - Click **Save**

   #### Service: research-bot
   - Click on **research-bot** service
   - Settings → Source → Root Directory
   - Set to: `research-bot`
   - Save

   #### Service: n8n
   - Click on **n8n** service
   - Settings → Source → Root Directory
   - Set to: `n8n-service`
   - Save

   #### Service: marketing-suite
   - Click on **marketing-suite** service
   - Settings → Source → Root Directory
   - Set to: `marketing-suite/apps/platform`
   - Save

   #### Service: store-platform
   - Click on **store-platform** service
   - Settings → Source → Root Directory
   - Set to: `store-platform`
   - Save

3. **Trigger Redeployment:**
   - After setting root directory for each service, Railway should automatically redeploy
   - OR click the **Deploy** button in each service

## What Should Happen After Fix

Once root directories are set correctly, the build logs should show:

### ✅ Correct Output (video-factory example):
```
./
├── app/
├── webui/
├── resource/
├── Dockerfile
├── requirements.txt
├── railway.json
```

### ❌ Wrong Output (current):
```
./
├── marketing-suite/
├── n8n-service/
├── research-bot/
├── store-platform/
├── video-factory/
```

## Alternative: Delete & Recreate Services (NOT RECOMMENDED)

If you prefer, you could delete all services and recreate them using the Railway Dashboard (not CLI), where you can set root directories during creation. However, **manually setting root directories is faster**.

## Verification Commands

After setting root directories, verify deployment:

```powershell
# Check each service
railway logs --service video-factory --lines 30
railway logs --service research-bot --lines 30
railway logs --service n8n --lines 30
railway logs --service marketing-suite --lines 30
railway logs --service store-platform --lines 30
```

Look for successful build messages and correct directory structure in the logs.

## Why railway.toml Was Created

The `railway.toml` file is still useful for:
- Documentation of service structure
- Future services created from scratch
- Local development configuration

But it **cannot** retroactively fix existing services created without root directories.

---

## Summary

✅ Configuration files pushed to GitHub  
❌ Services still failing due to missing root directories  
🔧 **ACTION REQUIRED:** Set root directory for all 5 services in Railway Dashboard  
⏱️ **Time Required:** ~5 minutes  
🔗 **Dashboard Link:** https://railway.app/project/0430886a-da4f-414d-8305-4aaa3d734959
