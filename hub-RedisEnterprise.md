### Supported Tags
* _`5.0.0-31`_, _`latest`_
* _`4.5.0-51`_, 
* _`4.4.2-46`_

### Quick Reference
* **Supported Docker Versions:**
Docker version 17 or greater.

* **Getting Started and Documentation**
 * [Working with Redis Enterprise Pack and Docker](https://redislabs.com/redis-enterprise-documentation/installing-and-upgrading/docker/)
 * Getting Started with Redis Enterprise Pack and [Docker on Windows](https://redislabs.com/redis-enterprise-documentation/installing-and-upgrading/docker/windows/), 
 * Getting Started with Redis Enterprise Pack and [Docker on Mac OSx](https://redislabs.com/redis-enterprise-documentation/installing-and-upgrading/docker/macos/), 
 * Getting Started with Redis Enterprise Pack and [Docker on Linux](https://redislabs.com/redis-enterprise-documentation/installing-and-upgrading/docker/linux/)
 * [Setting up a Redis Enterprise Pack Cluster](https://redislabs.com/redis-enterprise-documentation/initial-setup-creating-a-new-cluster/)
 * [Documentation](https://redislabs.com/resources/redis-pack-documentation/)
 * [How To Guides](https://redislabs.com/resources/how-to-redis-enterprise/)

## What is Redis Enterprise Pack (RP)? ##
[**Redis Enterprise Pack**](https://redislabs.com/products/redis-pack/) is enterprise grade, highly available, scalable, distributed, in-memory NoSQL database server, fully compatible with open source Redis by Redis Labs.

**_Note: Open source Redis applications transparently work against Redis Enterprise Pack. Simply change your connections to point at Redis Enterprise Pack database endpoint..._**

Redis Enterprise Pack extends open source Redis and delivers stable high performance, zero-downtime linear scaling and high availability, with significant operational savings.

Redis Enterprise Pack also augments Redis databases with the capability to use a combination of RAM and cost-effective Flash memory (a.k.a [Redis Enterprise Flash](https://redislabs.com/products/redis-pack/flash-memory/)), retaining the same sub-millisecond latencies of Redis while storing larger datasets at drastically lower costs.

![RP Architecture](https://raw.githubusercontent.com/RedisLabs/DockerHub/master/images/general/redis_arch.jpeg)

## Quick Start with Redis Enterprise Pack Container ##

**_Note: Redis Enterprise Pack Docker image works best when you provide a minimum of 2 cores and 6GB ram per container. You can find additional minimum hardware and software requirements for Redis Enterprise Pack in the [product documentation](https://redislabs.com/redis-enterprise-documentation/installing-and-upgrading/hardware-software-requirements/)_** 

You can run the Redis Enterprise Pack container linux based container in MacOS, various Linux and Windows based machines with Docker. Each Redis Enterprise Pack container runs a cluster node. To get started, you can simply set up a one node cluster, create a database and connect your application to the database.

* **Step-1:** Start Redis Enterprise Pack container

`docker run -d --cap-add sys_resource --name rp -p 8443:8443 -p 12000:12000 redislabs/redis`

* **Step-2:** Setup Redis Enterprise Pack by visiting `https://localhost:8443` on the host machine to see the RP Web Console. 

**_Note: You may see a certificate error depending on your browser. Simply choose "continue to the website" to get to the setup screen._**

![setup screen](https://raw.githubusercontent.com/RedisLabs/DockerHub/master/images/mac/RP-SetupScreen.jpeg)

* **Step-3:** Go with default settings and provide only a cluster FQDN: "cluster.local"

![setup screen](https://raw.githubusercontent.com/RedisLabs/DockerHub/master/images/mac/RP-SetupScreen2.jpeg)

* **Step-4:** Click "Next" to skip the license key screen if you don't have a license key to try the free version of the product. On the next screen, set up a cluster admin email and password.

![setup screen](https://raw.githubusercontent.com/RedisLabs/DockerHub/master/images/mac/RP-SetupScreen4.jpeg)

* **Step-5:** Choose the new redis db option. In the new redis db screen, click the "show advanced option" link and provide a database name _"database1"_, endpoint port number of _"12000"_ and click "Activate" to create your database.

![setup screen](https://raw.githubusercontent.com/RedisLabs/DockerHub/master/images/mac/RP-DBScreen2.jpeg)

You now have a Redis database!

## Connecting to the Redis Database ##
With the Redis database created, you are ready to connect to your database to store data.

* **Connect using redis-cli**: Read and Write Data using `redis-cli`

redis-cli is a simple commandline tool to interact with a Redis instance. Use the following script to connect to the Redis Enterprise Pack container, run redis-cli connecting to port _12000_ and store and retrieve a key.

```
docker  exec -it rp bash

# sudo /opt/redislabs/bin/redis-cli -p 12000
# 127.0.0.1:16653> set key1 123
# OK
# 127.0.0.1:16653> get key1
# "123"
```
 

* **Connect using a Simple Python App**: Read and Write Data using a few lines of Python code

A simple Python app running in the host machine can also connect to the _database1_ created Redis Enterprise Pack container. The following section assumes you already have Python and redis-py (Python library for connecting to Redis) configured on the host machine running the container. You can find the instructions to configure redis-py on the [github page for redis-py](https://github.com/andymccurdy/redis-py)

Paste the following into a file named ```"redis_test.py"```

```
import redis

r = redis.StrictRedis(host='localhost', port=12000, db=0)
print ("set key1 123")
print (r.set('key1', '123'))
print ("get key1")
print(r.get('key1'))
```

Run ```redis_test.py``` application to connect to the database and store and retrieve a key.

```
python.exe redis_test.py
```

The output should look like the following screen if the connection is successful.

```
# set key1 123
# True
# get key1
# b'123'
```

## Common Topologies with Redis Pack with Docker Containers ##

Redis Enterprise Pack (RP) can be deployed using this container on Windows, macOS and Linux based systems. RP container represents a node in an RP Cluster. When deploying RP using Docker, there are a couple of common topologies.
* Topology#1: The simplest topology is to run single node RP Cluster with a single container in a single host machine. This is best for local development or functional testing. This topology is depicted under Topology#1 below. Simply follow the instruction in the getting started pages for Windows and macOS and Linux pages. 

* Topology#2: You may also run multi-node RP cluster with multiple rp containers all deployed to a single host machine. This topology is similar to the previous setup except you run a multi node cluster to developer and test against a system that scale-minimized but similar to your production RP deployment. It is important to note that the topology, under load causes the containers to interfere with each other, thus is not recommended if you are looking for predictable performance. 

* Topology#3: You may also run multi-node RP cluster with multiple RP containers each deployed to its own host machine. This topology minimizes interference between RP containers so performs more predictably compared to topology#2. This topology is depicted under Topology#3 below. 

![topologies](https://raw.githubusercontent.com/RedisLabs/DockerHub/master/images/general/topology.jpeg)


## Known Issues ##

* **Possible error when creating a database: "Cannot allocate nodes for shards"** - If you don't configure the memory limit high enough, you may see an error when creating a database that reads : "Cannot allocate nodes for shards". It is important to note that RP Docker image works best when you provide a minimum of 2 cores and 6GB ram per container. You can work around the issue by increasing the RAM allocated to the container either through Docker preferences on your machine or by specifying the -m option with docker run command. You can find additional minimum hardware and software requirements for Redis Enterprise Pack in the [product documentation](https://redislabs.com/redis-enterprise-documentation/installing-and-upgrading/hardware-software-requirements/) 
