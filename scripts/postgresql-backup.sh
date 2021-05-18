#!/usr/bin/env bash

## Set required vars
NOW="$(date +"%Y-%m-%d-%H")"
BACKUP_PATH=/var/backup/postgresql

## Check if are there already older backups
mkdir -p "${BACKUP_PATH}"
if [ "$(ls -A ${BACKUP_PATH})" ]; then
    echo "Deleting older backups"
    rm -f ${BACKUP_PATH}/*
fi

## Start backup of Postgresql DB
PGPASSWORD="${PASS}" pg_dump -U "${USER}" -h "${HOST}" -p "${PORT}" "${DB}" > "${BACKUP_PATH}"/"${DB}".pgsql


## compress backups
cd "${BACKUP_PATH}" || exit
tar -zcvf "${BACKUP_NAME_SUFFIX}"-"${NOW}".tar.gz *.pgsql

### Move backup to a safe location
sshpass -p "${RSYNC_PASSWORD}" scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -qr "${BACKUP_PATH}"/"${BACKUP_NAME_SUFFIX}"-"${NOW}".tar.gz "${REMOTE_USER}"@"${REMOTE_HOST}":"${REMOTE_HOST_PATH}"
