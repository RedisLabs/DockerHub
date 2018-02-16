#!/bin/bash

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

#settings import
source ./test_settings.sh


test_oss_db(){
    echo ":: test_redir-py.sh:: test_oss_db()"

    #cleanup images and containers
    cleanup

    #launch the container
    echo "docker run -d --name redis-python redislabs/redis-py"
    docker run -d --name redis-python redislabs/redis-py

    echo "docker exec -i redis-python \"python\" /usr/src/app/test_db.py $oss_host_name $oss_db_port"
    docker exec -i redis-python "python" /usr/src/app/test_db.py $oss_host_name $oss_db_port
}


#Enterprise settings
# rp_host_name=172.17.0.2 #typically the default ip address
# rp_admin_ui_port=8443
# rp_admin_restapi_port=9443
# rp_db_port=12000
# rp_admin_account_name="cihan@redislabs.com"
# rp_admin_account_password="redislabs123"
# rp_fqdn="cluster.rp.local"


test_enterprise_db(){
    echo ":: test_redir-py.sh:: test_enterprise_db()"

    #cleanup images and containers
    cleanup

    #launch the redis-py container
    echo "docker run -d --name redis-python redislabs/redis-py:latest"
    docker run -d --name redis-python redislabs/redis-py:latest

    #launch the enterprise container

    echo "docker run -d --cap-add sys_resource --name rp -p 9443:9443 -p 12000:12000 redislabs/redis:latest"
    docker run -d --cap-add sys_resource --name rp -p $rp_admin_restapi_port:$rp_admin_restapi_port -p $rp_db_port:$rp_db_port redislabs/redis:latest

    #provision cluster
    sleep 60
    echo "docker exec -d --privileged rp /opt/redislabs/bin/rladmin cluster create name cluster.local username cihan@redislabs.com password redislabs123"
    docker exec -d --privileged rp "/opt/redislabs/bin/rladmin" cluster create name $rp_fqdn username $rp_admin_account_name password $rp_admin_account_password

    #provision db
    sleep  60
    echo "curl -k -u \"$rp_admin_account_name:$rp_admin_account_password\" --request POST --url \"https://localhost:9443/v1/bdbs\" --header 'content-type: application/json' --data '{\"name\":\"db1\",\"type\":\"redis\",\"memory_size\":102400,\"port\":$rp_db_port}"
    curl -k -u "$rp_admin_account_name:$rp_admin_account_password" --request POST --url "https://localhost:9443/v1/bdbs" --header 'content-type: application/json' --data '{"name":"db1","type":"redis","memory_size":102400,"port":'$rp_db_port'}'

    #get the container ip
    echo "docker exec -i rp ifconfig eth0 | grep inet addr | cut -d\":\" -f 2 | cut -d\" \" -f 1" 
    cmd="docker exec -i rp ifconfig eth0 | grep \"inet addr\" | cut -d\":\" -f 2 | cut -d\" \" -f 1"
    rp_host_name=$(eval $cmd)

    echo "docker exec -i redis-python \"python\" /usr/src/app/test_db.py $rp_host_name $rp_db_port"
    docker exec -i redis-python "python" /usr/src/app/test_db.py $rp_host_name $rp_db_port
}

cleanup(){ 
    echo ":: test_redir-py.sh:: cleanup()"

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
    docker rmi $(docker images -f "dangling=true" -q)
    for i in ${cleanup_images[@]}; do 
        echo $info_color"REMOVING CONTAINER IMAGE : "$no_color $i
        eval "docker rmi -f $i"; 
    done
}


### START HERE ###

echo ":: test_redir-py.sh"
echo $warning_color"WARNING"$no_color": This will wipe out all your containers and images [y/n]"
read yes_no

if [ $yes_no == 'y' ]
then
    #call test open source database
    test_oss_db
    #call test redis enterprise database
    test_enterprise_db
fi