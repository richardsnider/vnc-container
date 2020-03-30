#!/usr/bin/env bash

FILE_NAME=.aws/credentials
# clear previous contents
> $FILE_NAME

echo "[default]" >> $FILE_NAME
echo "aws_access_key_id = " >> $FILE_NAME
echo "aws_secret_access_key = " >> $FILE_NAME

echo "Enter MFA Code:"
read varname

value=$(aws sts get-session-token --serial-number arn:aws:iam:: --token-code $varname)

# Clear File Again & Store New Keys
> $FILE_NAME
access_key_id=$(echo $value | awk '{print $11}' | tr -d '"' | tr -d ',')
secret_access_key=$(echo $value | awk '{print $5}' | tr -d '"' | tr -d ',')
session_token=$(echo $value | awk '{print $7}' | tr -d '"' | tr -d ',')
echo >> $FILE_NAME
echo "[defaut]" >> $FILE_NAME
echo "aws_access_key_id = $access_key_id" >> $FILE_NAME
echo "aws_secret_access_key = $secret_access_key" >> $FILE_NAME
echo "aws_session_token = $session_token" >> $FILE_NAME