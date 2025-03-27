from flask import Flask, render_template, request, send_file
import os
from ssl_config import get_ssl_state, set_ssl_state

app = Flask(__name__)

CAPTURE_FILE = "/captures/capture.pcap"

@app.route("/", methods=["GET", "POST"])
def index():
    message = ""
    ssl_state = get_ssl_state()

    if request.method == "POST":
        if "toggle_ssl" in request.form:
            ssl_state = request.form.get("toggle_ssl") == "on"
            set_ssl_state(ssl_state)
            message = f"SSL {'enabled' if ssl_state else 'disabled'}"
            os._exit(1)  # Forces container restart

    return render_template("index.html", message=message, ssl_state=ssl_state)

@app.route("/download")
def download():
    return send_file(CAPTURE_FILE, as_attachment=True)

if __name__ == "__main__":
    ssl_enabled = get_ssl_state()
    if ssl_enabled:
        context = ('/certs/cert.pem', '/certs/key.pem')
        app.run(host="0.0.0.0", port=8443, ssl_context=context)
    else:
        app.run(host="0.0.0.0", port=8080)
