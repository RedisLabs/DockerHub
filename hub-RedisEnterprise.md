### Supported Tags
* _`5.0.0-31`_, _`latest`_
* _`4.5.0-51`_, 
* _`4.4.2-46`_

[![Build Status](https://travis-ci.org/RedisLabs/DockerHub.svg?branch=master)](https://travis-ci.org/RedisLabs/DockerHub)

## What is Redis Enterprise Software (RS)? ##
[**Redis Enterprise Software**](https://redislabs.com/redis-enterprise/software//) is enterprise grade, distributed, in-memory NoSQL database server, fully compatible with open source Redis by Redis Labs. Redis Enterprise Software extends open source Redis and delivers stable high performance, zero-downtime linear scaling and high availability, with significant operational savings.

![RS Architecture](https://raw.githubusercontent.com/RedisLabs/DockerHub/master/pictures/general/redis_arch.jpeg)

* Redis Enterprise Software can use both RAM and Flash drives such as SSDs for data processing. See [Redis on Flash](https://redislabs.com/products/redis-pack/flash-memory/)) for details. 
* Redis Enterprise Software can also support active-active geo-distributed applications with [Redis CRDTs](https://redislabs.com/redis-enterprise-documentation/concepts-architecture/intercluster-replication/)
* Redis Enterprise Software supports Redis Modules. See details at [RediSearch](https://redislabs.com/redis-enterprise-documentation/getting-started/creating-database/redisearch/), [ReJSON](https://redislabs.com/redis-enterprise-documentation/getting-started/creating-database/rejson-quick-start/) and [ReBloom](https://redislabs.com/redis-enterprise-documentation/getting-started/creating-database/rebloom/)


# Quick Start

1. __Run the Redis Enterprise container__

```
docker run -d --cap-add sys_resource --name rp -p 8443:8443 -p 9443:9443 -p 12000:12000 redislabs/redis
```

2. __Configure Redis Enterprise cluster using the ```"rladmin"``` tool and ```"create cluster"``` command__

```
docker exec -d --privileged rp "/opt/redislabs/bin/rladmin" cluster create name cluster.local username cihan@redislabs.com password redislabs123
```

3. __Create a database on Redis Enterprise cluster__

```
curl -k -u "cihan@redislabs.com:redislabs123" --request POST --url "https://localhost:9443/v1/bdbs" --header 'content-type: application/json' --data '{"name":"db1","type":"redis","memory_size":102400,"port":12000}'
```

_Note: Redis Enterprise may take a few seconds to start depending on your HW. if you receive the following message: **"503 Service Unavailable"**, wait a few more seconds and repeat step-2 and step3 again._

4. __Connect to Redis database in Redis Enterprise cluster using `"redis-cli"`__

```
docker  exec -it rp bash

# sudo /opt/redislabs/bin/redis-cli -p 12000
# 127.0.0.1:16653> set key1 123
# OK
# 127.0.0.1:16653> get key1
# "123"
#
```

# Step-by-Step Guide

You can run the Redis Enterprise Software linux based container on MacOS, various Linux and Windows based machines with Docker. Each Redis Enterprise Software container runs a cluster node. To get started, you can simply set up a one node cluster, create a database and connect your application to the database.


> Note: Redis Enterprise Software Docker image works best when you provide a minimum of 2 cores and 6GB ram per container. You can find additional minimum hardware and software requirements for Redis Enterprise Software in the [product documentation](https://redislabs.com/redis-enterprise-documentation/installing-and-upgrading/hardware-software-requirements/)

1. __Run Redis Enterprise Software container__

Port 8443 is used for the administration UI and port 12000 is reserved for the Redis database that will be created in Step #5 below.


```docker run -d --cap-add sys_resource --name rp -p 8443:8443 -p 12000:12000 redislabs/redis```

2. __Setup Redis Enterprise Software by visiting `https://localhost:8443` on the host machine to see the RS Web Console__

> Note: You may see a certificate error with your browser. Simply choose "continue to the website" to get to the setup screen.

![setup screen](https://raw.githubusercontent.com/RedisLabs/DockerHub/master/pictures/mac/RP-SetupScreen.jpeg)

3. __Go with default settings and provide a cluster FQDN: ```"cluster.local"```__

![setup screen](https://raw.githubusercontent.com/RedisLabs/DockerHub/master/pictures/mac/RP-SetupScreen2.jpeg)

4. __Configure free trial & set up cluster admin account__ 

If you don't have a license key, click "Next" to skip the license key screen to try the free version of the product. On the next screen, set up a cluster admin email and password.

![setup screen](https://raw.githubusercontent.com/RedisLabs/DockerHub/master/pictures/mac/RP-SetupScreen4.jpeg)

5. __Choose the new redis db option__ 

In the new redis db screen, click the "show advanced option" link and provide a database name _"database1"_, endpoint port number of _"12000"_ and click "Activate" to create your database.

![setup screen](https://raw.githubusercontent.com/RedisLabs/DockerHub/master/pictures/mac/RP-DBScreen2.jpeg)

You now have a Redis database!

## Connecting to the Redis Database ##
With the Redis database created, you are ready to connect to your database to store data. You can use ```redis-cli``` or your favorite language with Redis client driver to talk to the new database. There is a python based example below.

* **Connect using ```redis-cli```**: 

```redis-cli``` is a simple commandline tool to interact with a Redis instance. Use the following script to connect to the Redis Enterprise Software container, run ```redis-cli``` connecting to port _12000_ and store and retrieve a key.

````
docker  exec -it rp bash

# sudo /opt/redislabs/bin/redis-cli -p 12000
# 127.0.0.1:16653> set key1 123
# OK
# 127.0.0.1:16653> get key1
# "123"
#
````
 

* **Connect using a Simple Python App**:

If you don't have ```python``` or ```redis-py``` (python library for connecting to Redis) on the host, you can run the [redis-py container](https://hub.docker.com/r/redislabs/redis-py/).


Following section assumes you already have ```python``` and ```redis-py``` configured on the host machine running the container. 

> You can find the instructions to install redis-py on the [github page for redis-py](https://github.com/andymccurdy/redis-py). 

Paste the following into a file named ```"redis_test.py"```

````
import redis

r = redis.StrictRedis(host='localhost', port=12000, db=0)
print ("set key1 123")
print (r.set('key1', '123'))
print ("get key1")
print(r.get('key1'))
````

Run ````redis_test.py```` application to connect to the database and store and retrieve a key.

````
python redis_test.py
````

The output should look like the following screen if the connection is successful.

````
# set key1 123
# True
# get key1
# b'123'
````

# Quick Reference
**Supported Docker Versions:**

Docker version 17.x or greater.

**Getting Started**
 * [Working with Redis Enterprise Software and Docker](https://redislabs.com/redis-enterprise-documentation/installing-and-upgrading/docker/)
 * Getting Started with Redis Enterprise Software and [Docker on Windows](https://redislabs.com/redis-enterprise-documentation/installing-and-upgrading/docker/windows/), 
 * Getting Started with Redis Enterprise Software and [Docker on Mac OSx](https://redislabs.com/redis-enterprise-documentation/installing-and-upgrading/docker/macos/), 
 * Getting Started with Redis Enterprise Software and [Docker on Linux](https://redislabs.com/redis-enterprise-documentation/installing-and-upgrading/docker/linux/)
 * Getting Started with [Redis on Flash](https://redislabs.com/redis-enterprise-documentation/getting-started/creating-database/redis-enterprise-flash/) Databases
 * Getting Started with [Redis CRDTs](https://redislabs.com/redis-enterprise-documentation/getting-started/creating-database/crdbs/)
 
**Detailed Documentation**
 * [Setting up a Redis Enterprise Software Cluster for Production Use](https://redislabs.com/redis-enterprise-documentation/initial-setup-creating-a-new-cluster/)
 * [Technical Documentation](https://redislabs.com/resources/redis-pack-documentation/)
 * [How To Guides](https://redislabs.com/resources/how-to-redis-enterprise/)

