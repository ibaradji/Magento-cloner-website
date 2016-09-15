#!/bin/bash
#########################################################################
#  created by Ismaila Baradji 2015/03/15
# Description: Copy of the website A and past it to site B
##########################################################################
DBNAME=$1
DESTINATION_DB_USER_PWD=$2 
DBNAME=$3 
PATH_WEBSITE_TO=$4 
EMAILDEV=$5 
SOURCE_HOST_SCRIPT=$6 
SOURCE_HOST_DB=$7
WEBSITE_SOURCE=$8
DB_HOST_DEST=$9
jj=`date '+%d-%m-%y'`
#include config file
. ./config.sh
cd $PATH_WEBSITE_TO;


#backup the old file to restore it after the end of clone
cp html/.htaccess pmc_scripts/pmc_cloner_website/.htaccess

rm -rf html/var/cache;
rm -rf html/var/report;
tar -zcvf ${USER}_${jj}.tar.gz html;
rsync -avz -e ssh --remove-source-files ${USER}_${jj}.tar.gz $ARCHIVE_USER@$ARCHIVE_SERVER:$ARCHIVE_HTML_FOLDER/;
rm -rf html;
#copie rep html from source
rsync -avz --copy-links --exclude var/report/* --exclude var/cache/* --exclude html/media --exclude html/x-stuff --exclude var/tmp/* --exclude var/session/* -e ssh $WEBSITE_SOURCE@$SOURCE_HOST_SCRIPT:/www/sites/$WEBSITE_SOURCE/files/html $PATH_WEBSITE_TO;

#truncate log files
truncate -s 0 html/var/log/system.log;
truncate -s 0 html/var/log/exception.log;
truncate -s 0 html/var/log/PurolatorEstimates.log;

#replace local.xml file info
SOURCE_DB=$(grep -i -m 1 dbname html/app/etc/local.xml | cut -d[ -f3 | cut -d] -f1)
SOURCE_DB_PWD=$(grep -i -m 1 password html/app/etc/local.xml | cut -d[ -f3 | cut -d] -f1)
SOURCE_DB_HOST=$(grep -i -m 1 host html/app/etc/local.xml | cut -d[ -f3 | cut -d] -f1)

sed -i -- 's/'"$SOURCE_DB"'/'"$DBNAME"'/g' html/app/etc/local.xml
sed -i -- 's/'"$SOURCE_DB_PWD"'/'"$DESTINATION_DB_USER_PWD"'/g' html/app/etc/local.xml
sed -i -- 's/'"$SOURCE_DB_HOST"'/'"$DB_HOST_DEST"'/g' html/app/etc/local.xml

#replace params of purolator
sed -i -- 's/entrepot@company.com/'"$EMAILDEV"'/g' html/purolator/config.php
sed -i -- 's/entrepot@company.com/'"$EMAILDEV"'/g' html/purolator/config.php

#replace params of purolator
sed -i -- 's/entrepot@company.com/'"$EMAILDEV"'/g' html/app/code/local/PMC/Manutention/controllers/ManutentionController.php
sed -i -- 's/entrepot@company.com/'"$EMAILDEV"'/g' html/app/code/local/PMC/Manutention/controllers/ManutentionController.php

#Enable mysql log
#sed -i -- 's/protected #$_debug               = false/protected $_debug               = true/g' html/lib/Varien/Db/Adapter/Pdo/Mysql.php
#sed -i -- 's/protected #$_logAllQueries       = false/protected $_logAllQueries       = true/g' html/lib/Varien/Db/Adapter/Pdo/Mysql.php

#replace symbolic links

if [ "$USER" = 'f2.company.re' ] || [ "$USER" = 'f1.company.re' ]; then
{
    ln -s /www/sites/m1.company.re/files/html/f1-media html/media
    ln -s /www/sites/m1.company.re/files/html/x-stuff html/x-stuff
}
else {
    ln -s /www/sites/m2.company.re/files/html/dev-media html/media
    ln -s /www/sites/m2.company.re/files/html/x-stuff html/x-stuff
}
fi

#restore the htaccess for dev and test websites
cp pmc_scripts/pmc_cloner_website/.htaccess html/