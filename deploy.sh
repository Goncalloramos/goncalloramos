#!/bin/bash

# Configuration
REMOTE_USER="pi"
REMOTE_HOST="raspi"  # Your Tailscale hostname
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
    ${LOCAL_DIR}/ ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/

# Set proper permissions
echo -e "${GREEN}Setting permissions...${NC}"
ssh ${REMOTE_USER}@${REMOTE_HOST} "sudo chown -R www-data:www-data ${REMOTE_DIR}"

# Reload Nginx
echo -e "${GREEN}Reloading Nginx...${NC}"
ssh ${REMOTE_USER}@${REMOTE_HOST} "sudo systemctl reload nginx"

echo -e "${GREEN}Deployment completed successfully!${NC}" 