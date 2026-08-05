FROM python:3.11-slim

# Install dependencies and Ookla Speedtest CLI
RUN apt-get update && apt-get install -y curl ca-certificates && \
    curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | bash && \
    apt-get install -y speedtest && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY speedtest_mqtt.py .

# Run once per hour using a loop or container scheduler
CMD ["sh", "-c", "while true; do python speedtest_mqtt.py; sleep 3600; done"]
