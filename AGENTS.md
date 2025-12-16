# Agent Instructions for Dropshipping Automation Platform

## Project Overview

This is a **multi-service dropshipping automation platform** that integrates e-commerce, marketing automation, video generation, web scraping, and workflow orchestration.

### Tech Stack Summary
- **Languages**: TypeScript/Node.js, PHP, Python
- **Frameworks**: Laravel 11, React, FastAPI, Playwright
- **Deployment**: Railway (monorepo with 5 services)
- **Orchestration**: n8n workflow automation
- **Databases**: PostgreSQL, MySQL, Redis

## Repository Structure

### Root Directory
- Monorepo containing 5 independent microservices
- Each service has its own `railway.json` or Dockerfile configuration
- Shared documentation in `docs/` directory
- GitHub Actions workflow in `.github/workflows/`

### Microservices

#### 1. `store-platform/` - E-Commerce Store
- **Framework**: Bagisto (Laravel 11 PHP e-commerce platform)
- **Language**: PHP 8.2+
- **Database**: MySQL
- **Build**: Nixpacks (managed by `nixpacks.toml`)
- **Key Commands**:
  - `composer install` - Install PHP dependencies
  - `php artisan migrate` - Run database migrations
  - `php artisan serve` - Local development
- **Package Manager**: Composer
- **Testing**: PHPUnit, Pest
- **Code Style**: Laravel Pint (configured in `pint.json`)
- **Important Files**:
  - `composer.json` - PHP dependencies
  - `artisan` - Laravel CLI tool
  - `packages/Webkul/` - Custom Bagisto packages
  - `auto_setup.php`, `create_admin.php`, `reset_admin.php` - Setup utilities

#### 2. `marketing-suite/` - Marketing Automation
- **Framework**: Parcelvoy (custom Node.js/TypeScript platform)
- **Monorepo Tool**: Lerna (workspace management)
- **Structure**:
  - `apps/platform/` - Backend API (Koa.js)
  - `apps/ui/` - Frontend (React + TypeScript)
  - `docs/` - Docusaurus documentation site
- **Language**: TypeScript
- **Database**: PostgreSQL
- **Key Commands**:
  - `npm install` - Install dependencies
  - `lerna run start` - Start all apps
  - `lerna run build` - Build all apps
  - `lerna run test` - Run tests
- **Backend**: Koa.js, BullMQ, Knex.js
- **Frontend**: React 18, React Router v6, TailwindCSS
- **Testing**: Jest

#### 3. `video-factory/` - AI Video Generation
- **Framework**: FastAPI (Python)
- **Language**: Python 3.11
- **Purpose**: Automated video creation from text using AI/LLMs
- **Key Dependencies**:
  - `moviepy` - Video processing
  - `streamlit` - Web UI
  - `openai`, `google.generativeai` - LLM integrations
  - `edge_tts`, `azure-cognitiveservices-speech` - Text-to-speech
- **Key Commands**:
  - `pip install -r requirements.txt` - Install dependencies
  - `python main.py` - Start API server
  - `streamlit run webui/Main.py` - Start web UI
- **Build**: Dockerfile (Python slim base)
- **Important Files**:
  - `main.py` - FastAPI entry point
  - `config.example.toml` - Configuration template
  - `webui/Main.py` - Streamlit web interface

#### 4. `research-bot/` - Web Scraping & Browser Automation
- **Framework**: Playwright for Python
- **Language**: Python 3.11
- **Purpose**: Browser automation and web scraping
- **Key Dependencies**:
  - `playwright` - Browser automation
  - `greenlet`, `pyee` - Async support
- **Key Commands**:
  - `pip install -r requirements.txt` - Install dependencies
  - `playwright install` - Install browser binaries
- **Testing**: Pytest (extensive test suite in `tests/`)
- **Build**: Dockerfile (Python slim base)

#### 5. `n8n-service/` - Workflow Automation
- **Platform**: n8n (workflow automation)
- **Base**: Official n8n Docker image
- **Purpose**: Orchestrates communication between all services
- **Database**: PostgreSQL (shared with marketing-suite)
- **Build**: Dockerfile extending `n8nio/n8n:latest`
- **Workflow**: `n8n_workflow_dropshipping_pipeline.json` (root directory)

