#!/bin/bash

# Configuration
REMOTE_USER="goncalloramos"  # Updated username
REMOTE_HOST="raspi"  # Hostname
REMOTE_DIR="/var/www/goncalloramos.com/html"
LOCAL_DIR="."

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting deployment to Raspberry Pi...${NC}"

# Create remote directory if it doesn't exist
ssh ${REMOTE_USER}@${REMOTE_HOST} "sudo mkdir -p ${REMOTE_DIR}"

# Sync files to remote server
echo -e "${GREEN}Syncing files...${NC}"
rsync -avz --delete \
    --exclude '.git' \
    --exclude 'deploy.sh' \
    --exclude 'nginx-config-template.conf' \
    --exclude 'flask-app.service' \
    ${LOCAL_DIR}/ ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/

# Set up Python virtual environment
echo -e "${GREEN}Setting up Python environment...${NC}"
ssh ${REMOTE_USER}@${REMOTE_HOST} "cd ${REMOTE_DIR} && \
    sudo python3 -m venv venv && \
    sudo venv/bin/pip install -r requirements.txt"

# Set proper permissions
echo -e "${GREEN}Setting permissions...${NC}"
ssh ${REMOTE_USER}@${REMOTE_HOST} "sudo chown -R www-data:www-data ${REMOTE_DIR}"

# Copy and enable systemd service
echo -e "${GREEN}Setting up systemd service...${NC}"
scp flask-app.service ${REMOTE_USER}@${REMOTE_HOST}:/tmp/
ssh ${REMOTE_USER}@${REMOTE_HOST} "sudo mv /tmp/flask-app.service /etc/systemd/system/ && \
    sudo systemctl daemon-reload && \
    sudo systemctl enable flask-app && \
    sudo systemctl restart flask-app"

# Reload Nginx
echo -e "${GREEN}Reloading Nginx...${NC}"
ssh ${REMOTE_USER}@${REMOTE_HOST} "sudo systemctl reload nginx"

echo -e "${GREEN}Deployment completed successfully!${NC}" 