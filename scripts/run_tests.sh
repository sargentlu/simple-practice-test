#!/bin/bash

# Run this script at the project root
#
# ./run_tests.sh
#
# Optional arguments:
# - clean [./run_tests.sh clean]:
#   Shuts down the browser and removes the current
#   test image
#

# This script runs the test by building docker-compose.yml
# and spins up a container to run the tests contained in
# the simple-practice-test image

docker-compose up -d chrome
docker-compose build

docker-compose run --rm simple-practice-test

# If the browser container is shut down, the test image
# needs to be rebuilt to regain access to the browser
if [ "$1" == 'clean' ]; then
  docker-compose down
  docker image rm sergiomtzlu/simple-practice-test
fi
