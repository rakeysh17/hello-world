#!/bin/bash

##########
# USAGE: ./sendrawemail.sh To From "Subject" "Message" attachment.ext region-of-ses
#
#Ex: ./sendrawemail.sh to@domain.com from@doamin.com "test subject" "please find the attachment" assets.csv eu-west-1
#
##########
tovar=$1
fromvar=$2
subjectvar=$3
messagevar=$4
attachvar=`date +%Y%m%d`_assets.csv
regionvar=$5

##########
# Command to get the list of buckets
aws s3 ls $aetn_env-cdn-sixnightvision-com | awk '{if(NR==1) {print "Date,Size,Filename";} else{print $1 " " $2 "," $3 "," $4}}' > `date +%Y%m%d`_assets.csv
##########

MIME=`file --mime-type $attachvar | awk '{print $2}'`
FILE=`cat $attachvar | base64 | tr -d '\n'`

echo "{\"Data\": \"From: $fromvar\nTo: $tovar\nSubject: $subjectvar\nMIME-Version: 1.0\nContent-type: Multipart/Mixed;boundary=\\\"NextPart\\\"\n\n--NextPart\nContent-Type: text/plain\n\n$messagevar.\n\n--NextPart\nContent-Type: $MIME;\nContent-Disposition: attachment; filename=\\\"$attachvar\\\";\nContent-Transfer-Encoding: base64\n\n$FILE\n\n--NextPart--\"}" > message.json

aws ses send-raw-email --raw-message file://message.json --region $regionvar

rm -f message.json
rm -f `date +%Y%m%d`_assets.csv


====================================================================================================================================

./sendrawemail.sh "rakesh.singh@aetndigital.com, shailendra.sharma@aetndigital.com" devops@aenetworks.com "Report for s3 bucket" "please find the attachment the s3 bucket report" us-east-1


/aeappdir/webapps/aetn.history.sixnightvision/current/sendrawemail.sh


awk, sed , cut , find 
