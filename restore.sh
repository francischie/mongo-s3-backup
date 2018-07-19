#!/bin/bash

# Utility function
get_date () {
    date +[%Y-%m-%d\ %H:%M:%S]
}

echo "$(get_date) [Step 1/2] Downloading latest backup from S3..."
LATEST_BACKUP=`aws s3 ls s3://$S3_BUCKET | sort | tail -n 1 | awk '{print $4}'`
aws s3 cp s3://$S3_BUCKET/$LATEST_BACKUP restore.archive

echo "$(get_date) [Step 2/3] Unpacking and restoring backup files..."
mongorestore --uri $MONGODB_CONNECTION_URI --gzip --archive=restore.archive

echo "$(get_date) [Step 3/3] Cleaning up.."
rm restore.archive

echo "$(get_date) Restoration completed."