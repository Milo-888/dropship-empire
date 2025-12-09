# Railway CLI Deployment Results

## ✅ Successfully Completed via CLI

### Services Created
All 5 services were successfully created and connected to GitHub:

1. **video-factory** - Connected to ascathleticsinc/dropship-empire
2. **store-platform** - Connected to ascathleticsinc/dropship-empire  
3. **marketing-suite** - Connected to ascathleticsinc/dropship-empire
4. **research-bot** - Connected to ascathleticsinc/dropship-empire
5. **n8n** - Connected to ascathleticsinc/dropship-empire

### Current Status

| Service | Status | Root Directory | Issue |
|---------|--------|----------------|-------|
| video-factory | FAILED | Not set | ❌ Needs root directory |
| store-platform | NOT_DEPLOYED | Not set | ❌ Needs root directory |
| marketing-suite | INITIALIZING | Not set | ⚠️ Will fail without root dir |
| research-bot | INITIALIZING | Not set | ⚠️ Will fail without root dir |
| n8n | INITIALIZING | Not set | ⚠️ Will fail without root dir |

## ❌ Railway CLI Limitation Discovered

**Problem**: Railway CLI cannot set Root Directory for services

**Impact**: Services fail to deploy because Railway doesn't know which folder to build

**Error**: 
```
Railpack could not determine how to build the app.
The app contents that Railpack analyzed contains:
./
├── video-factory/
├── store-platform/
├── marketing-suite/
├── research-bot/
├── n8n-service/
└── ...
```

**Why**: The repository is a monorepo with multiple services in subdirectories. Without Root Directory specified, Railway tries to build from the repo root and finds multiple projects, causing confusion.

## ✅ Solution: Use Railway Dashboard

Root Directory **must** be set via Railway Dashboard UI. There is no CLI command for this.

### Required Dashboard Configuration

**Dashboard URL**: https://railway.app/project/0430886a-da4f-414d-8305-4aaa3d734959

For each service:

#### 1. video-factory
```
Settings > Source > Root Directory: video-factory
Settings > Deploy > Build Command: (auto-detected from Dockerfile)
Variables:
  - PORT=8080
  - HOST=0.0.0.0
  - IMAGEMAGICK_BINARY=/usr/bin/convert
  - OPENAI_API_KEY=<your-key>
  - PEXELS_API_KEY=<your-key>
```

#### 2. store-platform
```
Settings > Source > Root Directory: store-platform
Variables:
  - APP_ENV=production
  - APP_DEBUG=false
  - APP_URL=${{RAILWAY_PUBLIC_DOMAIN}}
  - DB_HOST=${{Postgres.PGHOST}}
  - DB_PORT=${{Postgres.PGPORT}}
  - DB_DATABASE=${{Postgres.PGDATABASE}}
  - DB_USERNAME=${{Postgres.PGUSER}}
  - DB_PASSWORD=${{Postgres.PGPASSWORD}}
  - REDIS_HOST=${{Redis.REDIS_HOST}}
  - REDIS_PORT=${{Redis.REDIS_PORT}}
  - REDIS_PASSWORD=${{Redis.REDIS_PASSWORD}}
```

#### 3. marketing-suite
```
Settings > Source > Root Directory: marketing-suite/apps/platform
Variables:
  - NODE_ENV=production
  - PORT=3000
  - DATABASE_URL=${{Postgres.DATABASE_URL}}
  - REDIS_URL=${{Redis.REDIS_URL}}
```

#### 4. research-bot
```
Settings > Source > Root Directory: research-bot
Variables:
  - PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
  - PORT=8090
```

#### 5. n8n
```
Settings > Source > Root Directory: n8n-service
Variables:
  - N8N_HOST=${{RAILWAY_PUBLIC_DOMAIN}}
  - N8N_PROTOCOL=https
  - N8N_PORT=5678
  - DB_TYPE=postgresdb
  - DB_POSTGRESDB_HOST=${{Postgres.PGHOST}}
  - DB_POSTGRESDB_PORT=${{Postgres.PGPORT}}
  - DB_POSTGRESDB_DATABASE=${{Postgres.PGDATABASE}}
  - DB_POSTGRESDB_USER=${{Postgres.PGUSER}}
  - DB_POSTGRESDB_PASSWORD=${{Postgres.PGPASSWORD}}
  - N8N_BASIC_AUTH_ACTIVE=true
  - N8N_BASIC_AUTH_USER=admin
  - N8N_BASIC_AUTH_PASSWORD=<secure-password>
```

## 🔄 After Setting Root Directories

Once root directories are set in Dashboard:

1. Railway will automatically trigger redeployment
2. Each service will build from its correct subdirectory
3. Dockerfiles will be detected and used
4. Services should deploy successfully

## 📊 Estimated Time

- Setting root directories: 5 minutes
- Adding environment variables: 10 minutes  
- Waiting for deployments: 5-10 minutes
- **Total**: ~20-25 minutes

## 🎯 Success Criteria

All services showing:
- ✅ Status: SUCCESS (green)
- ✅ Root Directory: Set correctly
- ✅ Latest Deployment: Successful
- ✅ Public URL: Generated

## 📝 What We Learned

1. **Railway CLI is good for**:
   - Creating services ✅
   - Connecting to GitHub ✅
   - Setting environment variables ✅
   - Viewing logs (with timeouts)
   - Triggering redeployments

2. **Railway CLI cannot**:
   - Set Root Directory ❌
   - Handle large file uploads reliably ❌
   - Configure build settings ❌

3. **Dashboard is required for**:
   - Root Directory configuration
   - Build command customization
   - Deployment settings
   - Domain configuration

## 🚀 Next Action

**Open Railway Dashboard and set Root Directory for each service.**

This is the final blocker. Once done, all services will deploy automatically.

---

**Project**: dreamcanvas-ai  
**GitHub**: ascathleticsinc/dropship-empire  
**Status**: Services created, awaiting root directory configuration  
**Time to Complete**: 20-25 minutes
