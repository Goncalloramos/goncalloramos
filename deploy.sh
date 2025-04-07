#!/bin/bash

# Configuration
REMOTE_DIR="/var/www/goncalloramos.com/html"
LOCAL_DIR="."

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting deployment...${NC}"

# Create directory if it doesn't exist
echo -e "${GREEN}Creating directory...${NC}"
sudo mkdir -p ${REMOTE_DIR}

# Copy files
echo -e "${GREEN}Copying files...${NC}"
sudo cp -r ${LOCAL_DIR}/* ${REMOTE_DIR}/

# Set up Python virtual environment
echo -e "${GREEN}Setting up Python environment...${NC}"
cd ${REMOTE_DIR}
sudo python3 -m venv venv
sudo venv/bin/pip install -r requirements.txt

# Set proper permissions
echo -e "${GREEN}Setting permissions...${NC}"
sudo chown -R www-data:www-data ${REMOTE_DIR}

# Set up systemd service
echo -e "${GREEN}Setting up systemd service...${NC}"
sudo cp flask-app.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable flask-app
sudo systemctl restart flask-app

# Reload Nginx
echo -e "${GREEN}Reloading Nginx...${NC}"
sudo systemctl reload nginx

echo -e "${GREEN}Deployment completed successfully!${NC}" 