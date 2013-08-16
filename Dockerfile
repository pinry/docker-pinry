# Pulling from the LTS version of Ubuntu.
from   ubuntu:12.04

# Make sure we get no notifications that can mess up auto-builds while updating
# and installing apps.
env    DEBIAN_FRONTEND noninteractive

# An annoying error message keeps appearing unless you do this. It's not needed.
run    dpkg-divert --local --rename --add /sbin/initctl
run    ln -s /bin/true /sbin/initctl

# Download and install everything to run pinry and pull pinry itself.
run    echo 'deb http://archive.ubuntu.com/ubuntu precise main universe' > /etc/apt/sources.list
run    echo 'deb-src http://archive.ubuntu.com/ubuntu precise main universe' >> /etc/apt/sources.list
run    apt-get --yes update; apt-get --yes upgrade
run    apt-get --yes install git supervisor nginx python-virtualenv uwsgi uwsgi-plugin-http uwsgi-plugin-python sqlite3
run    apt-get --yes build-dep python-imaging
run    mkdir -p /srv/www/; cd /srv/www/; git clone https://github.com/pinry/pinry.git
run    mkdir /srv/www/pinry/logs; mkdir /srv/www/pinry/uwsgi; mkdir /data


# Configure everything, note that I turn nginx off daemon mode so that
# supervisor will handle it properly. The rest is pretty standard.
run    sed -i '4 i\daemon off;' /etc/nginx/nginx.conf
add    ./nginx/sites-enabled/default /etc/nginx/sites-enabled/default
add    ./uwsgi/apps-enabled/pinry.ini /etc/uwsgi/apps-enabled/pinry.ini
add    ./supervisor/supervisord.conf /etc/supervisor/supervisord.conf
add    ./supervisor/conf.d/nginx.conf /etc/supervisor/conf.d/nginx.conf
add    ./supervisor/conf.d/uwsgi.conf /etc/supervisor/conf.d/uwsgi.conf
add    ./pinry/settings/__init__.py /srv/www/pinry/pinry/settings/__init__.py
add    ./pinry/settings/production.py /srv/www/pinry/pinry/settings/production.py
add    ./scripts/init /init
add    ./scripts/start /start

# Setup the environment for Pinry. Note, I was going to also migrate the
# database and collect static files here but that goes against the docker way.
# Nothing in an image should touch the host machine without express permission.
# To finish up the install you need to run /init after the build. (See README.)
run    cd /srv/www/pinry; virtualenv .; bin/pip install -r requirements.txt; chown -R www-data:www-data .
run    chown -R www-data:www-data /srv/www; chown -R www-data:www-data /data; chmod +x /init; chmod +x /start

# I don't know if these actually do anything honestly. We want port 80 because
# of nginx and we use /data for our mount to our host system and /start will
# run the machine but we have to specify that all in our docker run command
# anyways...
expose 80
volume ["/data"]
cmd    ["/start"]