## Development Guidelines

### Code Style & Conventions

#### TypeScript/JavaScript (marketing-suite)
- Use TypeScript strict mode
- ESLint with standard configuration
- Functional components with hooks for React
- Async/await for asynchronous operations
- Use Lerna for monorepo management

#### PHP (store-platform)
- Follow PSR-4 autoloading standards
- Use Laravel conventions (Eloquent, Blade, Artisan)
- Code style enforced by Laravel Pint
- Namespaces: `Webkul\{PackageName}\`
- Testing with Pest/PHPUnit

#### Python (video-factory, research-bot)
- PEP 8 style guide
- Type hints where applicable
- Async/await for I/O operations
- Use virtual environments (`venv`)
- FastAPI for APIs, Playwright for automation

### Environment Variables

**CRITICAL**: Never commit `.env` files. Always use `.env.example` templates.

Key environment files:
- Each service has its own `.env.example`
- See `docs/ENVIRONMENT_VARIABLES.md` for complete reference
- Railway uses service references: `${{ServiceName.VARIABLE}}`

### Database Conventions

#### PostgreSQL (marketing-suite, n8n)
- Use Knex.js migrations for schema changes
- Store migrations in `marketing-suite/apps/platform/db/`
- Connection pooling configured via environment variables

#### MySQL (store-platform)
- Laravel migrations in `store-platform/database/migrations/`
- Use Eloquent ORM for database operations
- Seeders in `database/seeders/`

### Testing Best Practices

#### Before Committing
- Run linters: `npm run lint` or `composer run pint`
- Run tests locally when available
- Test Docker builds: `docker build -t test-image .`

#### Service-Specific Testing
- **marketing-suite/apps/platform**: `npm test` (Jest)
- **marketing-suite/apps/ui**: `npm test` (React Testing Library)
- **store-platform**: `php artisan test` (Pest)
- **video-factory**: Manual API testing or `pytest test/`
- **research-bot**: `pytest tests/`

### Git Workflow

#### Branch Naming
- `feature/{description}` - New features
- `fix/{description}` - Bug fixes
- `docs/{description}` - Documentation updates
- `refactor/{description}` - Code refactoring

#### Commit Messages
- Use conventional commits format
- Examples:
  - `feat(video-factory): add new LLM provider support`
  - `fix(store-platform): resolve checkout validation issue`
  - `docs: update deployment guide`
  - `chore(deps): update dependencies`

#### Files to Never Commit
- `.env` files (already in .gitignore)
- `node_modules/`, `vendor/`, `venv/`, `__pycache__/`
- Build outputs: `dist/`, `build/`, `storage/`
- Temporary files starting with `tmp_rovodev_*`
- IDE configs: `.vscode/`, `.idea/`

## Railway Deployment

### Monorepo Configuration

The project uses `railway.toml` to define service roots:
- Each service points to its subdirectory
- Railway auto-detects `railway.json` in each service root
- Build methods: Dockerfile (most services) or Nixpacks (store-platform)

### Deployment Steps

1. **Push to GitHub**
   ```bash
   git push origin main
   ```

2. **Connect Services** (in Railway Dashboard)
   - Each service needs its root directory configured
   - Set environment variables per service
   - Link shared PostgreSQL database

3. **Service Dependencies**
   - PostgreSQL must deploy before marketing-suite and n8n
   - Redis should deploy before services that use caching
   - Services communicate via internal Railway URLs

### Health Checks

Services with health check endpoints:
- `marketing-suite/apps/platform`: `/health`
- `video-factory`: `/`
- `store-platform`: `/`

Configure in `railway.json`:
```json
"healthcheckPath": "/health",
"healthcheckTimeout": 100
```

## Common Tasks

### Add New Dependency

**Node.js services**:
```bash
cd marketing-suite/apps/platform
npm install <package>
# or for UI
cd marketing-suite/apps/ui
npm install <package>
```

**PHP service**:
```bash
cd store-platform
composer require <package>
```

**Python services**:
```bash
cd video-factory  # or research-bot
pip install <package>
pip freeze > requirements.txt
```

### Create Database Migration

**Laravel (store-platform)**:
```bash
php artisan make:migration create_table_name
php artisan migrate
```

**Knex (marketing-suite)**:
```bash
cd marketing-suite/apps/platform
npm run migration:create <migration_name>
```

### Run Services Locally

**Marketing Suite**:
```bash
cd marketing-suite
npm install
lerna run start
```

**Store Platform**:
```bash
cd store-platform
composer install
php artisan serve
```

**Video Factory**:
```bash
cd video-factory
pip install -r requirements.txt
python main.py
```

**Research Bot**:
```bash
cd research-bot
pip install -r requirements.txt
playwright install
python scraper.py
```

**n8n**:
```bash
docker run -it --rm \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n
```

### Docker Development

Each service has a Dockerfile. To test locally:
```bash
cd <service-directory>
docker build -t <service-name>:test .
docker run -p 8080:8080 --env-file .env <service-name>:test
```

### Update Documentation

Documentation is in:
- `docs/` - Technical documentation (Architecture, Deployment, Environment)
- `README.md` - Project overview
- `QUICK_START.md` - Quick start guide
- Service-specific READMEs in each service directory

When updating docs:
- Keep `docs/ARCHITECTURE.md` in sync with system changes
- Update `docs/ENVIRONMENT_VARIABLES.md` when adding new env vars
- Update service READMEs when changing service-specific configuration

## Troubleshooting

### Build Failures

**Node.js "out of memory"**:
```bash
export NODE_OPTIONS="--max-old-space-size=4096"
npm run build
```

**PHP missing extensions**:
- Check `composer.json` `require` section
- Install via package manager: `apt-get install php8.2-<extension>`

**Python dependency conflicts**:
```bash
pip install --upgrade pip
pip install -r requirements.txt --force-reinstall
```

### Database Connection Issues

**Check environment variables**:
```bash
# PostgreSQL
echo $DB_POSTGRESDB_HOST
# MySQL
echo $DB_HOST
```

**Test connection**:
```bash
# PostgreSQL
psql -h $DB_HOST -U $DB_USER -d $DB_NAME
# MySQL
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME
```

### Railway Deployment Issues

**Service won't start**:
1. Check logs in Railway Dashboard
2. Verify environment variables are set
3. Ensure health check path is correct
4. Check database connectivity

**Build timeouts**:
- Increase build timeout in Railway settings
- Optimize Docker builds with multi-stage builds
- Use `.dockerignore` to exclude unnecessary files

**Database migration errors**:
- Run migrations manually: Connect via Railway CLI
- Check migration files for syntax errors
- Ensure database exists and user has permissions

## Service Communication

### Internal URLs (Railway)

Services communicate via Railway's internal network:
- Format: `http://<service-name>.railway.internal:<port>`
- Example: `http://marketing-suite.railway.internal:3000`

