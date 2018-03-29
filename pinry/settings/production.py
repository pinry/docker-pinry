from pinry.settings import *

import os


DEBUG = False
TEMPLATE_DEBUG = DEBUG

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': '/data/production.db',
    }
}

SECRET_KEY = 'CHANGE-ME'

ALLOWED_HOSTS = ['*']
