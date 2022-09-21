#!/bin/bash
#Backup Script

    DATABASE="bookstore" # Datenbankname
    DATABASEUSER="root" # Datenbankbenutzer
    LVNAME="/dev/backup/mysql" # zu sicherndes Verzeichnis
    BACKUP_DIR="/media/mysql"

    umount $LVNAME
    mount $LVNAME $BACKUP_DIR
		$db_ip = `docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mariadb`
    $db_login = `-h$db_ip -u$DATABASEUSER -p$(cat /home/ubuntu/docker/secrets/mysql_root_password)`
		for DB in $(mysql $db_login -e 'show databases' -s --skip-column-names); do
				mysqldump $DB > "$BACKUP_DIR/$DB-$(date +%Y%m%d).sql" $db_login
		done
		$bak_files = `ls $BACKUP_DIR/*.sql`
		for bak in $bak_files; do
			$bak_date = `echo $bak | cut -d'/' -f3- | cut -d'-' -f2- | cut -d'.' -f1`
			if [[$bak_date < $(date +%Y%m%d -d "30 days ago")]]; then
				rm $bak
			fi
		done
    umount /dev/backup/pi

