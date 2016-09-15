#!/bin/bash

MYSQL='mysql -u '"$1"' -p'"$2"' -h '"$4"' -D '"$3"''
$MYSQL -BNe "show tables" | awk '{print "set foreign_key_checks=0; drop table `" $1 "`;"}' | $MYSQL
unset MYSQL