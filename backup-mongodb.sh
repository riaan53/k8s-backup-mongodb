#!/bin/bash

set -e

SCRIPT_NAME=backup-mongodb
ARCHIVE_NAME=mongodump_$(date +%Y%m%d_%H%M%S).gz

echo "[$SCRIPT_NAME] Dumping all MongoDB databases to compressed archive..."
mongodump --oplog \
	--archive="$ARCHIVE_NAME" \
	--gzip \
	--uri "$MONGODB_URI"

echo "[$SCRIPT_NAME] Uploading compressed archive to S3 bucket..."
aws s3 cp "$ARCHIVE_NAME" "$BUCKET_URI"

echo "[$SCRIPT_NAME] Cleaning up compressed archive..."
rm "$ARCHIVE_NAME"

echo "[$SCRIPT_NAME] Backup complete!"