### n8n Workflow Integration

The n8n workflow (`n8n_workflow_dropshipping_pipeline.json`) orchestrates:
1. Product research via research-bot
2. Video generation via video-factory
3. Store updates via store-platform API
4. Marketing campaigns via marketing-suite API

Update workflow URLs after deployment:
1. Access n8n UI
2. Import workflow file
3. Update each node's URL to match Railway service domains

## Security Best Practices

### Secrets Management
- Store secrets in Railway environment variables
- Use Railway's secret references: `${{ServiceName.SECRET}}`
- Never log sensitive information
- Rotate API keys and passwords regularly

### API Security
- Enable authentication on all public endpoints
- Use HTTPS for all external communication
- Implement rate limiting (already in marketing-suite)
- Validate and sanitize all inputs

### Database Security
- Use parameterized queries (Eloquent/Knex handle this)
- Limit database user permissions
- Enable SSL for database connections in production
- Regular backups via Railway

## Performance Optimization

### Frontend (marketing-suite/apps/ui)
- Use React.memo for expensive components
- Implement code splitting with React.lazy
- Optimize bundle size (check with `npm run analyze:ui:bundle`)
- Use image optimization (next/image patterns)

### Backend APIs
- Implement caching with Redis
- Use database connection pooling
- Add pagination to list endpoints
- Use async operations for I/O bound tasks

