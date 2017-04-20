import sys
import redis

try:
    db_port = sys.argv[1]
    r = redis.StrictRedis(host='localhost', port=db_port, db=0)
    r.set('key1', '123')
    if (r.get('key1') == b'123'):
        print("DB TEST PASSED")
    else:
        print("DB TEST FAILED")
except :
    print("DB TEST FAILED")