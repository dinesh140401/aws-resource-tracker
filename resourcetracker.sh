#!/bin/bash

# Metadata
# Author: venatadineshreddy annareddy
# Date: $14-03-2025
# Version: 1.0

# Description:
# This script reports AWS resource usage (EC2, S3, Lambda, IAM) and saves the output to a file.

# Debug mode
set -x

# Output file with timestamp
REPORT_FILE="aws_resource_report_$(date +%Y-%m-%d).txt"

# Clear previous report
> "$REPORT_FILE"

# Function to log data
log() {
    echo "$1" >> "$REPORT_FILE"
}

# Add metadata to the report
log "AWS Resource Usage Report"
log "Generated on: $(date)"
log "====================================="

# List S3 Buckets
log "\n===== S3 Buckets ====="
aws s3 ls >> "$REPORT_FILE"

# List EC2 Instances
log "\n===== EC2 Instances ====="
aws ec2 describe-instances \
--query "Reservations[*].Instances[*].{InstanceId:InstanceId, State:State.Name, InstanceType:InstanceType, LaunchTime:LaunchTime}" \
--output table >> "$REPORT_FILE"

# List Lambda Functions
log "\n===== Lambda Functions ====="
aws lambda list-functions \
--query "Functions[*].{FunctionName:FunctionName, Runtime:Runtime, LastModified:LastModified}" \
--output table >> "$REPORT_FILE"

# List IAM Users
log "\n===== IAM Users ====="
aws iam list-users \
--query "Users[*].{UserName:UserName, CreateDate:CreateDate}" \
--output table >> "$REPORT_FILE"

# Output file location
echo -e "\nAWS Resource Usage Report generated successfully. Check the file: $REPORT_FILE\n"
crontab -e
0 9 * * * /path/to/aws_resource_tracker.sh

