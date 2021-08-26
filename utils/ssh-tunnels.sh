#!/usr/bin/bash

PRIVKEY=~/.ssh/id_rsa_desktop-JJ95ENL_no_passphrase

SSHTUNNEL_65117=65117
SSHTUNNEL_SERVER1=$SSHTUNNEL_65117:127.0.0.1:27017
PRIVKEY_SERVER1=$PRIVKEY
USER_IP_ADDR_SERVER1=raychorn@10.0.0.179

TUNNELPORTTEST_SERVER1=$(netstat -tunlp | grep $SSHTUNNEL_65117)
echo "TUNNELPORTTEST_SERVER1=$TUNNELPORTTEST_SERVER1"

if [ "$TUNNELPORTTEST_SERVER1." != '.' ]; then
    PID=$(ps -aux | grep $SSHTUNNEL_SERVER1 | awk '{print $2}' | head -1)
    echo "PID=$PID - looks like the tunnel for $SSHTUNNEL_SERVER1 is active so cannot continue."
    #exit 1
    sudo kill -9 $PID
fi

SSHTUNNEL_65217=65217
SSHTUNNEL_TP012066=$SSHTUNNEL_65217:127.0.0.1:27017
PRIVKEY_TP012066=$PRIVKEY
USER_IP_ADDR_TP012066=raychorn@10.0.0.239

TUNNELPORTTEST_TP012066=$(netstat -tunlp | grep $SSHTUNNEL_65217)
echo "TUNNELPORTTEST_TP012066=$TUNNELPORTTEST_TP012066"

if [ "$TUNNELPORTTEST_TP012066." != '.' ]; then
    PID=$(ps -aux | grep $SSHTUNNEL_TP012066 | awk '{print $2}' | head -1)
    echo "PID=$PID - looks like the tunnel for $SSHTUNNEL_TP012066 is active so cannot continue."
    #exit 1
    sudo kill -9 $PID
fi

SSHTUNNEL_65317=65317
SSHTUNNEL_DOCKER1=$SSHTUNNEL_65317:127.0.0.1:27017
PRIVKEY_DOCKER1=$PRIVKEY
USER_IP_ADDR_DOCKER1=raychorn@10.0.0.233

TUNNELPORTTEST_DOCKER1=$(netstat -tunlp | grep $SSHTUNNEL_65317)
echo "TUNNELPORTTEST_DOCKER1=$TUNNELPORTTEST_DOCKER1"

if [ "$TUNNELPORTTEST_DOCKER1." != '.' ]; then
    PID=$(ps -aux | grep $SSHTUNNEL_DOCKER1 | awk '{print $2}' | head -1)
    echo "PID=$PID - looks like the tunnel for $SSHTUNNEL_DOCKER1 is active so cannot continue."
    #exit 1
    sudo kill -9 $PID
fi

SSHTUNNEL_65417=65417
SSHTUNNEL_DOCKER2=$SSHTUNNEL_65417:127.0.0.1:27017
PRIVKEY_DOCKER2=$PRIVKEY
USER_IP_ADDR_DOCKER2=raychorn@10.0.0.240

TUNNELPORTTEST_DOCKER2=$(netstat -tunlp | grep $SSHTUNNEL_65417)
echo "TUNNELPORTTEST_DOCKER2=$TUNNELPORTTEST_DOCKER2"

if [ "$TUNNELPORTTEST_DOCKER2." != '.' ]; then
    PID=$(ps -aux | grep $SSHTUNNEL_DOCKER2 | awk '{print $2}' | head -1)
    echo "PID=$PID - looks like the tunnel for $SSHTUNNEL_DOCKER2 is active so cannot continue."
    #exit 1
    sudo kill -9 $PID
fi
#exit
while [ true ]; do
    TUNNELPORTTEST_SERVER1=$(netstat -tunlp | grep $SSHTUNNEL_65117)
    ## server1.web-service.org
    #_mongodb._tcp.mongodb-cluster1.web-service.org	SRV	0 0 65117 127.0.0.1	10m
    if [ "$TUNNELPORTTEST_SERVER1." != '.' ]; then
        echo "TUNNELPORTTEST_SERVER1:$TUNNELPORTTEST_SERVER1"
    else
        echo "Starting ssh-tunnel for $USER_IP_ADDR_SERVER1"
        nohup ssh -NL $SSHTUNNEL_SERVER1 -i "$PRIVKEY_SERVER1" $USER_IP_ADDR_SERVER1 </dev/null >/dev/null 2>&1 &
    fi

    TUNNELPORTTEST_TP012066=$(netstat -tunlp | grep $SSHTUNNEL_65217)
    ## tp01-2066.web-service.org
    #_mongodb._tcp.mongodb-cluster1.web-service.org	SRV	0 0 65217 127.0.0.1	10m
    if [ "$TUNNELPORTTEST_TP012066." != '.' ]; then
        echo "TUNNELPORTTEST_TP012066:$TUNNELPORTTEST_TP012066"
    else
        echo "Starting ssh-tunnel for $USER_IP_ADDR_TP012066"
        nohup ssh -NL $SSHTUNNEL_TP012066 -i "$PRIVKEY_TP012066" $USER_IP_ADDR_TP012066 </dev/null >/dev/null 2>&1 &
    fi

    TUNNELPORTTEST_DOCKER1=$(netstat -tunlp | grep $SSHTUNNEL_65317)
    ## docker1.web-service.org
    #_mongodb._tcp.mongodb-cluster1.web-service.org	SRV	0 0 65317 127.0.0.1	10m
    if [ "$TUNNELPORTTEST_DOCKER1." != '.' ]; then
        echo "TUNNELPORTTEST_DOCKER1:$TUNNELPORTTEST_DOCKER1"
    else
        echo "Starting ssh-tunnel for $USER_IP_ADDR_DOCKER1"
        nohup ssh -NL $SSHTUNNEL_DOCKER1 -i "$PRIVKEY_DOCKER1" $USER_IP_ADDR_DOCKER1 </dev/null >/dev/null 2>&1 &
    fi

    TUNNELPORTTEST_DOCKER2=$(netstat -tunlp | grep $SSHTUNNEL_65417)
    ## docker2.web-service.org
    #_mongodb._tcp.mongodb-cluster1.web-service.org	SRV	0 0 65417 127.0.0.1	10m
    if [ "$TUNNELPORTTEST_DOCKER2." != '.' ]; then
        echo "TUNNELPORTTEST_DOCKER2:$TUNNELPORTTEST_DOCKER2"
    else
        echo "Starting ssh-tunnel for $USER_IP_ADDR_DOCKER2"
        nohup ssh -NL $SSHTUNNEL_DOCKER2 -i "$PRIVKEY_DOCKER2" $USER_IP_ADDR_DOCKER2 </dev/null >/dev/null 2>&1 &
    fi
    echo "Sleeping..."
    sleep 10
done

