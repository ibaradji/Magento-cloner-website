#!/bin/sh
#########################################################
## Script to clone A website to dev or qa
## cloneWebSite V 1.2
## Written by  Ismaila Baradji
## Create Date: 2015 , March
## Update Date: December, the 11th, 2015: by Ismaila
## test 2
#########################################################
BACKUP=$1
RESTORE=$2 
COPY=$3
CLEAN_DB_INFO=$4 
WEBSITE_SOURCE=$5
NO_MERGE_CSS_JS=$6

#include config file
. ./config.sh

if [ -z $BACKUP ] || [ -z $RESTORE ] || [ -z $COPY ] || [ -z $CLEAN_DB_INFO ] || [ -z $WEBSITE_SOURCE ]
then
  echo "sorry you missed a param: exemple: sh Run.sh true true true true b1.pmct.re"
  exit 2
else
    SCRIPT=$(readlink -f $0)
    PWD=`dirname $SCRIPT`
    CUT=$(which cut)
    MYSQL=$(which mysql)
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
            HOST=$($GREP -i -m 1 host $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
            PRE=$($GREP -i -m 1 table_prefix $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
            DBNAME=$($GREP -i -m 1 dbname $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
            USERNAME_PWD=$($GREP -i -m 1 password $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
            USERNAME=$($GREP -i -m 1 username $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
        fi

        if [ "$USER" = "live.company.com" ] || [ "$DBNAME" = "livecompany" ]|| [ "$USERNAME" = "livecompany" ];
            then
                echo "  -----Attention, ceci est le site live, pas de clonage sur ce site -------------";

            else {
                if [ "$HOST" = "$db01" ]; then
                    {
                        echo "-----------Vous etes sur le server www02.company.ml.zerolag.com pour cloner sur un site de QA -----------------------";
                        sh $SCRIPT_PATH/main.sh qa $BACKUP $RESTORE $COPY $CLEAN_DB_INFO $WEBSITE_SOURCE $NO_MERGE_CSS_JS
                    }
                    else {
                        echo "-----------Vous etes sur le server vm_dev01.company.ml.zerolag.com pour cloner sur un site de DEV "
                        sh $SCRIPT_PATH/main.sh dev $BACKUP $RESTORE $COPY $CLEAN_DB_INFO $WEBSITE_SOURCE $NO_MERGE_CSS_JS
                    }
                fi
            }
        fi
    else
        clear;
        echo "Could not find your app/etc/local.xml File\n";
        read -ep "Location of local.xml file: " _file
        SOURCEFILE=$_file
    fi
fi