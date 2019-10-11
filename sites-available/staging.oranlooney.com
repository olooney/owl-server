
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

	server_name staging.oranlooney.com;

	root /var/www/staging.oranlooney.com/public;
	index index.html;
    error_page 404 /404.html;

    expires $expires;

	location / {
        # rewrite ^/xx/?$ /post/xx/ permanent;
        rewrite ^/deep-copy-javascript/?$ /post/deep-copy-javascript/ permanent;
        rewrite ^/apparently-ipad-developer/?$ /post/apparently-ipad-developer/ permanent;
        rewrite ^/semantic-code/?$ /post/semantic-code/ permanent;
        rewrite ^/author/?$ /about/ permanent;

		try_files $uri $uri/ =404;
	}
}
