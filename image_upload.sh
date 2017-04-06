#!/bin/sh

#remember to do a docker login first
#step1
docker pull ---/---
#step2 - pull the image id
docker images list
#step3 - tag the image
docker tag ---- redislabs/redis
#step3 - push the image
docker push redislabs/redis:latest


