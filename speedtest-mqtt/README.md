# Hourly Internet Speedtest to MQTT Publisher

This project measures internet download speed, upload speed, latency (ping), and jitter every hour and publishes the results to an **MQTT broker**. It includes built-in support for **Home Assistant MQTT Auto-Discovery**.

---

## 🚀 Why Official Ookla Speedtest CLI?

We use the **Official Ookla Speedtest CLI** (`speedtest`) instead of python `speedtest-cli` because:
1. **Accuracy on High-Speed Connections**: Supports Gigabit (1000+ Mbps) internet speeds without CPU bottlenecks.
2. **Native JSON Output**: Outputs structured data including latency jitter, ISP info, and server metadata via `speedtest --format=json`.
3. **Reliability**: Uses official Ookla speedtest servers and avoids rate-limiting / package manager distribution mismatches (e.g. Linux Mint / Debian derivative codenames).

---

## 🛠️ Installation & Setup

### 1. Install Ookla Speedtest CLI (Direct Binary Installation)

Download and extract the official Ookla binary directly to `/usr/local/bin`:

#### For x86_64 (Intel/AMD 64-bit):
```bash
curl -sL "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-x86_64.tgz" | tar -xz -C /tmp
sudo mv /tmp/speedtest /usr/local/bin/
sudo chmod +x /usr/local/bin/speedtest
```

#### For ARM64 (Raspberry Pi 64-bit / ARM64):
```bash
curl -sL "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-aarch64.tgz" | tar -xz -C /tmp
sudo mv /tmp/speedtest /usr/local/bin/
sudo chmod +x /usr/local/bin/speedtest
```

Verify installation:
```bash
speedtest --version
```

---

### 2. Install Python Dependencies

```bash
pip3 install -r requirements.txt
```

---

### 3. Setup Systemd Hourly Service & Timer

Copy project files to `/opt/speedtest-mqtt` and enable systemd timer:

```bash
sudo mkdir -p /opt/speedtest-mqtt
sudo cp speedtest_mqtt.py requirements.txt /opt/speedtest-mqtt/
sudo cp systemd/speedtest-mqtt.service systemd/speedtest-mqtt.timer /etc/systemd/system/

# Edit broker details if needed:
# sudo nano /etc/systemd/system/speedtest-mqtt.service

sudo systemctl daemon-reload
sudo systemctl enable --now speedtest-mqtt.timer
```

To trigger a test manually:
```bash
sudo systemctl start speedtest-mqtt.service
```

---

### Option 2: Docker / Docker Compose

Build and run using Docker Compose:

```bash
docker-compose up -d --build
```

---

## 📡 Published MQTT Topics & Payload

### 1. JSON Payload Topic (`speedtest/state`)
```json
{
  "download_mbps": 482.35,
  "upload_mbps": 94.12,
  "ping_ms": 12.4,
  "jitter_ms": 1.2,
  "isp": "Your ISP Name",
  "server": "Closest Ookla Server",
  "timestamp": "2026-08-05T22:00:00Z"
}
```

### 2. Individual Numerical Topics
* `speedtest/download` -> `482.35`
* `speedtest/upload` -> `94.12`
* `speedtest/ping` -> `12.4`

---

## ⚙️ Environment Variables Configuration

| Variable | Default | Description |
|---|---|---|
| `MQTT_BROKER` | `localhost` | MQTT Broker hostname or IP |
| `MQTT_PORT` | `1883` | MQTT Broker Port |
| `MQTT_USER` | `""` | MQTT Username (optional) |
| `MQTT_PASS` | `""` | MQTT Password (optional) |
| `MQTT_TOPIC_PREFIX` | `speedtest` | Base MQTT topic prefix |
| `HA_DISCOVERY` | `true` | Enable Home Assistant MQTT Auto-Discovery |
