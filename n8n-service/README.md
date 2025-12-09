# n8n Service for Railway

This service deploys n8n workflow automation to Railway.

## Quick Deploy

1. **Push to GitHub** (if not already done)
   ```bash
   git add n8n-service/
   git commit -m "Add n8n service"
   git push
   ```

2. **Create n8n Service in Railway**
   - Go to Railway Dashboard: https://railway.com/project/a1db547e-c8ea-4977-84d8-cf28eb9b93be
   - Click **+ New**
   - Select **Empty Service**
   - Name it: `n8n`

3. **Connect GitHub Repository**
   - Click **Settings** tab
   - Scroll to **Source** section
   - Click **Connect Repo**
   - Select your GitHub repository
   - Set **Root Directory**: `n8n-service`
   - Railway will auto-detect the Dockerfile

4. **Set Environment Variables**
   
   Click **Variables** tab and add:

   ```bash
   # Host Configuration
   N8N_HOST=${{RAILWAY_PUBLIC_DOMAIN}}
   N8N_PROTOCOL=https
   N8N_PORT=5678
   
   # Database (Reference existing PostgreSQL)
   DB_TYPE=postgresdb
   DB_POSTGRESDB_HOST=${{Postgres.PGHOST}}
   DB_POSTGRESDB_PORT=${{Postgres.PGPORT}}
   DB_POSTGRESDB_DATABASE=${{Postgres.PGDATABASE}}
   DB_POSTGRESDB_USER=${{Postgres.PGUSER}}
   DB_POSTGRESDB_PASSWORD=${{Postgres.PGPASSWORD}}
   
   # Authentication
   N8N_BASIC_AUTH_ACTIVE=true
   N8N_BASIC_AUTH_USER=admin
   N8N_BASIC_AUTH_PASSWORD=your-secure-password-here
   
   # Timezone
   GENERIC_TIMEZONE=America/New_York
   
   # Webhook
   WEBHOOK_URL=https://${{RAILWAY_PUBLIC_DOMAIN}}
   ```

5. **Deploy**
   - Railway will automatically build and deploy
   - Check logs for any errors
   - Access n8n at the Railway-generated URL

## Import Workflow

After deployment:

1. Access your n8n instance (check Railway for URL)
2. Login with credentials from environment variables
3. Click **Workflows** → **Import from File**
4. Select `../n8n_workflow_dropshipping_pipeline.json`
5. Update service URLs in the workflow to match your Railway domains

## Alternative: Use n8n Official Template

If you prefer not to maintain a custom Dockerfile:

1. In Railway Dashboard, click **+ New**
2. Search for "n8n" in templates
3. Deploy the official n8n template
4. Configure environment variables as shown above
5. Link to your existing PostgreSQL database

## Environment Variables Reference

See `../docs/ENVIRONMENT_VARIABLES.md` for complete reference.

## Troubleshooting

### n8n won't start
- Check DATABASE_URL is correctly set
- Verify PostgreSQL service is running
- Check logs: `railway logs --service n8n`

### Can't access n8n UI
- Verify N8N_HOST matches Railway domain
- Check N8N_PROTOCOL is set to "https"
- Ensure basic auth credentials are correct

### Database connection errors
- Verify all DB_POSTGRESDB_* variables reference the correct Postgres service
- Use Railway's variable references: `${{Postgres.PGHOST}}`

## Updating n8n

To update to latest n8n version:

1. Rebuild the service in Railway Dashboard
2. Or push a commit to trigger redeploy
3. n8n will automatically use the latest `:latest` tag

## Custom Configuration

To add custom n8n configuration:

1. Create configuration files in this directory
2. Uncomment the COPY line in Dockerfile
3. Push changes to trigger redeploy
