#!/bin/bash

# Invoice Ninja Custom Deployment Script
# This script deploys Invoice Ninja with paywall bypass

set -e

echo "Invoice Ninja Custom Deployment"
echo "==============================="

# Check if .env exists
if [ ! -f .env ]; then
    echo "Creating .env from .env.custom..."
    cp .env.custom .env
    echo "✓ .env file created"
    echo ""
    echo "⚠️  Please edit .env and update:"
    echo "   - APP_URL (your domain)"
    echo "   - Admin credentials (IN_USER_EMAIL, IN_PASSWORD)"
    echo "   - Database passwords"
    echo ""
    read -p "Press Enter after updating .env file..."
fi

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed!"
    exit 1
fi

# Check Docker Compose (handle both docker-compose and docker compose)
if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
elif docker compose version &> /dev/null; then
    DOCKER_COMPOSE="docker compose"
else
    echo "❌ Docker Compose is not installed!"
    exit 1
fi

echo "✓ Using Docker Compose command: $DOCKER_COMPOSE"
echo ""

echo "Building custom Docker image..."
echo "(This may take a few minutes on first build)"
$DOCKER_COMPOSE -f docker-compose.custom.yml build

echo ""
echo "Starting services..."
$DOCKER_COMPOSE -f docker-compose.custom.yml up -d

echo ""
echo "Waiting for services to start..."
sleep 10

# Check if services are running
echo ""
echo "Checking service status..."
$DOCKER_COMPOSE -f docker-compose.custom.yml ps

echo ""
echo "✅ Deployment complete!"
echo ""
echo "Invoice Ninja is running on:"
echo "- PHP-FPM: Port 9000 (for Nginx Proxy Manager)"
echo ""
echo "Next steps:"
echo "1. Configure Nginx Proxy Manager (see NGINX_PROXY_MANAGER_SETUP.md)"
echo "2. Access Invoice Ninja through your proxy"
echo "3. Login with credentials from .env file"
echo ""
echo "To view logs: $DOCKER_COMPOSE -f docker-compose.custom.yml logs -f"
echo "To stop: $DOCKER_COMPOSE -f docker-compose.custom.yml down"