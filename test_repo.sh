#!/bin/sh

# The MIT License (MIT)
#
# Copyright (c) 2015 Redis Labs
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

#read settings
source settings.sh

cleanup(){
    #remove all running dockers 
    for ((i=1; i<4; i++)); do eval "docker rm rp$i"; done
    #remove all images
    for i in "redislabs/redis" "uchchar2/rlec"; do eval "docker rmi $i"; done
}


#create
echo ""
echo $info_color"INFO"$no_color": Starting Redis Enterprise Pack containers on a single network"

#TEST1 redislabs/redis
echo ""
echo $info_color"test#1"$no_color": run redislabs/redis"
cleanup
docker run -d --cap-add sys_resource --name rp -p 8443:8443 -p 12000:12000 redislabs/redis


#TEST2 redislabs/redis:latest
echo ""
echo $info_color"test#2"$no_color": run redislabs/redis"
cleanup
docker run -d --cap-add sys_resource --name rp -p 8443:8443 -p 12000:12000 redislabs/redis:latest

#TEST3 redislabs/redis:4.4.2-42
echo ""
echo $info_color"test#3"$no_color": run redislabs/redis:4.4.2-42"
cleanup
docker run -d --cap-add sys_resource --name rp -p 8443:8443 -p 12000:12000 redislabs/redis:4.4.2-42

