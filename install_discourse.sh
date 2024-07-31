#!/bin/bash

# Discourse Installation Script for Ubuntu
# This script installs a production-ready Discourse site on Ubuntu
# It uses a .env file for configuration

# Exit immediately if a command exits with a non-zero status
set -e

# Check if .env file exists
if [ ! -f .env ]; then
    echo ".env file not found. Please create a .env file with the required variables."
    exit 1
fi

# Load environment variables from .env file
set -a
source .env
set +a

# Validate required variables
required_vars=(
    "DISCOURSE_HOSTNAME"
    "DISCOURSE_DEVELOPER_EMAILS"
    "DISCOURSE_SMTP_ADDRESS"
    "DISCOURSE_SMTP_PORT"
    "DISCOURSE_SMTP_USER_NAME"
    "DISCOURSE_SMTP_PASSWORD"
    "LETSENCRYPT_ACCOUNT_EMAIL"
)

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "Error: $var is not set in the .env file"
        exit 1
    fi
done

# Update and upgrade system packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install required dependencies
echo "Installing dependencies..."
sudo apt install -y git docker.io docker-compose

# Add current user to docker group
sudo usermod -aG docker $USER

# Clone Discourse Docker repository
echo "Cloning Discourse Docker repository..."
sudo git clone https://github.com/discourse/discourse_docker.git /opt/discourse

# Change to Discourse directory
cd /opt/discourse

# Copy standalone sample file
sudo cp samples/standalone.yml containers/app.yml

# Generate random passwords if not provided in .env
DB_PASSWORD=${DB_PASSWORD:-$(openssl rand -hex 16)}
REDIS_PASSWORD=${REDIS_PASSWORD:-$(openssl rand -hex 16)}

# Configure Discourse
echo "Configuring Discourse..."
sudo sed -i "s/DISCOURSE_DEVELOPER_EMAILS:.*/DISCOURSE_DEVELOPER_EMAILS: '${DISCOURSE_DEVELOPER_EMAILS}'/" containers/app.yml
sudo sed -i "s/DISCOURSE_HOSTNAME:.*/DISCOURSE_HOSTNAME: '${DISCOURSE_HOSTNAME}'/" containers/app.yml
sudo sed -i "s/DISCOURSE_SMTP_ADDRESS:.*/DISCOURSE_SMTP_ADDRESS: ${DISCOURSE_SMTP_ADDRESS}/" containers/app.yml
sudo sed -i "s/DISCOURSE_SMTP_PORT:.*/DISCOURSE_SMTP_PORT: ${DISCOURSE_SMTP_PORT}/" containers/app.yml
sudo sed -i "s/DISCOURSE_SMTP_USER_NAME:.*/DISCOURSE_SMTP_USER_NAME: '${DISCOURSE_SMTP_USER_NAME}'/" containers/app.yml
sudo sed -i "s/DISCOURSE_SMTP_PASSWORD:.*/DISCOURSE_SMTP_PASSWORD: '${DISCOURSE_SMTP_PASSWORD}'/" containers/app.yml
sudo sed -i "s/DISCOURSE_SMTP_ENABLE_START_TLS:.*/DISCOURSE_SMTP_ENABLE_START_TLS: true/" containers/app.yml
sudo sed -i "s/LETSENCRYPT_ACCOUNT_EMAIL:.*/LETSENCRYPT_ACCOUNT_EMAIL: '${LETSENCRYPT_ACCOUNT_EMAIL}'/" containers/app.yml

# Set database and Redis passwords
sudo sed -i "s/db_password =.*/db_password = $DB_PASSWORD/" containers/app.yml
sudo sed -i "s/redis_password =.*/redis_password = $REDIS_PASSWORD/" containers/app.yml

# Build and start Discourse
echo "Building and starting Discourse..."
sudo ./launcher bootstrap app
sudo ./launcher start app

echo "Discourse installation complete!"
echo "Please visit https://${DISCOURSE_HOSTNAME} to complete the setup process."