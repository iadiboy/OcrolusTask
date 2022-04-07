#!/bin/bash
# Retrieve new messages from S3 and save to tmpemails/ directory:
aws s3 cp \
   --recursive \
   s3://bucket-name/ \
   /home/govind/s3-emails/tmpemails/  \
   --profile myaccount

# Set location variables:
tmp_file_location=/home/govind/s3-emails/tmpemails/*
base_location=/home/govind/s3-emails/emails/

# Create new directory to store today's messages:
today=$(date +"%m_%d_%Y")
[[ -d ${base_location}/"$today" ]] || mkdir ${base_location}/"$today"

# Give the message files readable names:
for FILE in $tmp_file_location
do
   mv $FILE ${base_location}/${today}/email$(rand)
done

# Open new files in Gedit:
for NEWFILE in ${base_location}/${today}/*
do
   gedit $NEWFILE
done

# Delete all existing emails 

aws s3 rm --recursive s3://bucket-name/ --profile myaccount
