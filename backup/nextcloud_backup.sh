#!/bin/bash
#Backup Script

## GLOBAL VARS
    LVNAME="/dev/backup/nextcloud" # zu sicherndes Verzeichnis
    BACKUP_DIR="/media/nextcloud-backup"
    CONTAINER="nextcloud-app"
     

## MOUNT
    umount $LVNAME
    mount $LVNAME $BACKUP_DIR
    cd $BACKUP_DIR

## Switch to maintenance mode
    docker exec -u www-data -it $CONTAINER /usr/local/bin/php occ maintenance:mode --on

## RSYNC
    rsync -Aavx /media/nextcloud/nextclouddata nextcloud-dirbkp_`date +"%Y%m%d"`/

## ROTATE >7 DAYS
    bak_files=`ls ./nextcloud-dirbkp_*`
    for bak in $bak_files; do
        bak_name=`echo $bak`
        bak_date=`echo $bak_name | cut -d'-' -f2- | cut -d'_' -f2`
        if [[ "$bak_date" < "$(date +%Y%m%d -d "7 days ago")" ]] ; then
                rm -rf $bak
        fi
    done

## Switch to normal mode
    docker exec -u www-data -it $CONTAINER /usr/local/bin/php occ maintenance:mode --off

## UNMOUNT
    cd /
    umount $BACKUP_DIR

