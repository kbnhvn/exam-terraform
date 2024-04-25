#! /bin/bash


# Wordpress install on AMI LINUX 2

# Apache install
sudo yum update -y  
sudo yum install -y httpd


# PHP 8 install
amazon-linux-extras enable php8.0
sudo yum clean metadata
sudo yum install -y php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip,imap,devel}

# Imagick install
sudo yum -y install gcc ImageMagick ImageMagick-devel ImageMagick-perl
pecl install imagick
chmod 755 /usr/lib64/php/modules/imagick.so
cat <<EOF >>/etc/php.d/20-imagick.ini
extension=imagick
EOF
systemctl restart php-fpm.service

# MySQL and MariaDB install
curl -LsS -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
sudo bash mariadb_repo_setup --os-type=rhel  --os-version=7 --mariadb-server-version=10.7
sudo rm -rf /var/cache/yum
sudo yum makecache
sudo yum install -y MariaDB-server MariaDB-client

systemctl start  httpd
systemctl start mysqld

# Change owner
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

# Install wp-cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

# Install Wordpress
DB_USER="user"
DB_PASS="password"
DB_PREFIX="wp_"
DB_NAME="exam-terraform"
WP_EMAIL="joel.lourenco.pro@gmail.com"
WP_USER_PREFIX="admin-"
WP_PASS="password"
SITE_URL_DOMAIN="http://localhost"
SITE_TITLE="exam-terraform"

wp core download --path=/var/www/html --locale=fr_FR
wp core config --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --dbprefix=$DB_PREFIX
wp db create
wp core install --url=$SITE_URL_DOMAIN --title=$1 --admin_user=$WP_USER --admin_password=$WP_PASS --admin_email=$WP_EMAIL --skip-email

# Delete default post and page
wp plugin deactivate hello
wp plugin delete hello
wp post delete $(wp post list --post_type=page,post --format=ids) --force

# Enable Apache and MariaDB auto start
systemctl enable  httpd.service
sudo systemctl enable --now mariadb
systemctl restart httpd.service