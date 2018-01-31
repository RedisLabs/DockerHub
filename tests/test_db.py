# The MIT License (MIT)
#
# Copyright (c) 2018 Redis Labs
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Script Name: settings.sh
# Author: Cihan Biyikoglu - github:(cihanb)


import sys
import redis

# try:

print (":: test_db.py")

if (len(sys.argv) <= 1):
    print("Need to provide a DB port to test connectiivity. Example: python Redis-Python-Sample.py 12000")

host_name = sys.argv[1]
db_port = sys.argv[2]

print("Connecting to host={0} and port={1}".format(host_name,db_port))
r = redis.StrictRedis(host=host_name, port=db_port, db=0)

print("Set key 'key1' to value '123' on host={0} and port={1}".format(host_name,db_port))
r.set('key1', '123')

print("Get key 'key1' and validate value is '123' on host={0} and port={1}".format(host_name,db_port))
if (r.get('key1') == b'123'):
    print("DB TEST PASSED")
else:
    print("DB TEST FAILED: Can't find the key")

# except:
#     print("DB TEST FAILED")