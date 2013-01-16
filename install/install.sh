#!/bin/bash

set -o errexit
set -o nounset

if [ "$(id -u)" != "0" ]; then
  echo '** Script must be run as root **'
  exit 1
fi

CURRENT_MTU=$( /sbin/ifconfig eth0 | grep MTU | awk '{print $5}' | cut -d: -f2 )

if [ "$CURRENT_MTU" -ge "1500" ]; then
  echo "Changing MTU from 1500 to 1492"
  /sbin/ifconfig eth0 mtu 1492
  sh -c "cat > /etc/network/if-up.d/mtu" <<EOT
  #!/bin/sh
  ifconfig eth0 mtu 1492
EOT
  chmod 755 /etc/network/if-up.d/mtu
fi

echo "Setting up locale"
if [ ! -f /usr/lib/locale/en_GB.utf8 ]; then
  locale-gen en_GB.UTF-8
fi
export LANG=en_GB.UTF-8

echo "Setting up apt-get"
sh -c "cat > /etc/apt/sources.list" <<EOT
#############################################################
################### OFFICIAL UBUNTU REPOS ###################
#############################################################

###### Ubuntu Main Repos
deb http://uk.archive.ubuntu.com/ubuntu/ lucid main universe
deb-src http://uk.archive.ubuntu.com/ubuntu/ lucid main universe

###### Ubuntu Update Repos
deb http://uk.archive.ubuntu.com/ubuntu/ lucid-security main universe
deb http://uk.archive.ubuntu.com/ubuntu/ lucid-updates main universe
deb-src http://uk.archive.ubuntu.com/ubuntu/ lucid-security main universe
deb-src http://uk.archive.ubuntu.com/ubuntu/ lucid-updates main universe
EOT
apt-get update -q

echo "Upgrading system"
apt-get upgrade -yqV

if ! command -v lsof &>/dev/null; then
  echo "Installing lsof"
  apt-get install lsof -yqV
fi

if ! command -v wget &>/dev/null; then
  echo "Installing wget"
  apt-get install wget -yqV
fi

if ! command -v tmux &>/dev/null; then
  echo "Installing tmux"
  apt-get install tmux -yqV
fi

mkdir -p ~/src

# install essentials
apt-get install apt-utils curl libcurl3 bison build-essential zlib1g-dev libssl-dev -yqV
apt-get install libreadline5-dev libxml2 libxml2-dev libxslt1.1 libxslt1-dev git-core -yqV
apt-get install sqlite3 libsqlite3-ruby libsqlite3-dev unzip zip ruby-dev libmysql-ruby -yqV
apt-get install libmysqlclient-dev libcurl4-openssl-dev libpq-dev libyaml-dev -yqV

# nginx
apt-get install nginx -yqV

cat <<EOF > /etc/nginx/nginx.conf
user                www-data;
worker_processes    1;

pid                 /var/run/nginx.pid;

events {
worker_connections  1024;
# multi_accept        on;
}