### Python Services
- Use async/await for concurrent operations
- Implement request batching for external APIs
- Cache expensive computations
- Profile with cProfile for bottlenecks

## Documentation References

- `README.md` - Project overview and features
- `QUICK_START.md` - Quick deployment guide
- `docs/ARCHITECTURE.md` - System architecture and data flow
- `docs/DEPLOYMENT.md` - Complete Railway deployment instructions
- `docs/ENVIRONMENT_VARIABLES.md` - All environment variables reference
- `docs/N8N_SETUP.md` - n8n workflow setup and configuration
- `GITHUB_SETUP.md` - GitHub repository setup guide

## Getting Help

### Internal Resources
- Check service-specific README files
- Review `docs/` directory for technical details
- Examine `.env.example` files for configuration options

### External Resources
- **Bagisto**: https://devdocs.bagisto.com
- **Parcelvoy**: https://github.com/parcelvoy/platform
- **n8n**: https://docs.n8n.io
- **Playwright**: https://playwright.dev/python
- **Laravel**: https://laravel.com/docs
- **React**: https://react.dev
- **FastAPI**: https://fastapi.tiangolo.com

## Important Notes for AI Agents

### Current Deployment Configuration

**Docker Compose File:** `docker-compose.monorepo.yml` (local development)  
**Railway Config:** `railway.toml` (production deployment)  
**Network:** `dropship-network` (Docker bridge network)  

### Service Interconnections

Services communicate via Docker network names (not localhost):
- `dropship-postgres` - PostgreSQL database
- `dropship-mysql` - MySQL database  
- `dropship-redis` - Redis cache
- `dropship-n8n` - n8n workflow engine
- `dropship-video-api` - Video Factory API
- `dropship-video-webui` - Video Factory UI
- `dropship-store` - Store Platform
- `dropship-research-bot` - Research Bot
- `marketing-suite-api-1` - Marketing API (existing deployment)

### When Making Changes

1. **Identify the correct service** - This is a monorepo with 5 independent services
2. **Check service-specific conventions** - Each has different language/framework patterns
3. **Test in isolation** - Changes to one service shouldn't break others
4. **Update environment variables** - Document any new env vars in `docs/ENVIRONMENT_VARIABLES.md`
5. **Maintain Railway configs** - Update `railway.json` if changing build/deploy behavior
6. **Docker build context matters** - Marketing suite uses `./marketing-suite` as context, not subdirectories
7. **Clear caches after changes** - Laravel and other frameworks cache aggressively

### Before Suggesting Code Changes

1. **Review existing patterns** - Match the coding style of the service
2. **Check dependencies** - Don't assume packages are installed
3. **Consider deployment** - Changes must work in Railway's containerized environment
4. **Think about scaling** - Services run in separate containers

### Common Pitfalls to Avoid

- Don't mix service dependencies (e.g., importing store-platform code in video-factory)
- Don't hardcode URLs - use environment variables
- Don't commit sensitive data or credentials
- Don't break existing API contracts without versioning
- Don't ignore TypeScript/PHP type errors
- Don't skip database migrations for schema changes
- Don't use Windows line endings (CRLF) in shell scripts - always use Unix (LF)
- Don't assume localhost works in Docker - use service names
- Don't forget to clear Laravel caches after config changes
- Don't copy Playwright source files in Dockerfiles - install via pip only

### When Debugging

1. **Check logs** - Each service has its own log stream
   ```powershell
   # Docker logs
   docker logs dropship-[service-name] -f
   
   # Railway logs
   railway logs --service <service-name>
   ```

2. **Verify environment** - Missing env vars cause most issues
   ```powershell
   # Check container env vars
   docker inspect dropship-[service-name] --format='{{range .Config.Env}}{{println .}}{{end}}'
   ```

