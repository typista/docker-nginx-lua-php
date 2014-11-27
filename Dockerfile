#http://qiita.com/hnakamur/items/0b72590136cece29faee
FROM typista/nginx-lua:0.6
RUN wget https://raw.githubusercontent.com/typista/docker-nginx-lua-php/master/files/etc_init.d_nginx -O /root/etc_init.d_nginx && \
	wget https://raw.githubusercontent.com/typista/docker-nginx-lua-php/master/files/nginx.conf -O /root/nginx.conf && \
	wget https://raw.githubusercontent.com/typista/docker-nginx-lua-php/master/files/php_exec -O /usr/local/nginx/conf/php_exec && \
	wget https://raw.githubusercontent.com/typista/docker-nginx-lua-php/master/files/php_ssl_exec -O /usr/local/nginx/conf/php_ssl_exec && \
	wget https://raw.githubusercontent.com/typista/docker-nginx-lua-php/master/files/services.sh -O /etc/services.sh && \
	chmod +x /etc/services.sh && \
	chmod +x /etc/init.d/nginx && \
	yum update -y && \
    rpm -Uvh http://ftp.iij.ad.jp/pub/linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm && \
	yum install -y --enablerepo=remi,remi-php56,epel gcc php php-cgi php-common && \
	yum install -y --enablerepo=remi,remi-php56,epel php-gd php-fpm php-opcache php-devel php-mbstring php-mcrypt php-mysqlnd && \
	yum install -y --enablerepo=remi,remi-php56,epel php-phpunit-PHPUnit php-pecl-xdebug php-pecl-xhprof && \
	yum install -y --enablerepo=remi,remi-php56,epel ImageMagick ImageMagick-devel && \
    mkdir -p /var/run/nginx/ && \
	pecl install imagick && \
	pecl install mongo
#EXPOSE 80
#ENTRYPOINT /etc/services.sh

