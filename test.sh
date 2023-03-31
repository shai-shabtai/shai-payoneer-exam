#!/usr/bin/env bash

set -x

# Check if docker test is running 
output=$(docker ps | grep count-service-check)
if [[ $output == '' ]]; then
    echo "ERROR: docker check is not running $output"
    exit 1
fi

# Test `/healthcheck` call -- should return 
output=$(docker exec count-service-check bash -c 'curl \
    --write-out "%{http_code}" \
    --silent \
    --output /dev/null \
    http://localhost:5000/healthcheck')
if [[ $output != '200' ]]; then
    echo "ERROR: healthcheck request failed with response code $output"
    exit 1
fi

# Add an api `/healthcheck` which will always return {"status":"ok"}
output=$(docker exec count-service-check bash -c 'curl \
    --fail \
    --silent \
    http://localhost:5000/healthcheck')
if [[ $output != '{"status":"ok"}' ]]; then
    echo "ERROR: healthcheck request got unexpected output: $output"
    exit 1
fi



# Test to check the 'couner'
output=$(docker exec count-service-check bash -c 'curl \
    --fail \
    --silent \
    http://localhost:5000/countcheck')
if [[ $output != '{"counter":0}' ]]; then
    echo "ERROR: countcheck request got unexpected output: $output"
    exit 1
fi


# POST call to update the counter
output=$(docker exec count-service-check bash -c 'curl \
    --request POST http://localhost:5000/post' \
    --fail \
    --silent \
    --header 'Content-Type: application/json' \
    --data '')
if [[ $output != '{"The new counter value is":1}' ]]; then
    echo "ERROR: countcheck request got unexpected output: $output"
    exit 1
fi


# check the counter were changed to 1
output=$(docker exec count-service-check bash -c 'curl \
    --fail \
    --silent \
    http://localhost:5000/countcheck')
if [[ $output != '{"counter":1}' ]]; then
    echo "ERROR: countcheck request got unexpected output: $output"
    exit 1
fi

echo "TEST COMPLETED SUCCESSFULLY"
