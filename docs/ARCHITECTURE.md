# 🏗️ System Architecture

## Overview

The Dropshipping Automation Platform is a microservices-based system designed for scalability, maintainability, and ease of deployment.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                         External Services                            │
├─────────────────────────────────────────────────────────────────────┤
│  OpenAI API  │  Pexels API  │  Payment Gateways  │  Email Providers │
└──────┬───────┴──────┬───────┴──────┬─────────────┴──────┬───────────┘
       │              │               │                     │
┌──────▼──────────────▼───────────────▼─────────────────────▼─────────┐
│                        API Gateway / n8n                             │
│                     (Workflow Orchestration)                         │
└──────┬──────────────┬───────────────┬─────────────────┬─────────────┘
       │              │               │                 │
┌──────▼──────┐ ┌────▼─────┐ ┌───────▼──────┐ ┌───────▼────────┐
│ video-factory│ │  store-  │ │  marketing-  │ │  research-bot  │
│   Service    │ │ platform │ │    suite     │ │    Service     │
│   (Python)   │ │  (PHP)   │ │  (Node.js)   │ │   (Python)     │
└──────┬───────┘ └────┬─────┘ └───────┬──────┘ └────────┬───────┘
       │              │               │                  │
       └──────────────┴───────────────┴──────────────────┘
                             │
       ┌─────────────────────┴─────────────────────┐
       │                                            │
