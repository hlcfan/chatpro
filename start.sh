#!/bin/sh
mongod --dbpath=/data/mongodb/data/ --logpath=/data/mongodb/logs/mongod.log --logappend &
redis-server &
nohup juggernaut &
