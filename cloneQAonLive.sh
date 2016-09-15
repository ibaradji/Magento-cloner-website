#!/bin/sh
#########################################################
## Script to clone f1 or f2 website toward live
## cloneWebSite V 1.5
## Written by  Ismaila Baradji
## Create Date: 2016 , March
## Update Date: March, the 1st, 2016: by Ismaila
#########################################################
WEBSITE_SOURCE=$1

jj=`date '+%d-%m-%y'`
WEBSITE_TO='pmctire.com'

SCRIPT=$(readlink -f $0)
PWD=`dirname $SCRIPT`
CUT=$(which cut)
MYSQL=$(which mysql)
GREP=$(which grep)
SCRIPT_PATH=$PWD
echo $SCRIPT_PATH/;
#include config file
. $SCRIPT_PATH/config.sh
SOURCE_HOST_SCRIPT=$www02

cd $HOME/html
PWD=$(pwd)

SOURCEFILE=$PWD/app/etc/local.xml

if [ -f $SOURCEFILE ]
then
    DB_HOST_DEST=$($GREP -i -m 1 host $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
    PRE=$($GREP -i -m 1 table_prefix $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
    DESTINATION_DB_NAME=$($GREP -i -m 1 dbname $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
    DESTINATION_DB_USER=$($GREP -i -m 1 username $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
    DESTINATION_DB_USER_PWD=$($GREP -i -m 1 password $SOURCEFILE | $CUT -d[ -f3 | $CUT -d] -f1)
fi
echo "DESTINATION_DB_NAME is $DESTINATION_DB_NAME\n"
echo "WEBSITE_SOURCE is $WEBSITE_SOURCE\n"
echo "SOURCE_HOST_SCRIPT is $SOURCE_HOST_SCRIPT\n"

SOURCE_DB_NAME=$(grep -i -m 1 dbname /www/sites/$WEBSITE_SOURCE/html/app/etc/local.xml | cut -d[ -f3 | cut -d] -f1)
SOURCE_DB_USER=$(grep -i -m 1 username /www/sites/$WEBSITE_SOURCE/html/app/etc/local.xml | cut -d[ -f3 | cut -d] -f1)
SOURCE_DB_USER_PWD=$(grep -i -m 1 password /www/sites/$WEBSITE_SOURCE/html/app/etc/local.xml | cut -d[ -f3 | cut -d] -f1)
echo "SOURCE_DB_NAME is $SOURCE_DB_NAME\n" 

echo "*********************************************************************************************************************\n";
echo "******************************    1 -backup  *************************************\n";
echo "*********************************************************************************************************************\n";
echo "$jj Biginning of backup\n";
echo "                                                 \n";

echo "$jj backup live site\n";
echo "                                                 \n";

mysqldump -u $DESTINATION_DB_USER -p$DESTINATION_DB_USER_PWD -h $DB_HOST_DEST $DESTINATION_DB_NAME | gzip -c | ssh $ARCHIVE_USER@$ARCHIVE_SERVER "cat > $ARCHIVE_FOLDER/${jj}_$DESTINATION_DB_NAME.sql.gz";

echo "$jj backup source site\n";
echo "                                                 \n";
mysqldump -u $SOURCE_DB_USER -p$SOURCE_DB_USER_PWD -h $DB_HOST_DEST $SOURCE_DB_NAME | gzip -c | ssh $ARCHIVE_USER@$ARCHIVE_SERVER "cat > $ARCHIVE_FOLDER/${jj}_$SOURCE_DB_NAME.sql.gz";

echo "$jj backup of live script\n";
echo "                                                 \n";

cd $HOME/files
#tar -zcvf ${jj}_html.tar.gz html;

mv html backup/${jj}_html;


echo "*********************************************************************************************************************\n";
echo "******************************    2 -copy script and create symbolic links  *************************************\n";
echo "*********************************************************************************************************************\n";

echo "   2-1: - copy of html folder  \n";
rsync -avz --exclude var/report/* --exclude var/cache/* --exclude html/media --exclude html/js --exclude html/skin --exclude var/tmp/* --exclude var/session/* /www/sites/$WEBSITE_SOURCE/files/html /www/sites/live.pmctire.com/files/

echo "   2-2: Set the website on maintenance mode \n";
touch html/maintenance.flag

echo "   2-3: create the symbolic links \n";
mv /www/sites/m1.pmcti.re/files/html/live-js /www/sites/m1.pmcti.re/files/html/live-js_${jj}
mv /www/sites/m1.pmcti.re/files/html/live-skin /www/sites/m1.pmcti.re/files/html/live-skin_${jj}

#source informations
if [ "$WEBSITE_SOURCE" = "f1.pmcti.re" ];
    then
        cp -r /www/sites/m1.pmcti.re/files/html/f1-js /www/sites/m1.pmcti.re/files/html/live-js
        cp -r /www/sites/m1.pmcti.re/files/html/f1-skin /www/sites/m1.pmcti.re/files/html/live-skin

    else {
        cp -r /www/sites/m1.pmcti.re/files/html/f2-js /www/sites/m1.pmcti.re/files/html/live-js
        cp -r /www/sites/m1.pmcti.re/files/html/f2-skin /www/sites/m1.pmcti.re/files/html/live-skin              
    }
fi

#create the symbolic links
ln -s /www/sites/m1.pmcti.re/files/html/live-js /www/sites/live.pmctire.com/files/html/js
ln -s /www/sites/m1.pmcti.re/files/html/live-skin /www/sites/live.pmctire.com/files/html/skin
ln -s /www/sites/m1.pmcti.re/files/html/live-media /www/sites/live.pmctire.com/files/html/media

echo "   2-4: copy of tmp pdf \n";
cp -r backup/${jj}_html/var/tmp html/var/;

echo "*********************************************************************************************************************\n";
echo "******************************    3 -restore the database  *************************************\n";
echo "*********************************************************************************************************************\n";

echo "-----------   3-1: Deleting of all tables   -----------------------\n";
sh clean_before_restore.sh $DESTINATION_DB_USER $DESTINATION_DB_USER_PWD $DESTINATION_DB_NAME $DB_HOST_DEST
echo "-----------end of Deleting of all tables-----------------------\n";

echo "                                                                     \n";
echo "-----------3-2: Begin of restoring db-----------------------\n";
sh restore_backup.sh $DESTINATION_DB_USER $DESTINATION_DB_USER_PWD $DESTINATION_DB_NAME $DB_HOST_DEST $SOURCE_DB_NAME
echo "-----------end of restoring db-----------------------\n";

echo "-----------3-3: restoring live db parameters-----------------------\n";
sed -i -- 's/siteinternet/'"$WEBSITE_TO"'/g' live_after_restaure.sql;
mysql -u $DESTINATION_DB_USER -p$DESTINATION_DB_USER_PWD -h $DB_HOST_DEST $DESTINATION_DB_NAME < "live_after_restaure.sql";

    
echo "Remove the file maintenance.flag \n"
rm -f html/maintenance.flag
ff=`date`
echo "***************************************************************************************************";
echo "*************       END OF MIGRATION OF LIVE WEBSITE at $ff   BYE BYE  ************";
echo "*************************************************************************************************";  