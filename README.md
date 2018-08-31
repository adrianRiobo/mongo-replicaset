# mongo-replicaset

## Description

Mongo 3 replicaset with prometheus exporter. 

Initial aproximation for mongo image with initial scripts for create a replicaset with 3 hosts. This will be expanded into N hosts.

## Mongo exporter

This image is builded as multistage with an exporter constructor to enable export metrics for prometheus. The exported used is from [percona project](https://github.com/percona/mongodb_exporter)

## Usage 

As initial approach we just use a 3 node replicaset so they have fixed identifications

**COORDINATOR** Set to true in one node (it will initiate the replicaset)  
**PRIMARY** node 1 IP:PORT  
**SECONDARY_01** node 2 IP:PORT  
**SECONDARY_02** node 3 IP:PORT  

