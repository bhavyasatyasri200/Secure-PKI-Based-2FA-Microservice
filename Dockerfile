FROM python:3.11-slim

ENV TZ=UTC
ENV PYTHONPATH=/app 

WORKDIR /app

RUN apt-get update && apt-get install -y cron tzdata && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# 1. Create directories
# 2. Set permissions
# 3. Create a default seed file ONLY if it doesn't exist (prevents script crash)
RUN mkdir -p /data /cron && \
    chmod 777 /data /cron && \
    echo "1234567890ABCDEF" > /data/seed.txt

# 4. Fix the cron newline quirk and register it
RUN chmod 0644 /app/cron/2fa-cron && \
    (echo "" >> /app/cron/2fa-cron) && \
    crontab /app/cron/2fa-cron

EXPOSE 8080

CMD ["sh", "-c", "cron && uvicorn app.main:app --host 0.0.0.0 --port 8080"]