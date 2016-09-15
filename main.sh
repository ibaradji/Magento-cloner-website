#!/bin/sh
#########################################################
## Script to clone a website A toward B
## cloneWebSite V 1.2
## Written by  Ismaila Baradji
## Create Date: 2015 , March
## Update Date: January, the 11th, 2016: by Ismaila
#########################################################
BACKUP=$2
RESTORE=$3 
COPY=$4
CLEAN_DB_INFO=$5 
WEBSITE_SOURCE=$6
NO_MERGE_CSS_JS=$7



SCRIPT=$(readlink -f $0)
PWD=`dirname $SCRIPT`
CUT=$(which cut)
MYSQL=$(which mysql)
GREP=$(which grep)
SCRIPT_PATH=$PWD
echo $SCRIPT_PATH/;
#include config file
. $SCRIPT_PATH/config.sh

HTML_HOME=$HOME/html
cd $HTML_HOME


SOURCEFILE=$HTML_HOME/app/etc/local.xml

if [ -f $SOURCEFILE ]
then
    DB_HOST_DEST=$($GREP -i -m 1 host $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
    PRE=$($GREP -i -m 1 table_prefix $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
    DESTINATION_DB_NAME=$($GREP -i -m 1 dbname $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
    DESTINATION_DB_USER=$($GREP -i -m 1 username $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
    DESTINATION_DB_USER_PWD=$($GREP -i -m 1 password $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
fi

#source informations
if [ "$WEBSITE_SOURCE" = "live.pmctire.com" ] || [ "$WEBSITE_SOURCE" = "f1.pmcti.re" ]|| [ "$WEBSITE_SOURCE" = "f2.pmcti.re" ];
            then
                echo"  La source est sur le serveur de production -------------\n";
                SOURCE_HOST_DB=$db01
                SOURCE_HOST_SCRIPT=$www02
                           
            else {
                echo "  La source est sur le serveur de DEV -------------\n";
                SOURCE_HOST_DB=$vm_dev01
                SOURCE_HOST_SCRIPT=$vm_dev01              
            }
fi

echo "WEBSITE_SOURCE is $WEBSITE_SOURCE\n"
echo "SOURCE_HOST_SCRIPT is $SOURCE_HOST_SCRIPT\n"

SOURCE_DB_NAME=$(ssh $WEBSITE_SOURCE@$SOURCE_HOST_SCRIPT "grep -i -m 1 dbname html/app/etc/local.xml | cut -d[ -f3 | cut -d] -f1")
SOURCE_DB_USER=$(ssh $WEBSITE_SOURCE@$SOURCE_HOST_SCRIPT "grep -i -m 1 username html/app/etc/local.xml | cut -d[ -f3 | cut -d] -f1")
SOURCE_DB_USER_PWD=$(ssh $WEBSITE_SOURCE@$SOURCE_HOST_SCRIPT "grep -i -m 1 password html/app/etc/local.xml | cut -d[ -f3 | cut -d] -f1")

cd $SCRIPT_PATH
    jj=`date`
    echo "*********************************************************************************************************************\n";
    echo "******************************    MISE A JOUR DU SITE B PARTIR DU SITE SOURCE A  *************************************\n";
    echo "*********************************************************************************************************************\n";
    echo "$jj Biginning of the script\n";
    echo "                                                 \n";

    echo "*********************               Information sur le site de dev ou test a remplacer.      ****************\n";
    WEBSITE_TO="$USER";
    PATH_WEBSITE_TO='/www/sites/'"$WEBSITE_TO"'/files/'

    #echo "Donner le nom du repertoire media sur m1.pmcti.re SVP: exemple: dev-media : "
    #read MEDIAFOLDER

    echo 'Mettre le site '"$WEBSITE_TO"' en mode maintenance\n'
    MAINTENANCE_FLAG='/www/sites/'"$WEBSITE_TO"'/files/html/maintenance.flag'
    touch $MAINTENANCE_FLAG;

    echo "___________________________1st step:         backup the database of the site A before restore to B________________________________________________\n";
    echo "Voulez-vous faire le backup de la bd du site A d'Abord? y/n:[default no] \n"
    #read ouinon
    if [ "$BACKUP" = "true" ] ; then
    {   
        echo "----------- begining of backup source database -----------------------\n";
        sh backup.sh $SOURCE_DB_USER $SOURCE_DB_USER_PWD $SOURCE_DB_NAME $SOURCE_HOST_DB;

        echo "----------- begining of backup destination database -----------------------\n";
        sh backup.sh $DESTINATION_DB_USER $DESTINATION_DB_USER_PWD $DESTINATION_DB_NAME $DB_HOST_DEST;
        echo "-----------end of backup source db -----------------------\n";
    }
    else echo "Ok, pas de backup, assurez vous que la backup du jour exist avant de faire un restore! \n"
    fi
    echo "                                                                     \n";

    echo "_________________________2nd step: **** Restore the db *********_______________________________________\n";
    echo "Voulez-vous restaurer la bd du site source A sur la bd $DESTINATION_DB_NAME ? y/n:[default no] \n"
    #read ouinon
    if [ "$RESTORE" = "true" ] ; then
    {   
        cd $SCRIPT_PATH
        echo "-----------Deleting of all tables-----------------------\n";
        sh clean_before_restore.sh $DESTINATION_DB_USER $DESTINATION_DB_USER_PWD $DESTINATION_DB_NAME $DB_HOST_DEST
        echo "-----------end of Deleting of all tables-----------------------\n";

        echo "                                                                     \n";
        echo "-----------begin of restoring db-----------------------\n";
        sh restore_backup.sh $DESTINATION_DB_USER $DESTINATION_DB_USER_PWD $DESTINATION_DB_NAME $DB_HOST_DEST $SOURCE_DB_NAME
        echo "-----------end of restoring db-----------------------";

        echo "                                                                     ";
        echo "________________________4rd step: set db params________________________________________________________\n";
        echo "replace database info in the sql file\n"
        #replace params of db
        
        if [ "$CLEAN_DB_INFO" = "true" ] ; then
            echo "-----------Clean customers and orders -----------------------\n";
            sed -i -- 's/siteinternet/'"$WEBSITE_TO"'/g' clean_after_db_info.sql;
            mysql -u $DESTINATION_DB_USER -p$DESTINATION_DB_USER_PWD -h $DB_HOST_DEST $DESTINATION_DB_NAME < "clean_after_db_info.sql";
        else
            echo "-----------Dont clean customers and orders -----------------------\n";
            sed -i -- 's/siteinternet/'"$WEBSITE_TO"'/g' clean_after_db.sql;
            mysql -u $DESTINATION_DB_USER -p$DESTINATION_DB_USER_PWD -h $DB_HOST_DEST $DESTINATION_DB_NAME < "clean_after_db.sql";
        fi


        #replace original name after clean db
        sed -i -- 's/'"$WEBSITE_TO"'/siteinternet/g' clean_after_db.sql;
        sed -i -- 's/'"$WEBSITE_TO"'/siteinternet/g' clean_after_db_info.sql;

        echo "-----------end of set db params-----------------------\n";
    }
    else echo "Ok, pas de restauration! \n"
    fi

    echo "                                                                     \n";
    echo "________________________4th step B: Merging files css and js_____________________________________\n";
    # set to zero for not allow merging css and js files
    if [ "$NO_MERGE_CSS_JS" = "true" ] ; then
        echo "-----------Dont merge the js and css files -----------------------\n";
        mysql -u $DESTINATION_DB_USER -p$DESTINATION_DB_USER_PWD -h $DB_HOST_DEST $DESTINATION_DB_NAME -e "UPDATE mage_core_config_data SET value=0 where path like '%merge%'";
    else
        echo "-----------Merge the js and css files -----------------------\n";
        mysql -u $DESTINATION_DB_USER -p$DESTINATION_DB_USER_PWD -h $DB_HOST_DEST $DESTINATION_DB_NAME -e "UPDATE mage_core_config_data SET value=1 where path like '%merge%'";
    fi

    echo "                                                                     \n";
    echo "________________________5th step: Copie of site A script html folder and change params_________________________________________________\n";
    echo 'Voulez-vous copier le script du site A sur '"$PATH_WEBSITE_TO"' ?  y/n:[default no] \n'
    read ouinon
    if [ "$COPY" = "true" ] ; then
    {
        echo "-----------copie sur le site $USER-----------------------\n";
        sh copySite.sh $DESTINATION_DB_NAME $DESTINATION_DB_USER_PWD $DESTINATION_DB_NAME $PATH_WEBSITE_TO $EMAILDEV $SOURCE_HOST_SCRIPT $SOURCE_HOST_DB $WEBSITE_SOURCE $DB_HOST_DEST

        echo "-----------end of copy of web site-----------------------\n";
    }
    else echo "Ok, pas de copie du script! \n"
    fi
    
    echo "Remove the file maintenance.flag \n"
    rm -f $MAINTENANCE_FLAG
    ff=`date`
    echo "***************************************************************************************************";
    echo "*************       FIN MISE A JOUR DU SITE $WEBSITE_TO, a $ff   BYE BYE  ************";
    echo "*************************************************************************************************";   
