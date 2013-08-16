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

SECRET_KEY = 'S570yKBCK5LU80uA5U7GL7Kd2LIhZCeNgUZnkUcrhxX02sXPwdK763P1JkURKsz'

ALLOWED_HOSTS = ['*']
