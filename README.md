# OcrolusTask
Ocrolus scenario-based question

#	Scenario - Upload all the files and directories in a drive older than a day to AWS and delete them from the drive.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
## this will only work if you've already installed and configured the AWS CLI for your local system. 

```bash
#!/bin/bash
# Retrieve new messages from S3 and save to tmpemails/ directory:
aws s3 cp \
   --recursive \
   s3://bucket-name/ \
   /home/david/s3-emails/tmpemails/  \
   --profile myaccount

# Set location variables:
tmp_file_location=/home/david/s3-emails/tmpemails/*
base_location=/home/david/s3-emails/emails/

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
```

### Stepwise Explanation: 
```bash
aws s3 cp \
   --recursive \
   s3://bucket-name/ \
   /home/david/s3-emails/tmpemails/  \
   --profile myaccount
   ```

The cp command stands for "copy," --recursive tells the CLI to apply the operation even to multiple objects, s3://bucket-name points to my bucket (your bucket name will obviously be different), the /home/govind... line is the absolute filesystem address to which I'd like the messages copied,
and the --profile argument tells the CLI which of my multiple AWS accounts I'm referring to.

```Bash
tmp_file_location=/home/david/s3-emails/tmpemails/*
base_location=/home/david/s3-emails/emails/
```

how the value of the tmp_file_location variable ends with an asterisk. That's because I want to refer to the files within that directory, rather than the directory itself.

I'll create a new permanent directory within the .../emails/ hierarchy to make it easier for me to find messages later. The name of this new directory will be the current date.

```Bash
today=$(date +"%m_%d_%Y")
[[ -d ${base_location}/"$today" ]] || mkdir ${base_location}/"$today"
```

create a new shell variable named today that will be populated by the output of the date +"%m_%d_%Y" command. date itself outputs the full date/timestamp, but what follows ("%m_%d_%Y") edits that output to a simpler and more readable format. If such a directory does not exist (||), then mkdir will create it for me.

```Bash
for FILE in $tmp_file_location
do
   mv $FILE ${base_location}/${today}/email$(rand)
done
```

for...do...done loop will read each of the files in the directory represented by the $tmp_file_location variable and then move it to the directory I just created (represented by the $base_location variable in addition to the current value of $today).


I'll give it its new name, the string "email" followed by a random number generated by the rand command. You may need to install a random number generator: that'll be apt install rand on Ubuntu/Redhat/Centos.

There are currently no files in tmpemails - that's because the mv command moves files to their new location, leaving nothing behind.

 It uses a similar for...do...done loop, this time reading the names of each file in the new directory (referenced using the "today" command) and then opening the file in Gedit. Note the asterisk I added to the end of the directory location.
 
 ```Bash
 for NEWFILE in ${base_location}/${today}/*
do
   gedit $NEWFILE
done
```

If I don't clean out my S3 bucket, it'll download all the accumulated messages each time I run the script. That'll make it progressively harder to manage.

So, after successfully downloading my new messages, I run this short script to delete all the files in the bucket:

```Bash
#!/bin/bash
# Delete all existing emails 

aws s3 rm --recursive s3://bucket-name/ --profile myaccount
```
