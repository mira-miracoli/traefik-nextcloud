#!/bin/bash
#Backup Script

## GLOBAL VARS
    DATABASEUSER="root" # Datenbankbenutzer
    LVNAME="/dev/backup/mysql" # zu sicherndes Verzeichnis
    BACKUP_DIR="/media/mysql"

## MOUNT
    umount $LVNAME
    mount $LVNAME $BACKUP_DIR
    cd $BACKUP_DIR

## CREATE CREDENTIALS FILE
    credentialsFile=./mysql-credentials.cnf
    echo "[client]" > $credentialsFile
    echo "user=$DATABASEUSER" >> $credentialsFile
    echo "password=$(cat /home/ubuntu/docker/secrets/mysql_root_password)" >> $credentialsFile
    echo "host=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mariadb)" >> $credentialsFile

## DUMP ALL DATABASES
    for DB in $(mysql --defaults-extra-file=$credentialsFile -e 'show databases' -s --skip-column-names); do
        mysqldump --defaults-extra-file=$credentialsFile --skip-lock-tables --column-statistics=0 --compact $DB | gzip > "./$DB-$(date +%Y%m%d).sql.gz"
    done
    rm ./mysql-credentials.cnf

## ROTATE >30 DAYS
    bak_files=`ls ./*.sql.gz`
    for bak in $bak_files; do
        bak_name=`echo $bak`
        bak_date=`echo $bak_name | cut -d'-' -f2- | cut -d'.' -f1`
        if [[ "$bak_date" < "$(date +%Y%m%d -d "30 days ago")" ]] ; then
                rm $bak
        fi
    done

## UNMOUNT
    cd /
    umount $BACKUP_DIR

