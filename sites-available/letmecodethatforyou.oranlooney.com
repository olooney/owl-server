server {
	listen 80;
	listen [::]:80;
	server_name letmecodethatforyou.oranlooney.com;

	# options
	gzip on;
	gzip_types text/html application/javascript image/* test/css;
	gzip_min_length 1024;

	# basic static files
	root /var/www/letmecodthatforyou.oranlooney.com;
	index index.html;

	# deny any file or directory starting with a dot
        location ~ /\. {
        	deny all;
	}

	location / {
		try_files $uri $uri/ =404;
	}
}
