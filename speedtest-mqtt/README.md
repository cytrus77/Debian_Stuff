# Hourly Internet Speedtest to MQTT Publisher

This project measures internet download speed, upload speed, latency (ping), and jitter every hour and publishes the results to an **MQTT broker**. It includes built-in support for **Home Assistant MQTT Auto-Discovery**.

---

## 🚀 Why Official Ookla Speedtest CLI?

We recommend the **Official Ookla Speedtest CLI** (`speedtest`) over the Python `speedtest-cli` script because:
1. **Accuracy on High-Speed Connections**: Supports Gigabit (1000+ Mbps) internet speeds without CPU or thread bottlenecking.
2. **Native JSON Output**: Outputs structured data including latency jitter, ISP info, and server metadata via `speedtest --format=json`.
3. **Reliability**: Uses official Ookla speedtest servers and standard protocol headers.

---

## 🛠️ Installation & Setup Options

### Option 1: Native Systemd Service & Timer (Recommended for Debian/Linux)

#### 1. Install Official Ookla Speedtest CLI
```bash
sudo apt-get update
sudo apt-get install -y curl
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt-get install -y speedtest
```

#### 2. Install Python Dependencies
```bash
pip3 install -r requirements.txt
```

#### 3. Setup Systemd Hourly Timer
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

To run a test immediately manually:
```bash
sudo systemctl start speedtest-mqtt.service
```

---

### Option 2: Docker / Docker Compose

Run using Docker Compose:

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
