#!/bin/sh
#########################################################
## Script to clone A website to dev or qa
## cloneWebSite V 1.3
## Written by  Ismaila Baradji
## Create Date: 2016 , January
## Update Date: January, the 15th, 2016: by Ismaila
#########################################################

ROLLBACK_DATABASE=$1
ROLLBACK_HTML=$2

#include config file
. ./config.sh

SCRIPT=$(readlink -f $0)
PWD=`dirname $SCRIPT`
CUT=$(which cut)
GREP=$(which grep)
SCRIPT_PATH=$PWD
echo $SCRIPT_PATH/;

HTML_HOME=$HOME/html
cd $HTML_HOME
if [ -f $HTML_HOME/app/etc/local.xml ]
then
    SOURCEFILE=$HTML_HOME/app/etc/local.xml

    if [ -f $SOURCEFILE ]
    then
        DBHOST=$($GREP -i -m 1 host $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
        PRE=$($GREP -i -m 1 table_prefix $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
        DBNAME=$($GREP -i -m 1 dbname $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
        USERNAME=$($GREP -i -m 1 username $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
        USERNAME_PWD=$($GREP -i -m 1 password $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
        
    fi

    if [ "$USER" = "m1.pmcti.re" ] || [ "$USER" = "m1.pmcti.re" ];
        then
            echo "  -----Attention, ceci est un site de stockage, pas de clonage sur ce site -------------";

    else {    
        if [ "$ROLLBACK_HTML" = "true" ] ; then
        {
            echo "   beginning of Rollback du repertoire HTML "
            cd $HOME/files/
            rm -rf html;
            tar xzvf html.tar.gz; 
            rm -f html/maintenance.flag
        }
        fi
        
        if [ "$ROLLBACK_DATABASE" = "true" ] ; then
        {
            echo "   beginning of Rollback of database "
            jj=`date '+%d-%m-%y'`
            FIC=${jj}_${DBNAME}.sql.gz
            # restore the database after unzip
            rsync -avz -e ssh $ARCHIVE_USER@$ARCHIVE_SERVER:$ARCHIVE_FOLDER/$FIC .;
            gunzip < $FIC | mysql -u $USERNAME -p$USERNAME_PWD -h $DBHOST $DBNAME;
            rm $FIC;
        }
        fi
    }
    fi
else
    clear;
    echo -e "Could not find your app/etc/local.xml File";
    read -ep "Location of local.xml file: " _file
    SOURCEFILE=$_file
fi