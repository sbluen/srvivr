#!/bin/sh

# Configure MySQL.
cp /root/srvivr/prod/mysql.config /etc/my.cnf
mysqladmin -u root password cs290
/etc/init.d/mysqld restart &
sleep 5

# Configure Nginx.
/etc/init.d/nginx stop
cp /root/srvivr/prod/nginx.config /etc/nginx/conf.d/default-server.conf

# Install Ant.
yum install ant --skip-broken

# Fix Ruby install.
cd /root/ruby-1.9.2-p0/ext/openssl
ruby extconf.rb --with-openssl=/usr/bin/openssl --with-openssl-lib=/usr/lib/openssl
make
make install

# Set up Srvivr.
cd /root/srvivr
echo gem 'therubyracer' >> Gemfile
bundle config build.linecache19 --with-openssl=/usr/bin/openssl --with-openssl-lib=/usr/lib/openssl
bundle install
bundle exec rake db:create
bundle exec rake db:migrate

# Start WEBrick
rails server -d

# Start the fetcher and tile server (fetcher currently disabled).
cd backend
ant build
ant TileServer &
#ant Fetcher &

# Start Nginx (the site is now live on port 80).
/etc/init.d/nginx start