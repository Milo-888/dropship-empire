# 🔄 n8n Workflow Setup Guide

Complete guide for setting up and configuring n8n workflows for the Dropshipping Automation Platform.

## 📥 Importing the Workflow

1. **Access n8n Dashboard**
   - URL: `https://your-n8n-domain.railway.app`
   - Login with credentials from environment variables

2. **Import Workflow File**
   - Click **Workflows** in sidebar
   - Click **Import from File**
   - Select `n8n_workflow_dropshipping_pipeline.json`
   - Click **Import**

## 🔧 Workflow Configuration

### 1. Configure API Credentials

#### Video Factory Credentials
- **Type**: Header Auth
- **Name**: `video-factory-api`
- **Header Name**: `Authorization`
- **Header Value**: `Bearer YOUR_API_KEY`

#### Store Platform Credentials
- **Type**: Header Auth or Basic Auth
- **Name**: `store-platform-api`
- Configure based on Bagisto API authentication

#### Marketing Suite Credentials
- **Type**: Header Auth
- **Name**: `marketing-suite-api`
- **Header Name**: `Authorization`
- **Header Value**: `Bearer YOUR_JWT_TOKEN`

### 2. Update Service URLs

Find and replace all service URLs in the workflow:

```
video-factory: https://your-video-factory.railway.app
store-platform: https://your-store-platform.railway.app
marketing-suite: https://your-marketing-suite.railway.app
```

### 3. Configure Webhooks

Each workflow trigger needs a webhook URL:

1. Click on **Webhook** node
2. Copy the **Production URL**
3. Add webhook URL to the triggering service

## 📊 Available Workflows

### 1. Product Launch Pipeline

**Trigger**: New product added to store

**Steps**:
1. Product created webhook → n8n
2. Extract product details
3. Research competitors (research-bot)
4. Generate product video (video-factory)
5. Create email campaign (marketing-suite)
6. Send campaign to subscribers

**Configuration**:
- Webhook URL: Add to store-platform product creation event
- Research Bot: Configure target competitors
- Video Factory: Set video template
- Marketing Suite: Select subscriber segment

### 2. Order Fulfillment

**Trigger**: New order received

**Steps**:
1. Order webhook → n8n
2. Send order confirmation email
3. Create fulfillment task
4. Track shipment status
5. Send delivery notification

**Configuration**:
- Webhook URL: Add to store-platform order event
- Email templates: Customize in marketing-suite
- Tracking API: Configure shipping provider

### 3. Content Generation

**Trigger**: Scheduled (daily)

**Steps**:
1. Cron schedule triggers
2. Research trending products
3. Generate video content
4. Post to social media
5. Send analytics report

**Configuration**:
- Schedule: Set time in Cron node
- Research keywords: Define in research-bot node
- Social media: Add API credentials

## 🔌 Service Integrations

### Connecting to Video Factory

```json
{
  "method": "POST",
  "url": "https://video-factory.railway.app/api/v1/video/generate",
  "headers": {
    "Authorization": "Bearer {{$credentials.videoFactory.token}}"
  },
  "body": {
    "prompt": "{{$node['Get Product'].json['description']}}",
    "duration": 30,
    "voice": "alloy"
  }
}
```

### Connecting to Store Platform

```json
{
  "method": "GET",
  "url": "https://store-platform.railway.app/api/products",
  "headers": {
    "Authorization": "Bearer {{$credentials.storePlatform.token}}"
  }
}
```

### Connecting to Marketing Suite

```json
{
  "method": "POST",
  "url": "https://marketing-suite.railway.app/api/campaigns",
  "headers": {
    "Authorization": "Bearer {{$credentials.marketingSuite.token}}"
  },
  "body": {
    "name": "{{$node['Product Details'].json['name']}} Launch",
    "subject": "New Product: {{$node['Product Details'].json['name']}}",
    "template": "product-launch",
    "segmentId": "all-subscribers"
  }
}
```

## 🧪 Testing Workflows

### 1. Manual Execution

1. Open workflow
2. Click **Execute Workflow**
3. Watch nodes execute
4. Check output in each node

### 2. Webhook Testing

```bash
# Test product webhook
curl -X POST https://your-n8n.railway.app/webhook/product-launch \
  -H "Content-Type: application/json" \
  -d '{
    "product_id": 123,
    "name": "Test Product",
    "description": "Test description"
  }'
```

### 3. Check Execution History

1. Click **Executions** in sidebar
2. View success/failure status
3. Click execution to see details
4. Debug failed nodes

## 🔔 Error Handling

### Retry Logic

Configure in each node:
- **Continue on Fail**: Enable for non-critical steps
- **Retry on Fail**: Enable with 3 attempts
- **Wait Between Tries**: 1000ms

### Error Notifications

Add **Slack** or **Email** node after critical steps:

```
IF Error → Send Notification
  Subject: Workflow Failed
  Body: {{$node['Failed Node'].error.message}}
```

## 📈 Monitoring

### Execution Metrics

View in n8n dashboard:
- Total executions
- Success rate
- Average execution time
- Failed executions

### Custom Logging

Add **Set** node to log data:

```json
{
  "timestamp": "{{$now}}",
  "workflow": "product-launch",
  "product_id": "{{$json['product_id']}}",
  "status": "success"
}
```

## 🔐 Security Best Practices

1. **Use Credentials Manager**
   - Never hardcode API keys
   - Store in n8n credentials

2. **Webhook Security**
   - Enable webhook authentication
   - Use unique URLs
   - Validate incoming data

3. **Access Control**
   - Enable basic auth
   - Use strong passwords
   - Limit network access

## 🚀 Advanced Features

### 1. Sub-workflows

Break complex workflows into reusable pieces:
- Create sub-workflow
- Call from main workflow using **Execute Workflow** node

### 2. Variables

Define workflow variables:
- **Static Data**: Configuration values
- **Expressions**: Dynamic calculations
- **Credentials**: API keys and secrets

### 3. Conditional Logic

Use **IF** node for branching:

```
IF product.price > 100
  → Send premium campaign
ELSE
  → Send regular campaign
```

## 📝 Workflow Examples

### Example 1: Price Alert

```
1. Cron Trigger (daily)
2. Research Bot: Scrape competitor prices
3. Compare with our prices
4. IF competitor < our_price - 10%
   → Alert admin via email
```

### Example 2: Abandoned Cart

```
1. Store Webhook: Cart created
2. Wait 24 hours
3. Check if order completed
4. IF not completed
   → Send reminder email
```

## 🆘 Troubleshooting

### Workflow Not Triggering

1. Check webhook URL is correct
2. Verify webhook is active in source service
3. Test webhook manually with curl
4. Check n8n logs

### Node Execution Fails

1. Check node configuration
2. Verify API credentials
3. Test API endpoint manually
4. Check service is running

### Performance Issues

1. Reduce concurrent executions
2. Add wait time between API calls
3. Cache frequently accessed data
4. Use webhook triggers instead of polling

## 📚 Resources

- [n8n Documentation](https://docs.n8n.io/)
- [n8n Community Forum](https://community.n8n.io/)
- [Workflow Templates](https://n8n.io/workflows/)

---

**Last Updated**: 2024
