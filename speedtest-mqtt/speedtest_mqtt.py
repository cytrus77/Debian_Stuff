#!/usr/bin/env python3
import json
import os
import subprocess
import sys
import time
import paho.mqtt.client as mqtt

# Configuration from environment variables
MQTT_BROKER = os.getenv("MQTT_BROKER", "localhost")
MQTT_PORT = int(os.getenv("MQTT_PORT", 1883))
MQTT_USER = os.getenv("MQTT_USER", "")
MQTT_PASS = os.getenv("MQTT_PASS", "")
MQTT_TOPIC_PREFIX = os.getenv("MQTT_TOPIC_PREFIX", "speedtest")
HA_DISCOVERY = os.getenv("HA_DISCOVERY", "true").lower() in ("true", "1", "yes")
HA_DISCOVERY_PREFIX = os.getenv("HA_DISCOVERY_PREFIX", "homeassistant")

def run_speedtest():
    """Runs official Ookla speedtest CLI or fallback to speedtest-cli and parses JSON result."""
    # Check for official Ookla speedtest binary
    cmd = ["speedtest", "--format=json", "--accept-license", "--accept-gdpr"]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        data = json.loads(result.stdout)
        
        # Ookla format: bandwidth is in bytes per second
        download_mbps = round((data["download"]["bandwidth"] * 8) / 1_000_000, 2)
        upload_mbps = round((data["upload"]["bandwidth"] * 8) / 1_000_000, 2)
        ping_ms = round(data["ping"]["latency"], 2)
        jitter_ms = round(data["ping"].get("jitter", 0), 2)
        isp = data.get("isp", "Unknown")
        server_name = data.get("server", {}).get("name", "Unknown")
        
        return {
            "download_mbps": download_mbps,
            "upload_mbps": upload_mbps,
            "ping_ms": ping_ms,
            "jitter_ms": jitter_ms,
            "isp": isp,
            "server": server_name,
            "timestamp": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
        }
    except (FileNotFoundError, subprocess.CalledProcessError):
        # Fallback to python speedtest-cli
        try:
            cmd = ["speedtest-cli", "--json"]
            result = subprocess.run(cmd, capture_output=True, text=True, check=True)
            data = json.loads(result.stdout)
            
            # speedtest-cli format: bits per second
            download_mbps = round(data["download"] / 1_000_000, 2)
            upload_mbps = round(data["upload"] / 1_000_000, 2)
            ping_ms = round(data["ping"], 2)
            
            return {
                "download_mbps": download_mbps,
                "upload_mbps": upload_mbps,
                "ping_ms": ping_ms,
                "timestamp": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
            }
        except Exception as e:
            print(f"Error running speedtest: {e}", file=sys.stderr)
            sys.exit(1)

def publish_ha_discovery(client):
    """Publish Home Assistant MQTT Auto-Discovery configuration."""
    device_info = {
        "identifiers": ["speedtest_mqtt_logger"],
        "name": "Network Speedtest",
        "model": "Speedtest MQTT Publisher",
        "manufacturer": "Ookla CLI"
    }

    sensors = [
        {
            "id": "download_speed",
            "name": "Internet Download Speed",
            "unit": "Mbit/s",
            "device_class": "data_rate",
            "value_template": "{{ value_json.download_mbps }}",
            "icon": "mdi:download"
        },
        {
            "id": "upload_speed",
            "name": "Internet Upload Speed",
            "unit": "Mbit/s",
            "device_class": "data_rate",
            "value_template": "{{ value_json.upload_mbps }}",
            "icon": "mdi:upload"
        },
        {
            "id": "ping_latency",
            "name": "Internet Ping Latency",
            "unit": "ms",
            "device_class": "duration",
            "value_template": "{{ value_json.ping_ms }}",
            "icon": "mdi:speedometer"
        }
    ]

    for s in sensors:
        config_topic = f"{HA_DISCOVERY_PREFIX}/sensor/speedtest/{s['id']}/config"
        config_payload = {
            "name": s["name"],
            "unique_id": f"speedtest_{s['id']}",
            "state_topic": f"{MQTT_TOPIC_PREFIX}/state",
            "unit_of_measurement": s["unit"],
            "value_template": s["value_template"],
            "icon": s["icon"],
            "device": device_info
        }
        if "device_class" in s:
            config_payload["device_class"] = s["device_class"]
            
        client.publish(config_topic, json.dumps(config_payload), retain=True)

def main():
    print("Running Internet Speed Test...")
    results = run_speedtest()
    print(f"Results: Download={results['download_mbps']} Mbps, Upload={results['upload_mbps']} Mbps, Ping={results['ping_ms']} ms")

    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
    if MQTT_USER and MQTT_PASS:
        client.username_pw_set(MQTT_USER, MQTT_PASS)

    print(f"Connecting to MQTT Broker {MQTT_BROKER}:{MQTT_PORT}...")
    client.connect(MQTT_BROKER, MQTT_PORT, 60)
    client.loop_start()

    if HA_DISCOVERY:
        publish_ha_discovery(client)

    state_topic = f"{MQTT_TOPIC_PREFIX}/state"
    client.publish(state_topic, json.dumps(results), retain=True)
    
    # Also publish individual sensor values for simple non-JSON MQTT consumers
    client.publish(f"{MQTT_TOPIC_PREFIX}/download", results["download_mbps"], retain=True)
    client.publish(f"{MQTT_TOPIC_PREFIX}/upload", results["upload_mbps"], retain=True)
    client.publish(f"{MQTT_TOPIC_PREFIX}/ping", results["ping_ms"], retain=True)

    print(f"Successfully published metrics to topic: {state_topic}")
    time.sleep(1)
    client.loop_stop()
    client.disconnect()

if __name__ == "__main__":
    main()
