![RediSearch Logo](http://redisearch.io/logo.png)

#### [RediSearch](http://redisearch.io) is a an open-source Full-Text and Secondary Index engine over Redis, developed by Redis Labs.

Redisearch implements a search engine on top of Redis, but unlike other Redis 
search libraries, it does not use internal data structures like sorted sets.

This also enables more advanced features, like exact phrase matching and numeric filtering for text queries, 
that are not possible or efficient with traditional redis search approache

### See Full Documentation at [redisearch.io](http://redisearch.io)
----

## Supported Tags

 * `latest` 
 * `1.0.4` (latest version)
 * `1.0.3` 

## Dockerfile

The Dockerfile generating this image can be found at [https://github.com/RedisLabsModules/RediSearch/blob/master/Dockerfile](https://github.com/RedisLabsModules/RediSearch/blob/master/Dockerfile)

## Client Libraries

Official and community client libraries in Python, Java, JavaScript, Ruby, Go, C#, and PHP. 
See [Clients Page](http://redisearch.io/Clients)

---

## Quick Start Guide

#### 1. Running with Docker

```sh
docker run -d -p 6379:6379 redislabs/redisearch:latest
```

#### 2. Connecting:

```sh
redis-cli
```

#### 3. Creating an index with fields and weights (default weight is 1.0):

```
127.0.0.1:6379> FT.CREATE myIdx SCHEMA title TEXT WEIGHT 5.0 body TEXT price NUMERIC
OK 

``` 

##### 4.  Adding documents to the index:
```
127.0.0.1:6379> FT.ADD myIdx doc1 1.0 FIELDS title "hello world" body "lorem ipsum" price "100.5"
OK
```

#### 5. Searching the index:

```
127.0.0.1:6379> FT.SEARCH myIdx "hello world" LIMIT 0 10
1) (integer) 1
2) "doc1"
3) 1) "title"
   2) "hello world"
   3) "body"
   4) "lorem ipsum"
   5) "price"
   6) "100.5"
```

----

#### See Full Documentation at [redisearch.io](http://redisearch.io)

