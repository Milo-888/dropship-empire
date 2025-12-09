# Railway Deployment Checklist

## ✅ Pre-Deployment

- [x] Code pushed to GitHub: https://github.com/Milo-888/dropship-empire
- [x] PostgreSQL deployed and running
- [x] Redis deployed and running
- [x] Railway CLI authenticated
- [x] Services created: video-factory, store-platform

## 🚀 Service Deployment

### 1. video-factory
- [ ] Connect GitHub repo in Railway Dashboard
- [ ] Set root directory: `video-factory`
- [ ] Add environment variables (see railway_env_variables.txt)
- [ ] Wait for successful deployment
- [ ] Test endpoint: `https://<url>/api/ping`

### 2. store-platform
- [ ] Connect GitHub repo in Railway Dashboard
- [ ] Set root directory: `store-platform`
- [ ] Add environment variables
- [ ] Generate APP_KEY: `railway run --service store-platform php artisan key:generate --show`
- [ ] Add APP_KEY to variables
- [ ] Run migrations: `railway run --service store-platform php artisan migrate --seed`
- [ ] Test endpoint: `https://<url>`

### 3. marketing-suite
- [ ] Create new service in Railway
- [ ] Connect GitHub repo
- [ ] Set root directory: `marketing-suite/apps/platform`
- [ ] Add environment variables
- [ ] Wait for deployment
- [ ] Test endpoint: `https://<url>/health`

### 4. research-bot
- [ ] Create new service in Railway
- [ ] Connect GitHub repo
- [ ] Set root directory: `research-bot`
- [ ] Add environment variables
- [ ] Wait for deployment
- [ ] Test endpoint: `https://<url>`

### 5. n8n
- [ ] Create new service in Railway
- [ ] Connect GitHub repo
- [ ] Set root directory: `n8n-service`
- [ ] Add environment variables
- [ ] Set strong password for N8N_BASIC_AUTH_PASSWORD
- [ ] Wait for deployment
- [ ] Access n8n UI: `https://<url>`
- [ ] Login with admin credentials
- [ ] Import workflow: `n8n_workflow_dropshipping_pipeline.json`

## 🔧 Post-Deployment

### Database Setup
- [ ] store-platform migrations completed
- [ ] n8n database tables created (automatic)

### Service URLs
Document all service URLs here:
- [ ] video-factory: _______________
- [ ] store-platform: _______________
- [ ] marketing-suite: _______________
- [ ] research-bot: _______________
- [ ] n8n: _______________

### n8n Workflow Configuration
- [ ] Workflow imported
- [ ] Update all HTTP request nodes with service URLs
- [ ] Configure API credentials
- [ ] Test workflow execution
- [ ] Activate workflow

## 🧪 Testing

### Individual Service Tests
- [ ] video-factory API responds
- [ ] store-platform loads
- [ ] marketing-suite API responds
- [ ] research-bot responds
- [ ] n8n UI accessible

### Integration Tests
- [ ] n8n can call video-factory API
- [ ] n8n can call store-platform API
- [ ] n8n can call marketing-suite API
- [ ] Complete workflow executes successfully

### Database Connections
- [ ] store-platform connects to PostgreSQL
- [ ] marketing-suite connects to PostgreSQL
- [ ] n8n connects to PostgreSQL
- [ ] All services can use Redis cache

## 📊 Monitoring

- [ ] Check Railway logs for all services
- [ ] Verify no errors in deployment logs
- [ ] Monitor resource usage
- [ ] Set up alerts (optional)

## 💰 Cost Verification

Expected monthly cost: ~$39
- PostgreSQL: ~$5
- Redis: ~$1
- video-factory: ~$5
- store-platform: ~$10
- marketing-suite: ~$10
- n8n: ~$5
- research-bot: ~$3

Current spend: Check Railway Dashboard

## 🔐 Security

- [ ] All API keys stored in Railway variables (not in code)
- [ ] Strong passwords set for n8n
- [ ] Database credentials are Railway-managed
- [ ] No sensitive data in logs

## 📝 Documentation

- [ ] Service URLs documented
- [ ] API credentials stored securely
- [ ] Team members have access to Railway project
- [ ] Backup strategy defined

## ✅ Completion Criteria

All services show:
- ✅ Green status in Railway Dashboard
- ✅ Successful latest deployment
- ✅ Responding to health checks
- ✅ No errors in logs

---

**Status**: In Progress
**Last Updated**: 2024
**Railway Project**: https://railway.com/project/a1db547e-c8ea-4977-84d8-cf28eb9b93be
