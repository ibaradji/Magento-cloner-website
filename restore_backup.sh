#!/bin/sh
#########################################################################
#  created by Ismaila Baradji 2015/03/15
##########################################################################
DESTINATION_DB_USER=$1 
DESTINATION_DB_USER_PWD=$2 
DESTINATION_DB_NAME=$3
DB_HOST_DEST=$4 
SOURCE_DB_NAME=$5

#include config file
. ./config.sh

# test si le nom le la base est passe en argument
#if [ Q${database} = Q ]
#then
#        echo  $0 please, give database_name as param
#        exit
#fi
# date du jour pour nom de fichier
#jj=`date +%a`
jj=`date '+%d-%m-%y'`
#jj='Sun'
FIC=${jj}_${SOURCE_DB_NAME}.sql.gz
echo "your backup file is ${FIC}\n"
echo "your db user is $DESTINATION_DB_USER\n"
echo "your db host is $DB_HOST_DEST\n"
echo "your db is $DESTINATION_DB_NAME\n"

# restore the database after uncompressit
rsync -avz -e ssh $ARCHIVE_USER@$ARCHIVE_SERVER:$ARCHIVE_FOLDER/$FIC .;
gunzip < $FIC | mysql -u $DESTINATION_DB_USER -p$DESTINATION_DB_USER_PWD -f -h $DB_HOST_DEST $DESTINATION_DB_NAME;
rm $FIC;
