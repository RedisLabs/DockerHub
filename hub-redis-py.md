[![Build Status](https://travis-ci.org/RedisLabs/DockerHub.svg?branch=master)](https://travis-ci.org/RedisLabs/DockerHub)

## ```redis-py``` 
# Docker Image for Testing Python Based Apps with Redis & Redis Enterprise
Sample docker image based on ```python3``` with ```redis-py``` for testing simple python based Redis apps. 

# Getting Started
* **Step-1:** Run the Redis Enterprise container.

```docker run -d --cap-add sys_resource --name rp -p 8443:8443 -p 9443:9443 -p 12000:12000 redislabs/redis```

* **Step-2:** Configure Redis Enterprise cluster using the ```rladmin``` tool and ```create cluster``` command.

```docker exec -d --privileged rp "/opt/redislabs/bin/rladmin" cluster create name cluster.local username cihan@redislabs.com password redislabs123```

* **Step-3:** Create a database on Redis Enterprise cluster.

```curl -k -u "cihan@redislabs.com:redislabs123" --request POST --url "https://localhost:9443/v1/bdbs" --header 'content-type: application/json' --data '{"name":"db1","type":"redis","memory_size":102400,"port":12000}'```

_Note: Redis Enterprise may take a few seconds to start depending on the HW you are using to run the container. if you receive the following message: **"503 Service Unavailable"**, wait a few more seconds and repeat step-2 and step3 again._

* **Step-4:** Get the Redis Enterprise database endpoint ip address.

```docker exec -i rp ifconfig eth0 | grep "inet addr" | cut -d":" -f 2 | cut -d" " -f 1```

* **Step-5:** Run redis-py container.

```docker run -d --name redis-python redislabs/redis-py```

* **Step-6:** Run the simple test app

Simply run ```test_db.py``` with ```ip address``` and ```port``` for the Redis database to test SET & GET commands:

```
docker exec -it redis-python bash

# python test_db.py 172.17.0.2 12000
# Connecting to host=172.17.0.2 and port=12000
# Set key 'key1' to value '123' on host=172.17.0.3 and port=12000
# Get key 'key1' and validate value is '123' on host=172.17.0.3 and port=12000
# DB TEST PASSED
```
=======
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
