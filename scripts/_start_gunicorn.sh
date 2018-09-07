#!/bin/bash
gunicorn pinry.wsgi:application -b 0.0.0.0:8000 -w 4 \
    --capture-output --timeout 30 --user www-data --group www-data \
    --log-file /var/log/gunicorn/error.log