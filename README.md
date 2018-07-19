# Mongo with auto S3 backup schedule

This container runs a MongoDB database with CRON schedule backup 

## Build mongo-s3-backup docker images
```
docker build . --tag mongo-s3-backup:3.4.10
```

## Kubernetes

- Modify the mongodb-statefulset.yml to specify all the environment variable values. 
- Run kubectl apply
```
kubectl apply -f mongodb-statefulset.yml
```
- This will create MongoDB statefulset with headless service. It will also add CRON entry to backup the database based on the CRON_SCHEDULE. 
- The yaml script also have postStart lifecycle to trigger the creation of CRON schedule value.


## Docker 

### Powershell
```
docker run -d --name <podname> -p 27017:27017 -h mongodb-0 `
	-e MONGO_INITDB_ROOT_USERNAME=<value> `
	-e MONGO_INITDB_ROOT_PASSWORD=<value> `
	-e MONGODB_CONNECTION_URI="mongodb://<value>:<value>@mongodb-0:27017" `
	-e AWS_ACCESS_KEY_ID=<value> `
	-e AWS_SECRET_ACCESS_KEY="<value>" `
	-e S3_BUCKET="<value>" `
	-e BACKUP_FILENAME_PREFIX="mongodb_backup" `
	-e BACKUP_FILENAME_DATE_FORMAT="%Y%m%d" `
	-e CRON_SCHEDULE="0 1 * * *" `
	mongo-s3-backup:3.4.10
```

### Bash to mongo container

```
docker exec -it <podname> bash
```

### Enabling CRON backup on Docker
```
printenv | grep -v "no_proxy" >> /etc/environment; 
touch /var/log/mongodb/backup.log; 
echo "${CRON_SCHEDULE} root /script/backup.sh > /var/log/mongodb/backup.log 2>&1" > /etc/cron.d/mongobackup_cron;
service cron start;
```


## Kubernetes or Docker commands

### Bash to mongo container

```
docker exec -it <podname> bash
```

### Manually trigger backup and upload to S3
```
./script/backup.sh
```

### Get list of database backup on S3
```
aws s3 ls s3://$S3_BUCKET/
```

### Download database backup 
```
aws s3 cp s3://$S3_BUCKET/mongodb_backup-20180718.archive restore.archive
```

### Restore latest backup  
```
/script/restore.sh
```