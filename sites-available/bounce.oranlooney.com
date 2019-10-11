server {
	listen 80;
	listen [::]:80;

	server_name bounce.oranlooney.com;

	root /var/www/bounce.oranlooney.com;
	index index.html;

	location / {
		try_files $uri $uri/ =404;
	}
}
