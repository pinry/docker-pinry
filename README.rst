docker-pinry
============

A nice and easy way to get a pinry instance up and running using docker. For
help on getting started with docker see the `official getting started guide`_.
For more information on Pinry and a demo check out it's `website`_.


Getting docker-pinry
----------------

Running this will get the latest version of both
docker-pinry and pinry itself::

  git clone https://github.com/pinry/docker-pinry
  cd docker-pinry
  
Configuring docker-pinry
------------------------
Enable signups for new users by editing ``pinry/settings/__init__.py``::

  ALLOW_NEW_REGISTRATIONS = True
  
`Additional pinry configuration settings`_
  
Building docker-pinry
---------------------

Running this will build you a docker image with the latest version of both
docker-pinry and pinry itself::

  sudo docker build -t pinry/pinry .


Running docker-pinry
--------------------

Running the start command for the first time will setup your production secret
key, database and static files. It is important that you decide what port you
want and what location on the host machine you wish to store your files. If this
is the only thing running on your system and you wish to make it public without
a proxy then you can set ``-p=80:80``. The setting ``-p=10000:80`` assumes you
are wanting to proxy to this instance using something like nginx. Also note that
you must have your host mount directory created first (``mkdir -p /mnt/pinry``)::

  sudo docker run -d=true -p=10000:80 -v=/mnt/pinry:/data pinry/pinry /start

If it's the first run it'll take a few seconds but it will print out your
container ID which should be used to start and stop the container in the future
using the commands::

  sudo docker start <container_id>
  sudo docker stop <container_id>


Notes on the run commands
`````````````````````````

* ``-v`` is the volume you are mounting ``-v=host_dir:docker_dir``
* ``pinry/pinry`` is simply what I called my docker build of this image
* ``-d=true`` allows this to run cleanly as a daemon, remove for debugging
* ``-p`` is the port it connects to, ``-p=host_port:docker_port``
* ``-e ALLOW_NEW_REGISTRATIONS=true`` enables people from creating new accounts. Defaults ``false``
* ``-e PRIVATE=true`` forces users to login before seeing any pins. Defaults ``false``

Using docker-pinry
------------------
Open a browser to ``http://<YOUR-HOSTNAME>:10000`` and register. Replace YOUR-HOSTNAME with the name
of the machine docker is running on, likely localhost.

Why include nginx and not just map to uwsgi directly?
-----------------------------------------------------

Because uwsgi/django can't serve static files very well and it is unwise to do
so for security reasons. I built this so that people can have a full hosted
solution in a container. If you have a host machine running nginx then of course
there is no point to run nginx in the container as well, you can simply disable
nginx, map uwsgi to a port and then set your host machine's nginx to display
your media and static files since that directory is shared between the container
and host.


Why use sqlite3?
----------------

Because it has a very low resource cost and most pinry websites are small
personal ones. Why have a full on database for that? If you need more power
than you can easily modify the `pinry/settings/production.py` to point to a
stronger database solution.


.. Links

.. _official getting started guide: http://www.docker.io/gettingstarted/
.. _website: http://getpinry.com/
.. _additional pinry configuration settings: https://github.com/pinry/pinry/blob/master/docs/basic_customization.rst

