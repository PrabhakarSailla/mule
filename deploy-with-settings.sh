#!/bin/bash

# CloudHub 2.0 Deployment Script with Maven Settings
echo "CloudHub 2.0 Deployment with Maven Settings"
echo "==========================================="

# Check if environment variables are set
if [ -z "$ANYPOINT_USERNAME" ]; then
    echo "Please set ANYPOINT_USERNAME environment variable"
    exit 1
fi

if [ -z "$ANYPOINT_PASSWORD" ]; then
    echo "Please set ANYPOINT_PASSWORD environment variable"  
    exit 1
fi

# Set Maven options
export MAVEN_OPTS="-Xmx3072m"

# Deploy using local settings.xml
echo "Deploying to CloudHub 2.0..."
mvn clean deploy -DmuleDeploy \
  --settings ./settings.xml \
  -Danypoint.username="$ANYPOINT_USERNAME" \
  -Danypoint.password="$ANYPOINT_PASSWORD" \
  -Dmulesoft.username="$ANYPOINT_USERNAME" \
  -Dmulesoft.password="$ANYPOINT_PASSWORD" \
  -DskipExchange=true \
  -X

echo "Deployment completed!"