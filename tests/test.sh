#!/bin/bash

set -e

home_url="http://localhost:$HOST_PORT/"
new_registration_url="http://localhost:$HOST_PORT/register/"

echo "Starting container."

docker run -d=true \
  -p=$HOST_PORT:$GUEST_PORT \
  -v=$MOUNT_DIR:/data \
  -e ALLOW_NEW_REGISTRATIONS="$ALLOW_NEW_REGISTRATIONS" \
  -e PRIVATE="$PRIVATE" \
  "$IMAGE" \
  /start

sleep 10

case $1 in
  private)
    status_code_of_home=`$TRAVIS_BUILD_DIR/tests/http_status_code.sh $home_url`
    status_code_of_new_registration=`$TRAVIS_BUILD_DIR/tests/http_status_code.sh $new_registration_url`
    [ "$status_code_of_home" = "302" ] && [ "$status_code_of_new_registration" = "302" ] && exit 0
    ;;
  allow_new_registrations)
    status_code_of_home=`$TRAVIS_BUILD_DIR/tests/http_status_code.sh $home_url`
    status_code_of_new_registration=`$TRAVIS_BUILD_DIR/tests/http_status_code.sh $new_registration_url`
    [ "$status_code_of_home" = "200" ] && [ "$status_code_of_new_registration" = "200" ] && exit 0
    ;;
  *)
    echo "$0 $1: invalid option."
    exit 1
esac

exit 1
