# Mongo S3 Backup

This container runs a MongoDB database with CRON schedule backup 

## Build mongo-s3-backup docker images
```
docker build . --tag mongo-s3-backup:3.4.10
```


## Running in Docker Dev Machine 
```
docker run -d --name m1 -p 27017:27017 -h mongodb-0 `
	-e MONGO_INITDB_ROOT_USERNAME=<value> `
	-e MONGO_INITDB_ROOT_PASSWORD=<value> `
	-e MONGODB_CONNECTION_URI="mongodb://<value>:<value>@mongodb-0:27017" `
	-e AWS_ACCESS_KEY_ID=<value> `
	-e AWS_SECRET_ACCESS_KEY="<value>" `
	-e S3_BUCKET="<value>" `
	-e BACKUP_FILENAME_PREFIX="<value>" `
	-e BACKUP_FILENAME_DATE_FORMAT="%Y%m%d" `
	-e CRON_SCHEDULE="0 1 * * *" `
	mongo-s3-backup:3.4.10
```

### Manually trigger backup and upload to S3
```
./script/backup.sh
```

### Get list of backup database on S3
```
aws s3 ls $S3_BUCKET
```

### Download backup 
```
aws s3 cp $S3_BUCKET\<filename> restore.archive
```

### Restore backup  
```
mongorestore --archive restore.archive --gzip
```