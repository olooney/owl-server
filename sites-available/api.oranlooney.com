server {
    server_name api.oranlooney.com;
    listen 80;

    # additional security
    server_tokens off;
    add_header X-Frame-Options "DENY";
    add_header X-Content-Type-Options nosniff;

    # performance
    gzip_vary on;
    tcp_nodelay on;
    sendfile on;
    client_max_body_size 2G;

    location / {
        proxy_pass http://localhost:8042;
    }
}

server {
    server_name api.oranlooney.com;

    # SSL / HTTPS
    listen 443;
    ssl on;
    ssl_certificate       /etc/ssl/certs/api.oranlooney.com.certificate.pem;
    ssl_certificate_key   /etc/ssl/private/api.oranlooney.com.key.pem;
    ssl_protocols         TLSv1.1 TLSv1.2;
    gzip off;
    gzip_vary off;

    # additional security
    server_tokens off;
    add_header X-Frame-Options "DENY";
    add_header X-Content-Type-Options nosniff;

    # performance
    tcp_nodelay on;
    sendfile on;
    client_max_body_size 2G;

    location / {
        proxy_pass http://localhost:8042;
    }
}

# running with gunicorn and docker restart
docker run -itd \
    --restart always \
    -p 127.0.0.1:8042:8042 \
    olooney/magic:`cat magic/VERSION` \
    gunicorn \
        --workers=3 \
        --bind 0.0.0.0:8042 \
        --access-logfile - \
        --error-logfile - \
        --timeout 900 \
        --name magic_server \
        magic.server:app

# magic/server.py
from flask import Flask, request, redirect, send_file, after_this_request, render_template, jsonify
app = Flask("magic")

@app.route("/")
def index():
    return render_template("index.html")
