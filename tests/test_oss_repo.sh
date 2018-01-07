#!/bin/bash

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
oss_db_port=6379
oss_container_name_prefix="redis"

#misc settings
sleep_time_in_seconds=150

#print colors
info_color="\033[1;32m"
warning_color="\033[0;33m"
error_color="\033[0;31m"
no_color="\033[0m"

test_images=("redislabs/redisearch"  "redislabs/rejson" "redislabs/rebloom")

cleanup(){ 
    echo "cleanup()"

    #list of contianer to delete
    cleanup_containers=($(docker ps -a -f "name=" --format {{.Names}}))
    
    #remove all running containers 
    for i in ${cleanup_containers[@]}; do 
        echo $info_color"REMOVING CONTAINER : "$no_color $i
        eval "docker rm -f $i"; 
    done

    #list of images to delete
    cleanup_images=($(docker image list --format {{.Repository}}:{{.Tag}}))

    #remove all images
    for i in ${cleanup_images[@]}; do 
        echo $info_color"REMOVING CONTAINER IMAGE : "$no_color $i
        eval "docker rmi -f $i"; 
    done

}

test_db(){
    echo "test_db()"

    #test database read/write
    echo ""
    echo $info_color"test result"$no_color" ::::::::::::::::::::::::::::::::::::::"

    sleep 10
    echo "python test_db.py $oss_db_port"    
    python test_db.py $oss_db_port
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
        echo "docker run -d --name $oss_container_name_prefix -p $oss_db_port:$oss_db_port $j"
        eval "docker run -d --name $oss_container_name_prefix -p $oss_db_port:$oss_db_port $j"

        sleep $sleep_time_in_seconds
        
        #test the database read/write
        test_db
    done
fi
