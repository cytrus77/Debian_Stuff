FROM python:3.11-slim

# Install dependencies and Ookla Speedtest CLI direct binary
RUN apt-get update && apt-get install -y curl ca-certificates tar && \
    curl -sL "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-x86_64.tgz" | tar -xz -C /usr/local/bin && \
    chmod +x /usr/local/bin/speedtest && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY speedtest_mqtt.py .

# Run once per hour using a loop
CMD ["sh", "-c", "while true; do python speedtest_mqtt.py; sleep 3600; done"]
