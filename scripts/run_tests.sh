#!/bin/bash

docker-compose up -d chrome
docker-compose build

docker-compose run --rm simple-practice-tests

docker-compose down
