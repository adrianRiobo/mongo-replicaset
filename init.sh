#!/bin/bash

waitForMongo() {
  echo "Checking $1 connection"
  until mongo $1 --eval "print(\"waited for connection\")"
  do
    echo "Waiting for $1"
    sleep 15
  done  
}

waitForCluster() {

 echo 'waiting for rs hosts available'
 waitForMongo $SECONDARY_01
 waitForMongo $SECONDARY_02
 waitForMongo $PRIMARY

}

configureRs() {

waitForCluster

echo 'Fill Replicaset info'
envsubst < /tmp/rs_initiate.js.template > /tmp/rs_initiate.js

echo 'Initalizing rs'
mongo /tmp/rs_initiate.js

}

startPrometheusExporter() {

waitForCluster
mongodb_exporter

}

#Hacky config background process executed once mongo is started
https://github.com/docker-library/mongo/issues/249#issuecomment-381786889
if $COORDINATOR ; then
    echo 'Es coordinador'
    configureRs &
fi

startPrometheusExporter &
