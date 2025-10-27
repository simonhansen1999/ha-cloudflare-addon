#!/usr/bin/env python3
import os, json, threading, subprocess, requests, traceback
from flask import Flask, jsonify, send_from_directory

DATA_DIR = "/data"
TUNNEL_DIR = os.path.join(DATA_DIR,"cloudflared")
OPTIONS_FILE = os.path.join(DATA_DIR, "options.json")
STATUS_FILE = os.path.join(DATA_DIR, "status.json")

DEFAULT_OPTIONS = {
    "api_token": "",
    "hostname": "",
    "service_port": 8123,
    "records": ["home.example.com"],
    "update_interval": 10,
    "ipv6": True,
    "create_missing": True
}

status = {"version":"2.2.0","tunnel":"stopped","hostname":None,"service_port":8123,"error":None}
options = DEFAULT_OPTIONS.copy()
tunnel_process = None

def load_options():
    global options
    try:
        if os.path.exists(OPTIONS_FILE):
            with open(OPTIONS_FILE,"r") as fh:
                data = json.load(fh)
            new = DEFAULT_OPTIONS.copy()
            new.update(data)
            options = new
        else:
            with open(OPTIONS_FILE,"w") as fh:
                json.dump(DEFAULT_OPTIONS,fh,indent=2)
            options = DEFAULT_OPTIONS.copy()
    except Exception as e:
        print("Failed to load options:", e)

def save_status():
    try:
        with open(STATUS_FILE,"w") as fh:
            json.dump(status,fh,indent=2)
    except: pass

def start_tunnel():
    global tunnel_process
    load_options()
    hostname = options.get("hostname")
    port = options.get("service_port",8123)
    api_token = options.get("api_token")
    if not hostname or not api_token:
        status["error"] = "Hostname or API token missing"
        save_status()
        return False
    os.makedirs(TUNNEL_DIR, exist_ok=True)
    try:
        headers = {"Authorization": f"Bearer {api_token}","Content-Type":"application/json"}
        r = requests.post("https://api.cloudflare.com/client/v4/accounts/self/tunnels", headers=headers, json={"name":"ha-tunnel"})
        r.raise_for_status()
        data = r.json()["result"]
        tunnel_id = data["id"]
        credentials = data["credentials"]
        cred_file = os.path.join(TUNNEL_DIR,"ha-tunnel.json")
        with open(cred_file,"w") as fh:
            json.dump(credentials,fh,indent=2)
        config_file = os.path.join(TUNNEL_DIR,"config.yml")
        with open(config_file,"w") as fh:
            fh.write(f'''tunnel: {tunnel_id}
credentials-file: {cred_file}
ingress:
  - hostname: {hostname}
    service: http://localhost:{port}
  - service: http_status:404''')
        tunnel_process = subprocess.Popen(["cloudflared","tunnel","--config",config_file,"run"])
        status.update({"tunnel":"running","hostname":hostname,"service_port":port,"error":None})
        save_status()
        return True
    except Exception as e:
        status.update({"tunnel":"stopped","error":str(e)})
        save_status()
        print(traceback.format_exc())
        return False

def stop_tunnel():
    global tunnel_process
    if tunnel_process:
        tunnel_process.terminate()
        tunnel_process.wait()
        tunnel_process = None
    status.update({"tunnel":"stopped"})
    save_status()

app = Flask(__name__, static_folder="www", static_url_path="")

@app.route("/status")
def get_status():
    return jsonify(status)

@app.route("/tunnel/start", methods=["POST"])
def api_start_tunnel():
    stop_tunnel()
    success = start_tunnel()
    return jsonify({"result":"ok" if success else "error","status":status})

@app.route("/tunnel/stop", methods=["POST"])
def api_stop_tunnel():
    stop_tunnel()
    return jsonify({"result":"ok","status":status})

@app.route("/")
def index():
    try:
        return send_from_directory(os.path.join(os.getcwd(),"www"), "index.html")
    except:
        return "UI missing"

if __name__=="__main__":
    os.makedirs(DATA_DIR, exist_ok=True)
    load_options()
    save_status()
    app.run(host="0.0.0.0", port=8080)
