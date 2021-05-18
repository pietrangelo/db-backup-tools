#!/usr/bin/env bash

## Set required vars
NOW="$(date +"%Y-%m-%d-%H")"
BACKUP_PATH=/var/backup/mysql

## Check if are there already older backups
mkdir -p "${BACKUP_PATH}"
if [ "$(ls -A ${BACKUP_PATH})" ]; then
    echo "Deleting older backups"
    rm -f ${BACKUP_PATH}/*
fi

## Start backup of Mysql DBs
for DB in $(mysql -u"${USER}" -p"${PASS}" -h "${HOST}" -P "${PORT}" -e 'show databases' -s --skip-column-names); do
    mysqldump -u"${USER}" -p"${PASS}" -h "${HOST}" -P "${PORT}" --lock-tables=false "${DB}" > "${BACKUP_PATH}/${DB}.sql";
done

## compress backups
cd "${BACKUP_PATH}" || exit
tar -zcvf "${BACKUP_NAME_SUFFIX}"-"${NOW}".tar.gz *.sql

### Move backup to a safe location
sshpass -p "${RSYNC_PASSWORD}" scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -qr "${BACKUP_PATH}/${BACKUP_NAME_SUFFIX}-${NOW}".tar.gz "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_HOST_PATH}"
