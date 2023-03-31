#!/usr/bin/env bash

# A script for Deploying the count-service app (Can be changed and be any other deployment)

docker-compose build && docker-compose down && docker-compose up -d

## If 'docker-compose down' is failing, try to run manually 'docker stop count-service && docker rm count-service' and try again