import os

STATE_FILE = "/tmp/ssl_state.txt"

def set_ssl_state(enabled: bool):
    with open(STATE_FILE, "w") as f:
        f.write("on" if enabled else "off")

def get_ssl_state():
    if not os.path.exists(STATE_FILE):
        return False
    with open(STATE_FILE, "r") as f:
        return f.read().strip() == "on"
