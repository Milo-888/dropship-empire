# GitHub Repository Setup Guide

## Quick Setup Steps

### 1. Initialize Git Repository

```bash
git init
git add .
git commit -m "Initial commit - Dropshipping Automation Platform"
```

### 2. Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `dropshipping-platform` (or your choice)
3. Choose public or private
4. **DO NOT** initialize with README, .gitignore, or license (we already have these)
5. Click "Create repository"

### 3. Push to GitHub

Replace `YOUR_USERNAME` and `YOUR_REPO` with your GitHub username and repository name:

```bash
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git branch -M main
git push -u origin main
```

### 4. Set Up GitHub Actions (Optional - for CI/CD)

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `RAILWAY_TOKEN`
5. Value: Get from https://railway.app/account/tokens
6. Click **Add secret**

This enables automatic deployment to Railway when you push to main branch.

### 5. Connect Railway to GitHub

For each service in Railway Dashboard:

1. Open your Railway project: https://railway.com/project/a1db547e-c8ea-4977-84d8-cf28eb9b93be
2. Click on a service (e.g., video-factory)
3. Click **Settings** tab
4. Scroll to **Source** section
5. Click **Connect Repo**
6. Select your GitHub repository
7. Set **Root Directory** to the service folder:
   - `video-factory`
   - `store-platform`
   - `marketing-suite/apps/platform`
   - `research-bot`
8. Railway will auto-deploy on each push to main

## What's Included

This repository contains:

- ✅ `.gitignore` - Excludes temporary files, secrets, and build artifacts
- ✅ `README.md` - Project overview and quick start
- ✅ `LICENSE` - MIT License
- ✅ `docs/` - Comprehensive documentation
  - `DEPLOYMENT.md` - Railway deployment guide
  - `ARCHITECTURE.md` - System architecture
  - `ENVIRONMENT_VARIABLES.md` - Configuration reference
  - `N8N_SETUP.md` - Workflow automation setup
- ✅ `.github/workflows/deploy-railway.yml` - CI/CD pipeline
- ✅ All service code (video-factory, store-platform, marketing-suite, research-bot)
- ✅ n8n workflow configuration

## Repository Statistics

Run these commands after initial commit:

```bash
# Count files
git ls-files | wc -l

# View commit history
git log --oneline

# Check repository size
git count-objects -vH
```

## Next Steps After GitHub Setup

1. **Test the deployment**
   - Push a small change to trigger CI/CD
   - Monitor Railway Dashboard for deployment status

2. **Configure environment variables**
   - See `docs/ENVIRONMENT_VARIABLES.md`
   - Set in Railway Dashboard for each service

3. **Set up custom domains** (optional)
   - Configure in Railway service settings
   - Add CNAME records to your DNS

4. **Import n8n workflow**
   - Access your n8n instance
   - Import `n8n_workflow_dropshipping_pipeline.json`
   - Configure service URLs and credentials

## Troubleshooting

### "Permission denied" when pushing

If you get a permission error:

```bash
# Use GitHub CLI (if installed)
gh auth login

# Or use SSH instead of HTTPS
git remote set-url origin git@github.com:YOUR_USERNAME/YOUR_REPO.git
```

### Large repository warning

If GitHub warns about repository size:

```bash
# Check which files are large
git ls-files | xargs ls -lh | sort -k5 -h -r | head -20

# Remove large files if needed (videos, models, etc.)
# Add them to .gitignore
```

### Merge conflicts

If you accidentally initialized the GitHub repo with files:

```bash
git pull origin main --allow-unrelated-histories
# Resolve any conflicts
git push origin main
```

## Support

- **Documentation**: Check the `docs/` folder
- **Railway Dashboard**: https://railway.com/project/a1db547e-c8ea-4977-84d8-cf28eb9b93be
- **GitHub Issues**: Open an issue in your repository

---

**Ready to deploy!** Once pushed to GitHub, your platform will be live on Railway within minutes.
