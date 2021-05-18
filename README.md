# db-backup-tools
DB backup tools for kubernetes env.

The aim of this project is to give a tool to backing up databases running on top of kubernetes clusters, where others tools or mechanisms have not been implemented yet.

## Prerequisites

This project makes use of kubernetes `Cronjob` object type that has been released as a stable version with the v1.21 release of k8s. 
So if you are running a cluster wiht an older release change the apiVersion from `batch/v1` to `batch/v1beta1` reciprocally. I'm assuming also that all the backups are transferred in a secured env outside of the kubernetes cluster itself.
In these examples I'm using scp to upload the backups to another service. 

## ENV VARS

### DB RELATED

`USER`

`PASS`

`HOST`

`PORT`

`DB` only for postgresql cronjob configuration

### REMOTE HOST RELATED

`REMOTE_USER`

`REMOTE_HOST`

`REMOTE_HOST_PATH`

`RSYNC_PASSWORD` This is the password for the remote server.