3. **Test database connectivity** - Services depend on PostgreSQL/MySQL
   ```powershell
   # Test PostgreSQL
   docker exec dropship-postgres psql -U postgres -c "\l"
   
   # Test MySQL
   docker exec dropship-mysql mysql -ubagisto -pbagisto_password -e "SHOW DATABASES;"
   ```

4. **Check service health** - Use health check endpoints
   ```powershell
   # Test service endpoints
   Invoke-WebRequest -Uri "http://localhost:8082" -UseBasicParsing
   Invoke-WebRequest -Uri "http://localhost:3021/api/health" -UseBasicParsing
   ```

5. **Review recent changes** - Git history shows what changed
6. **Check Docker network** - Services must be on same network
   ```powershell
   docker network inspect dropship-empire_dropship-network
   ```

7. **Clear application caches** - Especially for Laravel/PHP
   ```powershell
   docker exec dropship-store php artisan cache:clear
   docker exec dropship-store php artisan config:clear
   docker exec dropship-store php artisan view:clear
   ```

## Version Information

### Application Runtime
- **Node.js**: v18 (marketing-suite)
- **PHP**: 8.3 (store-platform)
- **Python**: 3.11 (video-factory, research-bot)

### Databases & Infrastructure
- **PostgreSQL**: 16-alpine (Docker) / Latest (Railway)
- **MySQL**: 8.0.36 (Docker) / Latest (Railway)
- **Redis**: Alpine (Docker) / Latest (Railway)
- **Nginx**: 1.23.4-alpine (marketing UI)
- **Apache**: 2.4.65 (store platform)

## Maintenance Tasks

### Regular Updates

**Daily** (Development):
- Check Docker container status
- Monitor logs for errors
- Test critical workflows
- Verify service health endpoints

**Weekly**:
- Review deployment logs for errors
- Check database performance metrics
- Monitor service health endpoints
- Clear old Docker images/containers
- Update documentation for changes

**Monthly**:
- Update dependencies (npm, composer, pip)
- Review and rotate API keys
- Check for security advisories
- Backup databases
- Test restore procedures

**Quarterly**:
- Review and optimize database queries
- Audit user permissions and access
- Test disaster recovery procedures
- Update deployment documentation
- Performance tuning and optimization

### Dependency Updates

**Node.js**:
```bash
# Check outdated packages
npm outdated

# Update dependencies
npm update

# Major version updates
npx npm-check-updates -u
npm install

# Rebuild containers after updates
docker-compose -f docker-compose.monorepo.yml build marketing-api marketing-ui
```

**PHP**:
```bash
# Check outdated packages
composer outdated

# Update dependencies
composer update

# Rebuild container
docker-compose -f docker-compose.monorepo.yml build store-platform
```

**Python**:
```bash
# Check outdated packages
pip list --outdated

# Update requirements
pip install --upgrade -r requirements.txt
pip freeze > requirements.txt

# Rebuild containers
docker-compose -f docker-compose.monorepo.yml build video-factory-api video-factory-webui research-bot
```

### Docker Maintenance

```powershell
# Remove unused images
docker image prune -a

# Remove unused volumes
docker volume prune

# Remove unused containers
docker container prune

# Full cleanup
docker system prune -a --volumes

# Check disk usage
docker system df
```

## Project Status

### Deployment Status (Updated: December 15, 2025)

- ✅ All services configured for Railway deployment
- ✅ Local Docker deployment fully operational (82% success rate)
- ✅ GitHub Actions CI/CD pipeline configured
- ✅ Comprehensive documentation in `docs/` directory
- ✅ Environment variable templates provided
- ✅ Docker configurations tested and deployed
- ✅ 9/11 services running successfully in Docker
- ✅ Video Factory (API + UI) - Fully operational
- ✅ Marketing Suite API - Fully operational (port 3021)
- ✅ n8n Workflow Engine - Ready for configuration
- ⚠️ Store Platform - Deployed, needs cache/config fix
- ⚠️ Marketing UI - Built, has script execution issue (API works)
- ⏳ Awaiting GitHub repository connection to Railway

