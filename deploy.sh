#!/bin/bash

# CloudHub 2.0 Deployment Script
echo "🚀 CloudHub 2.0 Deployment Script"
echo "=================================="

# Function to deploy to CloudHub
deploy_to_cloudhub() {
    local environment=$1
    local username=$2
    local password=$3
    local business_group=$4
    
    echo "📦 Building and deploying to $environment environment..."
    
    mvn clean deploy \
        -DmuleDeploy \
        -Danypoint.username="$username" \
        -Danypoint.password="$password" \
        -Danypoint.businessGroup="$business_group" \
        -Dmule.env="$environment" \
        -DskipTests \
        --batch-mode
}

# Check if environment variables are set
if [ -z "$ANYPOINT_USERNAME" ] || [ -z "$ANYPOINT_PASSWORD" ]; then
    echo "❌ Please set the following environment variables:"
    echo "   export ANYPOINT_USERNAME='your-username'"
    echo "   export ANYPOINT_PASSWORD='your-password'"
    echo "   export ANYPOINT_BUSINESS_GROUP='your-business-group' (optional)"
    exit 1
fi

# Get environment parameter (default to Sandbox)
ENVIRONMENT=${1:-Sandbox}
BUSINESS_GROUP=${ANYPOINT_BUSINESS_GROUP:-""}

echo "🎯 Target Environment: $ENVIRONMENT"
echo "👤 Username: $ANYPOINT_USERNAME"
echo "🏢 Business Group: ${BUSINESS_GROUP:-'Default'}"

# Confirm deployment
read -p "🤔 Do you want to proceed with deployment? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Deployment cancelled."
    exit 1
fi

# Deploy to CloudHub
deploy_to_cloudhub "$ENVIRONMENT" "$ANYPOINT_USERNAME" "$ANYPOINT_PASSWORD" "$BUSINESS_GROUP"

echo "✅ Deployment completed!"
echo "🌐 Check your application status at: https://anypoint.mulesoft.com/cloudhub"