┌──────▼──────┐                          ┌─────────▼──────┐
│  PostgreSQL │                          │     Redis      │
│   Database  │                          │     Cache      │
└─────────────┘                          └────────────────┘
```

## Services

### 1. Video Factory Service

**Technology**: Python (FastAPI)

**Purpose**: AI-powered video content generation for marketing campaigns

**Key Components**:
- `app/services/llm.py` - LLM integration for script generation
- `app/services/video.py` - Video composition and rendering
- `app/services/voice.py` - Text-to-speech synthesis
- `app/services/subtitle.py` - Subtitle generation and overlays

**Dependencies**:
- OpenAI API (for GPT models)
- Pexels API (for stock footage)
- FFmpeg (for video processing)
- ImageMagick (for image manipulation)

**Data Flow**:
1. Receives video generation request (text prompt)
2. LLM generates video script and scene descriptions
3. Fetches relevant stock footage from Pexels
4. Generates voiceover using TTS
5. Composites video with subtitles and background music
6. Returns downloadable video URL

**Exposed APIs**:
- `POST /api/v1/video/generate` - Generate video from text
- `GET /api/v1/video/status/{task_id}` - Check generation status
- `GET /api/v1/video/download/{task_id}` - Download generated video

### 2. Store Platform

**Technology**: PHP (Laravel/Bagisto)

**Purpose**: Full-featured e-commerce platform for product catalog and orders

**Key Components**:
- Multi-vendor marketplace support
- Product catalog management
- Order processing
- Customer management
- Payment gateway integration
- Inventory management

**Dependencies**:
- PostgreSQL (product data, orders, customers)
- Redis (session storage, cache)
- File storage (product images)

**Data Flow**:
1. Customer browses products
2. Adds items to cart
3. Proceeds to checkout
4. Payment processed through gateway
5. Order confirmation sent via email
6. n8n webhook triggers fulfillment workflow

**Exposed APIs**:
- REST API for product management
- GraphQL API for storefront
- Admin API for order processing

### 3. Marketing Suite

**Technology**: Node.js (TypeScript)

**Purpose**: Email marketing automation and campaign management

**Key Components**:
- `apps/platform/src/services/campaign` - Campaign orchestration
- `apps/platform/src/services/email` - Email provider abstraction
- `apps/platform/src/services/analytics` - Campaign analytics
- `apps/platform/src/services/template` - Email template engine

**Dependencies**:
- PostgreSQL (campaign data, subscriber lists)
- Redis (rate limiting, queue management)
- Email providers (SendGrid, Mailgun, AWS SES)

**Data Flow**:
1. Create email campaign in admin panel
2. Define target audience and schedule
3. Generate personalized emails from templates
4. Queue emails for delivery
5. Track opens, clicks, and conversions
6. Report analytics to dashboard

**Exposed APIs**:
- `POST /api/campaigns` - Create campaign
- `POST /api/campaigns/{id}/send` - Send campaign
- `GET /api/campaigns/{id}/analytics` - Get campaign stats

### 4. Research Bot

**Technology**: Python (Playwright)

**Purpose**: Automated web scraping and product research

**Key Components**:
- `scraper.py` - Main scraping orchestrator
- `playwright/` - Browser automation library
- Headless browser engine

**Data Flow**:
1. Receives scraping task (target URL, data to extract)
2. Launches headless browser
3. Navigates to target site
4. Extracts data using selectors
5. Processes and cleans data
6. Returns structured JSON

**Use Cases**:
- Competitor price monitoring
- Product review extraction
- Trend analysis
- Stock availability checking

### 5. n8n Workflow Engine

**Technology**: Node.js

**Purpose**: Orchestrate all services and automate business workflows

**Key Workflows**:

1. **Product Launch Pipeline**:
   - New product added to store → trigger
   - Research Bot scrapes competitor prices
   - Video Factory generates product video
   - Marketing Suite creates email campaign
   - Campaign sent to subscriber list

2. **Order Fulfillment**:
   - New order received → trigger
   - Send confirmation email
   - Notify fulfillment center
   - Track shipment status
   - Send delivery notification

3. **Content Generation**:
   - Schedule daily content creation
   - Research Bot finds trending products
   - Video Factory creates promotional videos
   - Post to social media channels

**Integration Points**:
- Webhooks from all services
- HTTP requests to service APIs
- Database queries
- Email notifications
- File storage operations

## Data Storage

### PostgreSQL Database

**Schema Organization**:
```
┌─────────────────┐
│   store_db      │  - Products, orders, customers
├─────────────────┤
│  marketing_db   │  - Campaigns, subscribers, analytics
├─────────────────┤
│    n8n_db       │  - Workflow definitions, execution logs
└─────────────────┘
```

**Key Tables**:
- `products` - Product catalog
- `orders` - Order history
- `customers` - Customer information
- `campaigns` - Email campaigns
- `subscribers` - Email subscriber lists
- `video_tasks` - Video generation tasks
- `scrape_jobs` - Scraping job queue

### Redis Cache

**Usage**:
- Session storage (store-platform)
- Rate limiting (marketing-suite)
- Job queues (video-factory)
- Cache layer (all services)

## Communication Patterns

### 1. Synchronous (HTTP/REST)
- Direct service-to-service calls
- Used for: immediate responses, simple queries

### 2. Asynchronous (Webhooks)
- Service emits webhook on event
- n8n receives and processes
- Used for: long-running tasks, event-driven workflows

### 3. Queue-based (Redis)
- Service pushes job to queue
- Worker processes from queue
- Used for: video generation, email sending

## Security Architecture

### Authentication
- JWT tokens for API authentication
- OAuth2 for admin panel
- API keys for service-to-service auth

### Authorization
- Role-based access control (RBAC)
- Scope-based permissions for APIs

### Data Protection
- Encryption at rest (database)
- TLS/SSL for data in transit
- Environment variables for secrets
- No secrets in code or logs

### Network Security
- Railway's internal networking
- Service-to-service communication over private network
- Public endpoints only for user-facing services

## Scalability Considerations

### Horizontal Scaling
- All services are stateless
- Can add multiple instances
- Load balancing via Railway

### Vertical Scaling
- Increase memory/CPU per service
- Configure via Railway dashboard

### Caching Strategy
- Redis for frequently accessed data
- CDN for static assets (images, videos)
- Database query caching

### Queue Management
- Async processing for heavy tasks
- Rate limiting to prevent overload
- Dead letter queues for failed jobs

## Monitoring & Observability

### Logging
- Structured JSON logs
- Centralized via Railway
- Log levels: ERROR, WARN, INFO, DEBUG

### Metrics
- Request count and latency
- Error rates
- Resource usage (CPU, memory, disk)

### Alerts
- Service health checks
- Error rate thresholds
- Resource utilization warnings

## Deployment Architecture

### Railway Platform
```
┌─────────────────────────────────────────┐
│         Railway Project                 │
├─────────────────────────────────────────┤
│  Service 1: video-factory               │
│  Service 2: store-platform              │
│  Service 3: marketing-suite             │
│  Service 4: research-bot                │
│  Service 5: n8n                         │
│  Service 6: PostgreSQL                  │
│  Service 7: Redis                       │
└─────────────────────────────────────────┘
```

### Environment Separation
- Production: `main` branch
- Staging: `staging` branch
- Development: Local Docker Compose

## Future Enhancements

1. **Message Queue (RabbitMQ/Kafka)**
   - Replace webhook-based communication
   - Better reliability and retry logic

2. **Service Mesh (Istio)**
   - Advanced traffic management
   - Circuit breaking
   - Distributed tracing

3. **GraphQL Federation**
   - Unified API gateway
   - Schema stitching across services

4. **Event Sourcing**
   - Audit trail for all operations
   - Time-travel debugging
   - Better analytics

5. **Kubernetes Migration**
   - More control over orchestration
   - Auto-scaling based on metrics
   - Multi-cloud deployment

---

**Architecture Version**: 1.0
**Last Updated**: 2024
**Maintained By**: Development Team
