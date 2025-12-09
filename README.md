# 🚀 Dropshipping Automation Platform

A comprehensive multi-service platform for dropshipping automation, combining AI-powered video generation, product research, e-commerce management, and workflow automation.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Services](#services)
- [Quick Start](#quick-start)
- [Railway Deployment](#railway-deployment)
- [Documentation](#documentation)
- [License](#license)

## 🎯 Overview

This platform integrates multiple specialized services to create a complete dropshipping automation solution:

- **Video Factory**: AI-powered video content generation for marketing
- **Store Platform**: Full-featured e-commerce platform (Bagisto-based)
- **Marketing Suite**: Email marketing and campaign management
- **Research Bot**: Automated product research and web scraping
- **n8n**: Workflow automation connecting all services

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Railway Platform                         │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ video-factory│  │store-platform│  │marketing-suite│      │
│  │   (Python)   │  │    (PHP)     │  │  (Node.js)   │      │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘      │
│         │                  │                  │              │
│         │                  │                  │              │
│  ┌──────▼──────────────────▼──────────────────▼───────┐    │
│  │              n8n Workflow Engine                     │    │
│  │           (Connects all services)                    │    │
│  └──────────────────────────────────────────────────────┘   │
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  PostgreSQL  │  │    Redis     │  │ research-bot │      │
│  │   Database   │  │    Cache     │  │  (Playwright)│      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

## 🛠️ Services

### 1. Video Factory
- **Technology**: Python (FastAPI)
- **Purpose**: AI-powered video content generation
- **Features**: 
  - Text-to-video generation
  - Subtitle generation
  - Voice synthesis
  - Background music integration
- **Port**: 8080

### 2. Store Platform
- **Technology**: PHP (Laravel/Bagisto)
- **Purpose**: E-commerce store management
- **Features**:
  - Product catalog
  - Order management
  - Customer management
  - Payment integration
- **Port**: 8000

### 3. Marketing Suite
- **Technology**: Node.js (TypeScript)
- **Purpose**: Email marketing automation
- **Features**:
  - Campaign management
  - Email templates
  - Analytics
  - Multi-provider support
- **Port**: 3000

### 4. Research Bot
- **Technology**: Python (Playwright)
- **Purpose**: Automated product research
- **Features**:
  - Web scraping
  - Price monitoring
  - Competitor analysis
  - Review extraction

### 5. n8n Workflow Engine
- **Technology**: Node.js (Docker)
- **Purpose**: Connect and automate all services
- **Features**:
  - Visual workflow builder
  - API integrations
  - Scheduled tasks
  - Webhooks
- **Port**: 5678
- **Deployment**: Custom Dockerfile using official n8n image

## 🚀 Quick Start

### Prerequisites

- Git
- Docker & Docker Compose (for local development)
- Railway CLI (for deployment)

### Local Development

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd dropshipping-platform
   ```

2. **Set up environment variables**
   ```bash
   # Copy example env files
   cp video-factory/.env.example video-factory/.env
   cp store-platform/.env.example store-platform/.env
   cp marketing-suite/apps/platform/.env.example marketing-suite/apps/platform/.env
   ```

3. **Start services with Docker Compose**
   ```bash
   docker-compose up -d
   ```

4. **Access services**
   - Video Factory: http://localhost:8080
   - Store Platform: http://localhost:8000
   - Marketing Suite: http://localhost:3000
   - n8n: http://localhost:5678

## ☁️ Railway Deployment

### One-Click Setup

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template)

### Manual Deployment

1. **Install Railway CLI**
   ```bash
   npm i -g @railway/cli
   railway login
   ```

2. **Link to existing project**
   ```bash
   railway link a1db547e-c8ea-4977-84d8-cf28eb9b93be
   ```

3. **Deploy services**
   ```bash
   # Deploy video-factory
   cd video-factory
   railway up

   # Deploy store-platform
   cd ../store-platform
   railway up

   # Deploy marketing-suite
   cd ../marketing-suite
   railway up
   ```

4. **Configure n8n**
   - Go to Railway Dashboard
   - Click "+ New"
   - Search for "n8n" template
   - Deploy with one click

### Environment Variables

See [docs/ENVIRONMENT_VARIABLES.md](docs/ENVIRONMENT_VARIABLES.md) for a complete list of required environment variables.

### Database Setup

After deployment, run migrations:

```bash
# Store Platform
railway run php artisan migrate --seed

# Marketing Suite
railway run npm run db:migrate
```

## 📚 Documentation

- [Deployment Guide](docs/DEPLOYMENT.md) - Detailed Railway deployment instructions
- [Architecture](docs/ARCHITECTURE.md) - System architecture and design decisions
- [Environment Variables](docs/ENVIRONMENT_VARIABLES.md) - Complete environment configuration guide
- [n8n Workflow Setup](docs/N8N_SETUP.md) - How to configure the workflow automation

## 💰 Cost Estimate

**Railway Hosting (Monthly)**:
- PostgreSQL: ~$5
- Redis: ~$1
- video-factory: ~$5
- store-platform: ~$10
- marketing-suite: ~$10
- n8n: ~$5
- research-bot: ~$3

**Total**: ~$39/month

> Note: Costs may vary based on usage. Railway offers $5 free credit monthly.

## 🔐 Security

- Never commit `.env` files
- Use Railway's environment variable management
- Keep dependencies updated
- Review the security guidelines in each service's documentation

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project contains multiple services with different licenses:
- Video Factory: See `video-factory/LICENSE`
- Store Platform: See `store-platform/LICENSE`
- Marketing Suite: See `marketing-suite/LICENSE.txt`
- Research Bot: See `research-bot/LICENSE`

## 🆘 Support

- **Issues**: Open an issue on GitHub
- **Discussions**: Use GitHub Discussions for questions
- **Documentation**: Check the `docs/` folder

## 🎉 Acknowledgments

- [Bagisto](https://bagisto.com/) - E-commerce platform
- [n8n](https://n8n.io/) - Workflow automation
- [Playwright](https://playwright.dev/) - Browser automation
- [Railway](https://railway.app/) - Deployment platform

---

**Status**: 🟢 Production Ready | **Version**: 1.0.0 | **Last Updated**: 2024
