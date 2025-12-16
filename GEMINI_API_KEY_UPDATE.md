# Gemini API Key Update

**Date:** December 15, 2025, 9:30 PM EST  
**New API Key:** AIzaSyDQ7BPJQ3RoSthiVht_4O-_EOs-O_PVHPE

---

## ✅ Services Updated

### 1. Video Factory API
**Container:** dropship-video-api  
**Port:** 8082  
**Configuration File:** `/MoneyPrinterTurbo/config.toml`  
**Status:** ✅ Updated and restarted  

**Usage:**
- LLM Provider set to "gemini"
- Model: gemini-1.0-pro
- Used for video script generation

### 2. Video Factory WebUI
**Container:** dropship-video-webui  
**Port:** 8502  
**Configuration File:** `/MoneyPrinterTurbo/config.toml`  
**Status:** ✅ Updated and restarted  

**Usage:**
- Streamlit interface for video generation
- Uses same config as API

### 3. Research Bot
**Container:** dropship-research-bot  
**Environment Variable:** GEMINI_API_KEY  
**Status:** ✅ Updated and restarted  

**Usage:**
- Sentiment analysis of product reviews
- Model: gemini-2.0-flash-exp
- Analyzes Amazon/BestBuy reviews

---

## 📋 Configuration Details

### Video Factory Config Location
```
Host: video-factory/config.toml
Container: /MoneyPrinterTurbo/config.toml
```

### Key Settings
```toml
[app]
llm_provider = "gemini"
gemini_api_key = "AIzaSyDQ7BPJQ3RoSthiVht_4O-_EOs-O_PVHPE"
gemini_model_name = "gemini-1.0-pro"
```

### Research Bot Environment
```yaml
environment:
  - GEMINI_API_KEY=AIzaSyDQ7BPJQ3RoSthiVht_4O-_EOs-O_PVHPE
```

---

## 🧪 Testing

### Test Video Factory
```bash
# Access WebUI
Open: http://localhost:8502

# Or test API directly
curl http://localhost:8082
```

**Expected Behavior:**
- Video generation should use Gemini for script creation
- AI-powered content generation
- Natural language processing for video scripts

### Test Research Bot
```bash
# Check environment variable
docker exec dropship-research-bot printenv GEMINI_API_KEY

# Run scraper (requires product URL)
docker exec dropship-research-bot python scraper.py
```

**Expected Behavior:**
- Sentiment analysis of product reviews
- AI-powered review summarization
- Winning product identification

---

## 🔄 How to Update API Key in Future

### Method 1: Update config.toml (Video Factory)
```bash
# Edit the config file
nano video-factory/config.toml

# Update the key
gemini_api_key = "YOUR_NEW_KEY"

# Copy to containers
docker cp video-factory/config.toml dropship-video-api:/MoneyPrinterTurbo/config.toml
docker cp video-factory/config.toml dropship-video-webui:/MoneyPrinterTurbo/config.toml

# Restart services
docker-compose -f docker-compose.monorepo.yml restart video-factory-api video-factory-webui
```

### Method 2: Update docker-compose.yml (Research Bot)
```bash
# Edit docker-compose.monorepo.yml
# Find research-bot section and update:
environment:
  - GEMINI_API_KEY=YOUR_NEW_KEY

# Restart service
docker-compose -f docker-compose.monorepo.yml up -d research-bot
```

---

## 📊 API Usage

### Gemini Models Available

**Video Factory Uses:**
- gemini-1.0-pro (configured)
- Alternative: gemini-1.5-pro, gemini-1.5-flash

**Research Bot Uses:**
- gemini-2.0-flash-exp (hardcoded in scraper.py)
- Fastest model for sentiment analysis

### Rate Limits
- Free tier: 60 requests per minute
- Paid tier: Higher limits based on plan
- Monitor usage at: https://aistudio.google.com/

---

## ⚠️ Important Notes

### Security
- ✅ API key is stored in docker-compose configuration
- ✅ Not committed to git (excluded via .gitignore)
- ⚠️ Key is visible in container environment variables
- 🔒 For production: Use secrets management (Docker secrets, Railway env vars)

### Key Rotation
When rotating keys:
1. Generate new key at https://aistudio.google.com/
2. Update both services (Video Factory + Research Bot)
3. Test both services before decommissioning old key
4. Revoke old key after confirming new one works

### Backup Configuration
Current key is also documented in:
- `video-factory/config.toml` (local file)
- `docker-compose.monorepo.yml` (research-bot environment)
- This documentation file

---

## 🎯 Verification Checklist

- [x] Video Factory API key updated
- [x] Video Factory WebUI key updated
- [x] Research Bot environment variable set
- [x] All services restarted
- [x] Config files backed up
- [ ] Test video generation with Gemini
- [ ] Test research bot sentiment analysis
- [ ] Monitor API usage/quotas

---

## 🚀 Next Steps

1. **Test Video Generation**
   ```
   Visit: http://localhost:8502
   Create a test video with Gemini-powered script
   ```

2. **Test Research Bot**
   ```
   Run product research with sentiment analysis
   Verify Gemini API calls are working
   ```

3. **Monitor Usage**
   ```
   Check Google AI Studio for API usage
   Set up billing alerts if needed
   ```

---

**Update Status:** ✅ Complete  
**Services Status:** All running with new API key  
**Ready for Testing:** Yes

---

*Document Created: December 15, 2025, 9:30 PM EST*
