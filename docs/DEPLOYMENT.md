# 🚀 Railway Deployment Guide

Complete guide for deploying the Dropshipping Automation Platform to Railway.

## 📋 Prerequisites

- Railway account ([Sign up](https://railway.app/))
- Git installed
- Railway CLI installed: `npm i -g @railway/cli`

## 🎯 Deployment Status

Your Railway Project: https://railway.com/project/a1db547e-c8ea-4977-84d8-cf28eb9b93be

### ✅ Already Deployed

- PostgreSQL Database - Running
- Redis Cache - Running
- video-factory Service - Configured (needs source connection)
- store-platform Service - Configured (needs source connection)

### 📝 Still Needed

- Connect GitHub repository as source
- Deploy n8n workflow engine
- Run database migrations

## 🔧 Step-by-Step Deployment

### Step 1: Push Code to GitHub

1. **Initialize Git repository** (if not already done)
   ```bash
   git init
   git add .
   git commit -m "Initial commit - Dropshipping Automation Platform"
   ```

2. **Create GitHub repository**
   - Go to https://github.com/new
   - Create a new repository
   - Follow GitHub's instructions to push

   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
   git branch -M main
   git push -u origin main
   ```

### Step 2: Connect Services to GitHub

#### video-factory Service

1. Go to Railway Dashboard → video-factory service
2. Click **Settings** tab
3. Scroll to **Source** section
4. Click **Connect Repo**
5. Select your GitHub repository
6. Set **Root Directory**: `video-factory`
7. Railway will auto-detect the Dockerfile

**Environment Variables** (already set):
```
IMAGEMAGICK_BINARY=/usr/bin/convert
OPENAI_API_KEY=<your-key>
OPENAI_BASE_URL=https://api.openai.com/v1
MOONSHOT_API_KEY=<your-key>
PEXELS_API_KEY=<your-key>
```

#### store-platform Service

1. Go to Railway Dashboard → store-platform service
2. Click **Settings** tab
3. Scroll to **Source** section
4. Click **Connect Repo**
5. Select your GitHub repository
6. Set **Root Directory**: `store-platform`
7. Set **Build Command**: `composer install && npm install && npm run build`
8. Set **Start Command**: `php artisan serve --host=0.0.0.0 --port=$PORT`

**Environment Variables** (needs to be added):
```
APP_NAME="Dropshipping Store"
APP_ENV=production
APP_DEBUG=false
APP_URL=${{RAILWAY_PUBLIC_DOMAIN}}
APP_KEY=base64:<generate-with-php-artisan-key:generate>

DB_CONNECTION=pgsql
DB_HOST=${{Postgres.PGHOST}}
DB_PORT=${{Postgres.PGPORT}}
DB_DATABASE=${{Postgres.PGDATABASE}}
DB_USERNAME=${{Postgres.PGUSER}}
DB_PASSWORD=${{Postgres.PGPASSWORD}}

CACHE_DRIVER=redis
QUEUE_CONNECTION=redis
SESSION_DRIVER=redis

REDIS_HOST=${{Redis.REDIS_HOST}}
REDIS_PASSWORD=${{Redis.REDIS_PASSWORD}}
REDIS_PORT=${{Redis.REDIS_PORT}}
```

#### marketing-suite Service

1. Click **+ New** in Railway Dashboard
2. Select **Empty Service**
3. Click **Settings** tab
4. Connect to your GitHub repository
5. Set **Root Directory**: `marketing-suite/apps/platform`
6. Set **Build Command**: `npm install && npm run build`
7. Set **Start Command**: `npm start`

**Environment Variables**:
```
NODE_ENV=production
PORT=3000
DATABASE_URL=${{Postgres.DATABASE_URL}}
REDIS_URL=${{Redis.REDIS_URL}}
```

### Step 3: Deploy n8n

1. Click **+ New** in Railway Dashboard
2. Click **Database** → Search for "n8n"
3. Select **n8n** template
4. Configure:
   - **N8N_HOST**: Use Railway generated domain
   - **N8N_PROTOCOL**: https
   - **N8N_PORT**: 5678
   - **DB_TYPE**: postgresdb
   - **DB_POSTGRESDB_HOST**: `${{Postgres.PGHOST}}`
   - **DB_POSTGRESDB_PORT**: `${{Postgres.PGPORT}}`
   - **DB_POSTGRESDB_DATABASE**: `${{Postgres.PGDATABASE}}`
   - **DB_POSTGRESDB_USER**: `${{Postgres.PGUSER}}`
   - **DB_POSTGRESDB_PASSWORD**: `${{Postgres.PGPASSWORD}}`
   - **GENERIC_TIMEZONE**: America/New_York
   - **N8N_BASIC_AUTH_ACTIVE**: true
   - **N8N_BASIC_AUTH_USER**: admin
   - **N8N_BASIC_AUTH_PASSWORD**: <secure-password>

5. Click **Deploy**

### Step 4: Deploy research-bot

1. Click **+ New** in Railway Dashboard
2. Select **Empty Service**
3. Connect to your GitHub repository
4. Set **Root Directory**: `research-bot`
5. Railway will auto-detect the Dockerfile

**Environment Variables**:
```
PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
```

### Step 5: Run Database Migrations

Once all services are deployed:

1. **Store Platform**
   ```bash
   railway run --service store-platform php artisan migrate --seed
   railway run --service store-platform php artisan bagisto:install
   ```

2. **Marketing Suite**
   ```bash
   railway run --service marketing-suite npm run db:migrate
   ```

### Step 6: Import n8n Workflow

1. Access your n8n instance (check Railway for the URL)
2. Login with credentials set in Step 3
3. Click **Import from File**
4. Upload `n8n_workflow_dropshipping_pipeline.json`
5. Configure webhook URLs and API credentials
6. Activate the workflow

## 🔗 Service URLs

After deployment, Railway will provide URLs for each service:

- **video-factory**: https://video-factory-production.up.railway.app
- **store-platform**: https://store-platform-production.up.railway.app
- **marketing-suite**: https://marketing-suite-production.up.railway.app
- **n8n**: https://n8n-production.up.railway.app

## 🔐 Setting Up Custom Domains (Optional)

1. Go to service **Settings**
2. Scroll to **Domains**
3. Click **+ Custom Domain**
4. Enter your domain
5. Add CNAME record to your DNS:
   ```
   CNAME: <your-domain> → <railway-domain>
   ```

## 🧪 Testing the Deployment

### 1. Test video-factory
```bash
curl https://your-video-factory-url.railway.app/api/ping
```

### 2. Test store-platform
Visit the URL in browser - should see Bagisto storefront

### 3. Test marketing-suite
```bash
curl https://your-marketing-suite-url.railway.app/health
```

### 4. Test n8n
Visit the URL in browser - should see n8n login

## 📊 Monitoring

### View Logs
```bash
railway logs --service video-factory
railway logs --service store-platform
railway logs --service marketing-suite
railway logs --service n8n
```

### Check Service Health
- Railway Dashboard shows service status
- Green = Running
- Red = Error/Stopped

## 💰 Cost Management

**Current Setup**: ~$39/month

- PostgreSQL: ~$5
- Redis: ~$1
- video-factory: ~$5
- store-platform: ~$10
- marketing-suite: ~$10
- n8n: ~$5
- research-bot: ~$3

**Tips to Reduce Costs**:
1. Use Railway's free $5 monthly credit
2. Scale down unused services
3. Set up auto-sleep for development environments
4. Monitor usage in Railway Dashboard

## 🐛 Troubleshooting

### Service Won't Start
1. Check logs: `railway logs --service <service-name>`
2. Verify environment variables are set correctly
3. Ensure database connections are configured

### Build Failures
1. Check build logs in Railway Dashboard
2. Verify Dockerfile or build commands
3. Ensure all dependencies are listed in requirements/package files

### Database Connection Issues
1. Verify PostgreSQL service is running
2. Check that `${{Postgres.*}}` variables are correctly referenced
3. Ensure database migrations have run

### n8n Workflow Errors
1. Check n8n logs
2. Verify API credentials in workflow
3. Ensure webhook URLs point to correct Railway domains

## 🆘 Support

- **Railway Docs**: https://docs.railway.app/
- **Railway Discord**: https://discord.gg/railway
- **Project Issues**: Open an issue on GitHub

## 📝 Next Steps

After successful deployment:

1. ✅ Set up custom domains
2. ✅ Configure SSL certificates (automatic with Railway)
3. ✅ Set up monitoring and alerts
4. ✅ Configure backup strategy
5. ✅ Test complete workflow end-to-end

---

**Deployment Status**: 80% Complete → Need to connect GitHub sources
**Estimated Time to Complete**: 15-30 minutes
