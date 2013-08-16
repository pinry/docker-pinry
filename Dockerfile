# -----------------------------------------------------------------------------
# docker-pinry
#
# Builds a basic docker image that can run Pinry (http://getpinry.com) and serve
# all of it's assets, there are more optimal ways to do this but this is the
# most friendly and has everything contained in a single instance.
#
# Authors: Isaac Bythewood
# Updated: Aug 16th, 2014
# Require: Docker (http://www.docker.io/)
# -----------------------------------------------------------------------------


# Base system is the LTS version of Ubuntu.
from   ubuntu:12.04


# Make sure we don't get notifications we can't answer during building.
env    DEBIAN_FRONTEND noninteractive


# An annoying error message keeps appearing unless you do this.
run    dpkg-divert --local --rename --add /sbin/initctl
run    ln -s /bin/true /sbin/initctl


# Download and install everything from the repos and create virtualenv.
add    ./apt/sources.list /etc/apt/sources.list
run    apt-get --yes update; apt-get --yes upgrade
run    apt-get --yes install git supervisor nginx python-virtualenv uwsgi uwsgi-plugin-http uwsgi-plugin-python sqlite3
run    apt-get --yes build-dep python-imaging
run    mkdir -p /srv/www/; cd /srv/www/; git clone https://github.com/pinry/pinry.git
run    mkdir /srv/www/pinry/logs; mkdir /srv/www/pinry/uwsgi; mkdir /data
run    cd /srv/www/pinry; virtualenv .; bin/pip install -r requirements.txt; chown -R www-data:www-data .


# Load in all of our config files.
add    ./nginx/nginx.conf /etc/nginx/nginx.conf
add    ./nginx/sites-enabled/default /etc/nginx/sites-enabled/default
add    ./uwsgi/apps-enabled/pinry.ini /etc/uwsgi/apps-enabled/pinry.ini
add    ./supervisor/supervisord.conf /etc/supervisor/supervisord.conf
add    ./supervisor/conf.d/nginx.conf /etc/supervisor/conf.d/nginx.conf
add    ./supervisor/conf.d/uwsgi.conf /etc/supervisor/conf.d/uwsgi.conf
add    ./pinry/settings/__init__.py /srv/www/pinry/pinry/settings/__init__.py
add    ./pinry/settings/production.py /srv/www/pinry/pinry/settings/production.py
add    ./scripts/init /init
add    ./scripts/start /start


# Fix all permissions
run    chown -R www-data:www-data /srv/www; chown -R www-data:www-data /data; chmod +x /init; chmod +x /start


# 80 is for nginx web, /data contains static files and database /start runs it.
expose 80
volume ["/data"]
cmd    ["/start"]
