# docker-pinry

A nice and easy way to get a pinry instance up and running using docker. For
help on getting started with docker see the [official getting started guide][0].
For more information on Pinry and a demo check out it's [website][1].


## Building docker-pinry

Running this will build you a docker image with the latest version of both
docker-pinry and pinry itself. I recommend following the "Increasing
docker-pinry security" section below before actually building but it's not a
requirement.

    git clone https://github.com/overshard/docker-pinry.git
    cd docker-pinry
    docker build -t overshard/pinry .


### Increasing docker-pinry security

Before buiding edit `pinry/settings/production.py` and set a custom `SECRET_KEY` 
and set `ALLOWED_HOSTS` to the domain name(s) you're going to be using. It also
wouldn't hurt to enable some SSL via nginx but that goes a bit past this
README file.

## Running docker-pinry

Once you get the system built you'll need to run the `init` once to create your
database and collect static files. The first item in the `-v` option,
`/mnt/pinry`, is the location on the host machine you wish to store these files.
You can now run the `start` command at any time to get the whole thing running.
If you have no other websites running on your server and just want pinry then
you can also map the port `-p` directly to `80`, `-p=80:80` and it will act as
a complete server solution.

    docker run -v=/mnt/pinry:/data overshard/pinry /init
    docker run -d=true -p=10000:80 -v=/mnt/pinry:/data overshard/pinry /start

### Notes on the run commands

 + `-v` is the volume you are mounting `-v=host_dir:docker_dir`
 + `overshard/pinry` is simply what I called my docker build of this image
 + `-d=true` allows this to run cleanly as a daemon, remove for debugging
 + `-p` is the port it connects to, `-p=host_port:docker_port`


## Why include nginx and not just map to uwsgi directly?

Because uwsgi/django can't serve static files very well and it is unwise to do
so for security reasons. I built this so that people can have a full hosted
solution in a container. If you have a host machine running nginx then of course
there is no point to run nginx in the container as well, you can simply disable
nginx, map uwsgi to a port and then set your host machine's nginx to display
your media and static files since that directory is shared between the container
and host.

## Why use sqlite3?

Because it has a very low resource cost and most pinry websites are small
personal ones. Why have a full on database for that? If you need more power
than you can easily modify the `pinry/settings/production.py` to point to a
stronger database solution.


[0]: http://www.docker.io/gettingstarted/
[1]: http://getpinry.com/

