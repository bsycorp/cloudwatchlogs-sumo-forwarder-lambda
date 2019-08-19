#!/bin/bash

SUMO_AWS_LAMBDA_VERSION="$1"

if [ -z "$SUMO_AWS_LAMBDA_VERSION" ]; then
	SUMO_AWS_LAMBDA_VERSION="1.2.7"
	echo "Defaulting Docker image to $SUMO_AWS_LAMBDA_VERSION"
fi

SUMO_AWS_LAMBDA_URL="https://github.com/SumoLogic/sumologic-aws-lambda/archive/v$SUMO_AWS_LAMBDA_VERSION.zip"
SUMO_AWS_LAMBDA_DOWNLOAD_PATH="build"
SUMO_AWS_LAMBDA_DOWNLOAD_FILE="$SUMO_AWS_LAMBDA_DOWNLOAD_PATH/sumo-aws-lambda-$SUMO_AWS_LAMBDA_VERSION.zip"
SUMO_AWS_LAMBDA_EXTRACT_PATH="$SUMO_AWS_LAMBDA_DOWNLOAD_PATH/sumologic-aws-lambda-$SUMO_AWS_LAMBDA_VERSION"

set -e

if [ ! -d "$SUMO_AWS_LAMBDA_DOWNLOAD_PATH" ]; then
	mkdir build
fi

echo "downloading latest version of sumo-aws-lambda from $SUMO_AWS_LAMBDA_URL"
curl --fail -J -L -o $SUMO_AWS_LAMBDA_DOWNLOAD_FILE $SUMO_AWS_LAMBDA_URL
echo "download completed, available at: $SUMO_AWS_LAMBDA_DOWNLOAD_PATH"
echo "unzipping Sumologic serverless functions to $SUMO_AWS_LAMBDA_EXTRACT_PATH"
unzip $SUMO_AWS_LAMBDA_DOWNLOAD_FILE -d $SUMO_AWS_LAMBDA_DOWNLOAD_PATH

echo "creating lambda deployment package for Sumologic log forwarder - $SUMO_AWS_LAMBDA_EXTRACT_PATH"
(cd $SUMO_AWS_LAMBDA_EXTRACT_PATH/cloudwatchlogs-with-dlq; npm install && zip -r cloudwatchlogs-with-dlq.zip DLQProcessor.js cloudwatchlogs_lambda.js vpcutils.js package.json sumo-dlq-function-utils/ node_modules/ && cp cloudwatchlogs-with-dlq.zip ../../)