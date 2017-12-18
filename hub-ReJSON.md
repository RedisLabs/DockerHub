##  ReJSON - Enhanced JSON data type for Redis

ReJSON is a Redis module that implements JSON as a native data type. It allows storing, updating and fetching JSON documents from Redis keys (documents). ReJSON supports;
- JSONPath-like syntax for selecting elements inside documents with fast access to sub-elements
- Typed atomic operations for all JSON values types

## Quick Start Guide

#### 1. Running with Docker
```sh
docker run -p 6379:6379 --name redis-rejson redislabs/rejson:latest
```

#### 2. Connecting:
```sh
docker exec -it redis-rejson bash

# redis-cli
# 127.0.0.1:6379> 
```

#### 3. Add a new JSON value:
```sh
# 127.0.0.1:6379> JSON.SET obj . '{"name":"John Doe","lastSeen":1478476800,"loggedOut": true}'
OK
```

#### 4. Get object names in the document:
```sh
# 127.0.0.1:6379> JSON.OBJKEYS obj .
1) "name"
2) "lastSeen"
3) "loggedOut"
```

## 
## ReJSON with Redis Enterprise
Redis Enterprise Pack is enterprise grade, highly available, scalable, distributed version of Redis that is fully compatible with open source Redis. You can use ReJSON with Redis Enterprise to get the advantages above with your ReJSON deployments. 

Open source Redis applications using ReJSON transparently work against Redis Enterprise Pack. Simply change your connections to point at Redis Enterprise Pack database endpoint. 

To get started visit the "[Getting started with ReJSON with Redis Enterprise](https://redislabs.com/redis-enterprise-documentation/getting-started/creating-database/rejson-quick-start)" page.

## ReJSON Documentation
Refer to ReJSON [documentation](http://rejson.io) for detailed information on ReJSON and for getting started with new JSON type and commands.