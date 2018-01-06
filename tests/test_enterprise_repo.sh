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
source ./tests/test_settings.sh

test_images=("redislabs/redis"  "redislabs/redis:latest" "redislabs/redis:4.4.2-46" "redislabs/redis:4.5.0-18" "redislabs/redis:4.5.0-22" "redislabs/redis:4.5.0-31" "redislabs/redis:4.5.0-35" "redislabs/redis:4.5.0-43" "redislabs/redis:4.5.0-51" "redislabs/redis:5.0.0-31")

cleanup(){ 
    echo "cleanup()"
    
    #list of images to delete
    cleanup_containers=($(docker ps -a -f "name=rp*" --format {{.Names}}))
    cleanup_images=($(docker image list --format {{.Repository}}:{{.Tag}}))
    
    
    #remove all running containers 
    for i in ${cleanup_containers[@]}; do 
        echo $info_color"REMOVING CONTAINER : "$no_color $i
        eval "docker rm -f $i"; 
    done

    #remove all images
    for i in ${cleanup_images[@]}; do 
        echo $info_color"REMOVING CONTAINER IMAGE : "$no_color $i
        eval "docker rmi -f $i"; 
    done

}

test_db(){
    echo "test_db()"

    #create redis pack cluster
    docker exec -d --privileged $rp_container_name_prefix "/opt/redislabs/bin/rladmin" cluster create name $rp_fqdn username $rp_admin_account_name password $rp_admin_account_password flash_enabled

    #create database on redis pack cluster
    curl -s -k -u "$rp_admin_account_name:$rp_admin_account_password" --request POST --url "https://localhost:$rp_admin_restapi_port/v1/bdbs"  --header 'content-type: application/json' --data '{"name":"sample-db","type":"redis","memory_size":1073741824,"port":'"$rp_db_port"'}' --retry 10
    
    #test database read/write
    echo ""
    echo $info_color"test result"$no_color" ::::::::::::::::::::::::::::::::::::::"
    python3 test_db.py $rp_db_port
}

### START HERE ###

echo $warning_color"WARNING"$no_color": This will wipe out all your containers and images [y/n]"
read yes_no

if [ $yes_no == 'y' ]
then
    for j in ${test_images[@]};
    do 
        echo ""
        echo $info_color"test#1"$no_color": run "$j
        cleanup
        
        #launch the container
        echo "docker run -d --cap-add sys_resource --name $rp_container_name_prefix -p $rp_admin_ui_port:$rp_admin_ui_port -p $rp_admin_restapi_port:$rp_admin_restapi_port -p $rp_db_port:$rp_db_port $j"
        eval "docker run -d --cap-add sys_resource --name $rp_container_name_prefix -p $rp_admin_ui_port:$rp_admin_ui_port -p $rp_admin_restapi_port:$rp_admin_restapi_port -p $rp_db_port:$rp_db_port $j"
        sleep $sleep_time_in_seconds
        
        #test the database read/write
        test_db
    done
fi
