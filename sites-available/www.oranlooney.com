
map $sent_http_content_type $expires {
    default                    off;
    text/html                  epoch;
    text/css                   max;
    application/javascript     max;
    ~image/                    max;
}

server {
	listen 80;
	listen [::]:80;

	server_name www.oranlooney.com;

    # security
    server_tokens off;
    add_header X-Frame-Options "DENY";
    add_header X-Content-Type-Options nosniff;

    # performance
    gzip_vary on;
    tcp_nodelay on;
    sendfile on;
    expires $expires;

    # content
	root /var/www/www.oranlooney.com/public;
	index index.html;
    error_page 404 /404.html;
	location / {
        # rewrite ^/xx/?$ /post/xx/ permanent;
        rewrite ^/deep-copy-javascript/?$ /post/deep-copy-javascript/ permanent;
        rewrite ^/apparently-ipad-developer/?$ /post/apparently-ipad-developer/ permanent;
        rewrite ^/semantic-code/?$ /post/semantic-code/ permanent;
        rewrite ^/author/?$ /about/ permanent;

		try_files $uri $uri/ =404;
	}
}