http {
  include             /etc/nginx/mime.types;

  # set a default type for the rare situation that
  # nothing matches from the mimie-type include
  default_type        application/octet-stream;

  # configure log format
  log_format main     '\$remote_addr - \$remote_user [\$time_local] '
  '"\$request" \$status  \$body_bytes_sent "\$http_referer" '
  '"\$http_user_agent" "\$http_x_forwarded_for"';

  access_log        /var/log/nginx/access.log main;

  # main error log - valid error reporting levels are debug, notice and info
  error_log           /var/log/nginx/error.log  debug;

  sendfile            on;

  keepalive_timeout   2;

  # These are good default values.
  tcp_nopush          on;
  tcp_nodelay         off;

  # output compression saves bandwidth
  gzip                on;
  gzip_buffers        4 8k;
  gzip_comp_level     2;
  gzip_http_version   1.0;
  gzip_min_length     1100;
  gzip_proxied        any;
  gzip_types          text/plain text/css application/x-javascript text/xml application/xml application/xml+rss text/javascript;
  gzip_disable        "MSIE [1-6]\.(?!.*SV1)";

  include /etc/nginx/conf.d/*.conf;
  include /etc/nginx/sites-enabled/*;
}
EOF

if [ ! -f /etc/nginx/sites-available/build_lights ]; then
  cat <<EOF > /etc/nginx/sites-available/build_lights
  upstream build_lights {
  server 127.0.0.1:8000;
  server 127.0.0.1:8001;
  server 127.0.0.1:8002;
  server 127.0.0.1:8003;
  }

  server {
    listen                80;
    server_name           build_lights.nat.bt.com;

    root                  /home/build_lights/www/build_lights/current/public;

    access_log            /home/build_lights/www/build_lights/current/log/nginx.log main;
    error_log             /home/build_lights/www/build_lights/current/log/error.log debug;

    location / {

    # needed to forward user's IP address
    proxy_set_header         X-Real-IP  \$remote_addr;

    # If the file exists as a static file serve it directly
    if (-f \$request_filename) {
      break;
    }

    # for cap deploy:web:enable (not tested)
    if (-f \$document_root/system/maintenance.html) {
      rewrite ^(.*)\$ /system/maintenance.html break;
    }

    if (!-f \$request_filename) {
      proxy_pass  http://build_lights;
      break;
    }
  }
}
EOF
fi

if [ ! -f /etc/nginx/sites-enabled/build_lights ]; then
  ln -s /etc/nginx/sites-available/build_lights /etc/nginx/sites-enabled/build_lights
fi

if [ -f /etc/nginx/sites-enabled/default ]; then
  rm -f /etc/nginx/sites-enabled/default
fi

# ruby
apt-get install build-essential libssl-dev zlib1g-dev libreadline5-dev libxml2-dev libpq-dev -yqV
if [ ! -f ~/src/ruby-1.9.3-p362.tar.gz ]; then
  cd ~/src
  wget "http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p362.tar.gz"
fi

if [ ! -f /usr/local/bin/ruby ]; then
  cd ~/src
  tar xzf ruby-1.9.3-p362.tar.gz
  cd ruby-1.9.3-p362
  ./configure --disable-pthread --prefix=/usr/local
  make
  make install
fi

# rubygems
if [ ! -f ~/src/rubygems-1.8.24.tgz ]; then
  cd ~/src
  wget "http://production.cf.rubygems.org/rubygems/rubygems-1.8.24.tgz"
fi

if ! /usr/local/bin/gem -v | /bin/egrep '1.8.24' &>/dev/null; then
  cd ~/src
  tar xzf rubygems-1.8.24.tgz
  cd rubygems-1.8.24
  /usr/local/bin/ruby setup.rb
fi

if ! /usr/local/bin/gem list | /bin/egrep 'rake' &>/dev/null; then
  gem install rake --no-rdoc --no-ri
fi

if ! /usr/local/bin/gem list | /bin/egrep 'bundler' &>/dev/null; then
  gem install bundler --no-rdoc --no-ri
fi

# build_lights account
if ! /bin/egrep -i "^admin\:" /etc/group &>/dev/null; then
  echo "Creating the admin group"
  groupadd admin
fi

if ! /bin/egrep -i "^%admin ALL" /etc/sudoers &>/dev/null; then
  echo "Allowing sudo access for the admin group"
  cat <<EOF >> /etc/sudoers
  # Members of the admin group may gain root privileges
  %admin ALL=(ALL) ALL
EOF
fi

if ! /bin/egrep -i "build_lights" /etc/passwd &>/dev/null; then
  echo "Creating the build_lights user"

  # to generate an encrypted password for useradd:
  # perl -e 'print crypt("1YelloDog@", "password"),"\n"'
  useradd -d /home/build_lights -s /bin/bash -G admin -p paaovQ9zA2en.  -m build_lights

  cp -r ~/.ssh /home/build_lights/
  chown -R build_lights:build_lights /home/build_lights/.ssh
  mkdir -p /home/build_lights/www
  chown -R build_lights:build_lights /home/build_lights/www

  echo "initialise git repo"
  cd /home/build_lights/www
  git init --shared
  git config --bool receive.denyNonFastForwards false
  git config receive.denyCurrentBranch ignore 
fi

