## ReBloom - Bloom Filter Module for Redis

Rebloom bring in bloom filter as a Redis data type. Bloom filters are probabilistic data structures that do a very good job at quickly determining if something is contained within a set. Bloom filters have a very small footprint and can provide fast ingest rates and query times for membership or existence searches.

## Quick Start Guide

#### 1. Running with Docker
```sh
docker run -p 6379:6379 --name redis-rebloom redislabs/rebloom:latest
```

#### 2. Connecting:
```sh
docker exec -it redis-rebloom bash

# redis-cli
# 127.0.0.1:6379> 
```

#### 3. Start a new bloom filter by adding a new item
```
# 127.0.0.1:6379> BF.ADD newFilter foo
(integer) 1
``` 

#### 4.  Checking if an item exists in the filter
```
# 127.0.0.1:6379> BF.EXISTS newFilter foo
(integer) 1
```

## 
## ReBloom with Redis Enterprise
Redis Enterprise Pack is enterprise grade, highly available, scalable, distributed version of Redis that is fully compatible with open source Redis. You can use ReJSON with Redis Enterprise to get the advantages above with your ReJSON deployments. 

Open source Redis applications using ReBloom transparently work against Redis Enterprise Pack. Simply change your connections to point at Redis Enterprise Pack database endpoint. 

To get started visit the "[Getting started with ReBloom with Redis Enterprise](https://redislabs.com/redis-enterprise-documentation/getting-started/creating-database/rebloom/)" page.


## ReBloom Documentation
Refer to ReBloom [documentation](http://rebloom.io) for detailed information on bloom filters and for getting started with ReBloom.