## Quick Reference Commands

### Local Docker Deployment (Recommended for Development)

```powershell
# Check all running services
docker ps --filter "name=dropship-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Start all services
docker-compose -f docker-compose.monorepo.yml up -d

# Stop all services
docker-compose -f docker-compose.monorepo.yml down

# Restart a specific service
docker-compose -f docker-compose.monorepo.yml restart [service-name]

# View logs
docker logs dropship-[service-name] -f

# Rebuild service
docker-compose -f docker-compose.monorepo.yml build [service-name]
docker-compose -f docker-compose.monorepo.yml up -d [service-name]

# Quick status check
.\check-deployment-status.ps1
```

### Individual Service Setup

```bash
# Clone repository
git clone <repository-url>
cd dropshipping-platform

# Setup marketing-suite
cd marketing-suite && npm install && lerna run build

# Setup store-platform
cd store-platform && composer install && cp .env.example .env
php artisan migrate:fresh --seed

# Setup video-factory
cd video-factory && pip install -r requirements.txt

# Setup research-bot
cd research-bot && pip install -r requirements.txt && playwright install
```

### Railway Deployment

```bash
# Check Railway deployment status
railway status

# View logs for a specific service
railway logs --service <service-name>

# Push to trigger deployment
git push origin main
```

### Access Running Services

```
Video Factory UI:    http://localhost:8502
Video Factory API:   http://localhost:8082
n8n Workflow:        http://localhost:5679 (admin/admin123)
Marketing API:       http://localhost:3021
Store Platform:      http://localhost:8083
PostgreSQL:          localhost:5432
MySQL:               localhost:3307
Redis:               localhost:6380
```

## Known Issues & Solutions

### Store Platform 500 Error
**Issue:** Laravel returns "Table 'bagisto.locales' doesn't exist" despite table existing  
**Cause:** Cache/configuration issue after migrations  
**Solution:**
```powershell
# Clear all caches
docker exec dropship-store php artisan cache:clear
docker exec dropship-store php artisan config:clear
docker exec dropship-store php artisan view:clear

# Restart container
docker-compose -f docker-compose.monorepo.yml restart store-platform

# Alternative: Use auto-setup script
docker exec dropship-store php auto_setup.php
```

### Marketing UI Script Error
**Issue:** Container exits with "env.sh: cannot execute: required file not found"  
**Cause:** Windows line endings (CRLF) in shell script  
**Solution:** Use Marketing API directly at port 3021 (fully functional)  
**Alternative:** Fix line endings and rebuild:
```powershell
# Convert to Unix line endings
$content = Get-Content -Path "marketing-suite/apps/ui/scripts/env.sh" -Raw
$content = $content -replace "`r`n", "`n"
[System.IO.File]::WriteAllText("marketing-suite/apps/ui/scripts/env.sh", $content)

# Rebuild
docker-compose -f docker-compose.monorepo.yml build marketing-ui
```

### Research Bot Module Import Error
**Issue:** `ModuleNotFoundError: No module named 'playwright._repo_version'`  
**Cause:** Playwright source files copied into container conflict with pip install  
**Solution:** Use official Playwright Docker base image (already implemented)  
**Alternative:** Don't COPY playwright directory in Dockerfile

### Marketing API Connection Timeout
**Issue:** New marketing-api container can't connect to postgres  
**Cause:** Database not ready or wrong host name  
**Solution:** Use existing marketing-suite at port 3021 (already working)

## Additional Resources

### Troubleshooting Reports
- `FINAL_STATUS_REPORT.md` - Current deployment status
- `TROUBLESHOOTING_SUMMARY.md` - Detailed issue tracking
- `COMPLETE_DEPLOYMENT_REPORT.md` - Full deployment documentation

### Quick Reference
- `check-deployment-status.ps1` - Status checking script
- `deploy-monorepo.ps1` - Automated deployment
- `docker-compose.monorepo.yml` - Service orchestration
