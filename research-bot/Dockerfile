FROM mcr.microsoft.com/playwright/python:v1.40.0-jammy

WORKDIR /app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy only necessary files (not the playwright source directory)
COPY scraper.py .

# Set environment variable
ENV PYTHONUNBUFFERED=1

# Keep container running - scraper will be run on demand
CMD ["tail", "-f", "/dev/null"]
