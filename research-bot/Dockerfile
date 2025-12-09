FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir playwright google-generativeai

# Install Playwright browsers
RUN playwright install --with-deps chromium

# Set working directory
WORKDIR /app

# Copy scraper script
COPY scraper.py .

# Environment variables will be passed at runtime
ENV PYTHONUNBUFFERED=1

# Run the scraper
CMD ["python", "scraper.py"]
