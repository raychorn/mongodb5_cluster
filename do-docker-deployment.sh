#!/bin/bash

PWD=$(pwd)
DIR0=$(dirname $0)
ENV=$DIR0/../.env

if [ "$DIR0." == ".." ]; then
    DIR0=$PWD
fi
echo "DIR0=$DIR0"
echo "PWD=$PWD"

if [ -f "$ENV" ]; then
    echo "Importing environment variables."
    export $(cat $ENV | sed 's/#.*//g' | xargs)
    echo "Done importing environment variables."
else
    echo "ERROR: Environment variables not found. Please run the following command to generate them:"
    exit 1
fi

TUNNELPORTTEST=$(netstat -tunlp | grep $DOCKER_PORT)
echo "TUNNELPORTTEST=$TUNNELPORTTEST"

if [ ! -z "$TUNNELPORTTEST" ]; then
    LINES=$(ps -aux | grep $REMOTE_DOCKER)
    while read -r line; do
        PID=$(echo $line | awk '{print $2}')
        echo "(***) TUNNELTEST:$TUNNELTEST"
        if [ ! -z "$PID" ]; then 
            echo "Killing the old ssh tunnel for $REMOTE_DOCKER"
            kill -9 $PID
        fi
    done <<< "$LINES"
fi

TUNNELPORTTEST=$(netstat -tunlp | grep $DOCKER_PORT)
echo "TUNNELPORTTEST=$TUNNELPORTTEST"

if [ "$TUNNELPORTTEST." = '.' ]; then
    echo "No tunnel active, so setting one up -> $DOCKER_PORT:$REMOTE_DOCKER @ $USER_IP_ADDR_SERVER1."
    nohup ssh -NL $DOCKER_PORT:$REMOTE_DOCKER -i $PRIVKEY $USER_IP_ADDR_SERVER1 > nohup.out 2> nohup.err < /dev/null &
    echo "Sleeping to allow the tunnel to form."
    sleep 10
fi

TUNNELPORTTEST=$(netstat -tunlp | grep $DOCKER_PORT)
echo "TUNNELPORTTEST=$TUNNELPORTTEST"

if [ "$TUNNELPORTTEST." = '.' ]; then
    echo "No tunnel active, so cannot continue."
    exit 1
fi

TEST=$(docker context ls | grep $DOCKER_CONTEXT)
echo "TEST=$TEST"

if [ "$TEST." = '.' ]; then
    COUNTER=1
    for i in {1..5}
    do   
        echo $COUNTER;
        echo "No context found so creating the context. (DOCKER_CONTEXT:$DOCKER_CONTEXT) (DOCKER_PORT:$DOCKER_PORT)"
        echo docker context create $DOCKER_CONTEXT --docker \"host=tcp://127.0.0.1:$DOCKER_PORT\"
        docker context create mongocontext --docker "host=tcp://127.0.0.1:12375"
        sleep 5
        TEST=$(docker context ls | grep $DOCKER_CONTEXT)
        echo "TEST=$TEST"
        if [ "$TEST." != '.' ]; then
            docker context use $DOCKER_CONTEXT
            break
        fi
        sleep 5
        ((COUNTER++));
    done
else
    echo "Found context so using it."
    docker context use $DOCKER_CONTEXT
fi

TEST2=$(docker ps | grep portainer)

if [ "$TEST2." = '.' ]; then
    echo "Could not connect to the remote context, so cannot continue.  Please check your config and try again, maybe."
    exit 1
fi

exit

docker service create --limit-cpu "4.0" --limit-memory "2g" --dns "109.201.133.196" --reserve-cpu "3.0" --reserve-memory "512m" --replicas 1 --network host --mount type=volume,source=mongodata1,target=/data/db --mount type=volume,source=mongoconf1,target=/etc/mongod.conf  --mount type=volume,source=mongoconfigdb1,target=/data/configdb --mount type=volume,source=mongocerts1,target=/mongocerts --mount type=volume,source=mongologs1,target=/var/log/mongodb --constraint 'node.hostname == server1' --name mongo1 mongo:5.0.1-focal --replSet "rs0" --auth --keyFile "/mongocerts/keyfile.txt" #--config "/etc/mongod.conf/mongod.conf"
docker service create --limit-cpu "4.0" --limit-memory "2g" --dns "109.201.133.196" --reserve-cpu "3.0" --reserve-memory "512m" --replicas 1 --network host --mount type=volume,source=mongodata2,target=/data/db --mount type=volume,source=mongoconf2,target=/etc/mongod.conf  --mount type=volume,source=mongoconfigdb2,target=/data/configdb --mount type=volume,source=mongocerts2,target=/mongocerts --mount type=volume,source=mongologs2,target=/var/log/mongodb --constraint 'node.hostname == tp01-2066' --name mongo2 mongo:5.0.1-focal --replSet "rs0" --auth --keyFile "/mongocerts/keyfile.txt" #--config "/etc/mongod.conf/mongod.conf"
docker service create --limit-cpu "4.0" --limit-memory "2g" --dns "109.201.133.196" --reserve-cpu "3.0" --reserve-memory "512m" --replicas 1 --network host --mount type=volume,source=mongodata_docker1,target=/data/db --mount type=volume,source=mongoconf_docker1,target=/etc/mongod.conf  --mount type=volume,source=mongoconfigdb_docker1,target=/data/configdb --mount type=volume,source=mongocerts_docker1,target=/mongocerts --mount type=volume,source=mongologs_docker1,target=/var/log/mongodb --constraint 'node.hostname == docker1' --name mongo3 mongo:5.0.1-focal --replSet "rs0" --auth --keyFile "/mongocerts/keyfile.txt" #--config "/etc/mongod.conf/mongod.conf"
docker service create --limit-cpu "4.0" --limit-memory "2g" --dns "109.201.133.196" --reserve-cpu "3.0" --reserve-memory "512m" --replicas 1 --network host --mount type=volume,source=mongodata_docker2,target=/data/db --mount type=volume,source=mongoconf_docker2,target=/etc/mongod.conf  --mount type=volume,source=mongoconfigdb_docker2,target=/data/configdb --mount type=volume,source=mongocerts_docker2,target=/mongocerts --mount type=volume,source=mongologs_docker2,target=/var/log/mongodb --constraint 'node.hostname == docker2' --name mongo4 mongo:5.0.1-focal --replSet "rs0" --auth --keyFile "/mongocerts/keyfile.txt" #--config "/etc/mongod.conf/mongod.conf"

#CID=$(docker ps -qf "name=$cname")
#echo "CID=$CID"
