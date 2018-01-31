[![Build Status](https://travis-ci.org/cihanb/redis-py-on-docker.svg?branch=master)](https://travis-ci.org/cihanb/redis-py-on-docker)

## ```redis-py``` 
# Docker Image for Testing Python Based Apps with Redis & Redis Enterprise
Sample docker image based on ```python 3``` with ```redis-py``` for testing simple python based Redis apps.

Simply run ```Redis-Python-Sample.py``` with ```hostname``` and ```port``` for the Redis database to test SET & GET commands:
```
# python Redis-Python-Sample.py 172.17.0.3 12000

Connecting to host=172.17.0.3 and port=12000
Set key 'key1' to value '123' on host=172.17.0.3 and port=12000
Get key 'key1' and validate value is '123' on host=172.17.0.3 and port=12000
DB TEST PASSED
```
# 
# Step by Step Guides
For detailed instructions on how to test python based Redis apps with Redis or Redis Enterprise visit [Redis Enterprise Hub](https://hub.docker.com/r/redislabs/redis/) or [Redis Hub](https://hub.docker.com/_/redis/).
