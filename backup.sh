#!/bin/sh
#########################################################################
#  created by Ismaila Baradji 2015/03/15
##########################################################################

DB_USER=$1
DB_USER_PWD=$2 
DB_TO_BACKUP=$3
HOST_DB=$4

#include config file
. ./config.sh

echo "----------------------------------DATABASE USER IS $DB_USER\n";
echo "----------------------------------DATABASE FOR BACKUP IS $DB_TO_BACKUP\n";
echo "----------------------------------HOST FOR BACKUP IS $HOST_DB\n" ;
echo "----------------------------------ARCHIVE_SERVER FOR BACKUP IS $ARCHIVE_SERVER\n"

# test si le nom le la base est passe en argument
#if [ Q${database} = Q ]
#then
#        echo  $0 database_name
#        exit
#fi
# date du jour pour nom de fichier
#jj=`date +%a`
jj=`date '+%d-%m-%y'`
#jj='Sun'
FIC=${jj}_$DB_TO_BACKUP.sql.gz
# backup de la base en mode compresse  ( gzip )
#mysqldump -u $DB_USER -p$DB_USER_PWD -h $HOST_DB --ignore-table=$DB_TO_BACKUP.mage_catalog_product_index_price_tmp $DB_TO_BACKUP | gzip > $FIC
mysqldump -u $DB_USER -p$DB_USER_PWD -h $HOST_DB --ignore-table=${DB_TO_BACKUP}.mage_catalog_product_index_price_tmp $DB_TO_BACKUP | gzip -c | ssh $ARCHIVE_USER@$ARCHIVE_SERVER "cat > $ARCHIVE_FOLDER/$FIC";