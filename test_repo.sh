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
    echo "test_db()"
    #remove all running dockers 
    for ((i=1; i<4; i++)); do eval "docker rm -f $rp_container_name_prefix$i"; done
    eval "docker rm -f $rp_container_name_prefix"
    #remove all images
    for i in "redislabs/redis" "ushchar2/rlec"; do eval "docker rmi -f $i"; done
}

test_db(){
    #create redis pack cluster
    docker exec -d --privileged $rp_container_name_prefix "/opt/redislabs/bin/rladmin" cluster create name $rp_fqdn username $rp_admin_account_name password $rp_admin_account_password flash_enabled
    #create database on redis pack cluster
    curl -s -k -u "$rp_admin_account_name:$rp_admin_account_password" --request POST --url "https://localhost:$rp_admin_restapi_port/v1/bdbs"  --header 'content-type: application/json' --data '{"name":"sample-db","type":"redis","memory_size":1073741824,"port":'"$rp_db_port"'}' --retry 10
    #test database read/write
    echo ""
    echo $info_color"test result"$no_color" ::::::::::::::::::::::::::::::::::::::"
    python3 utils/test_db.py $rp_db_port
}

### START HERE ###

#TEST1 redislabs/redis
echo ""
echo $info_color"test#1"$no_color": run redislabs/redis"
cleanup
#launch the container
docker run -d --cap-add sys_resource --name $rp_container_name_prefix -p $rp_admin_ui_port:$rp_admin_ui_port -p $rp_admin_restapi_port:$rp_admin_restapi_port -p $rp_db_port:$rp_db_port redislabs/redis
sleep $sleep_time_in_seconds
#test the database read/write
test_db

#TEST2 redislabs/redis:latest
echo ""
echo $info_color"test#2"$no_color": run redislabs/redis:latest"
cleanup
docker run -d --cap-add sys_resource --name rp -p $rp_admin_ui_port:$rp_admin_ui_port -p $rp_admin_restapi_port:$rp_admin_restapi_port -p $rp_db_port:$rp_db_port redislabs/redis:latest
sleep $sleep_time_in_seconds
#test the database read/write
test_db

#TEST3 redislabs/redis:4.4.2-42
echo ""
echo $info_color"test#3"$no_color": run redislabs/redis:4.4.2-42"
cleanup
docker run -d --cap-add sys_resource --name rp -p $rp_admin_ui_port:$rp_admin_ui_port -p $rp_admin_restapi_port:$rp_admin_restapi_port -p $rp_db_port:$rp_db_port redislabs/redis:4.4.2-42
sleep $sleep_time_in_seconds
#test the database read/write
test_db

