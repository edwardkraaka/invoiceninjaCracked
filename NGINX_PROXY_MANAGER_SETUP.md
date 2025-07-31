# Invoice Ninja with Nginx Proxy Manager Setup Guide

## Overview

This guide explains how to set up Invoice Ninja with Docker and connect it to Nginx Proxy Manager (NPM) for reverse proxy functionality. Our setup includes the paywall bypass and removes the built-in Nginx container.

## Prerequisites

- Docker and Docker Compose installed
- Nginx Proxy Manager running and accessible
- Domain name (optional, for SSL)

## Setup Steps

### 1. Prepare the Environment

```bash
# Copy the custom environment file
cp .env.custom .env

# Edit .env to customize your settings
nano .env

# Important variables to update:
# - APP_URL (set to your domain, e.g., https://invoice.yourdomain.com)
# - IN_USER_EMAIL (admin email)
# - IN_PASSWORD (admin password)
# - DB_PASSWORD and DB_ROOT_PASSWORD (for security)
```

### 2. Build and Start the Containers

```bash
# Build the custom image with paywall bypass
docker-compose -f docker-compose.custom.yml build

# Start all services
docker-compose -f docker-compose.custom.yml up -d

# Check logs
docker-compose -f docker-compose.custom.yml logs -f app
```

### 3. Configure Nginx Proxy Manager

#### Option A: FastCGI Configuration (Recommended)

1. Create a new proxy host in NPM
2. **Details tab:**
   - Domain Names: `invoice.yourdomain.com`
   - Scheme: `http`
   - Forward Hostname/IP: `<docker-host-ip>` or container name if on same network
   - Forward Port: `9000`
   - Cache Assets: ✓
   - Block Common Exploits: ✓
   - Websockets Support: ✓

3. **Custom Nginx Configuration:**
   Add this to the "Advanced" tab:

```nginx
location ~ \.php$ {
    fastcgi_pass app:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME /var/www/html/public$fastcgi_script_name;
    include fastcgi_params;
    fastcgi_param PHP_VALUE "upload_max_filesize=20M \n post_max_size=20M";
}

location / {
    try_files $uri $uri/ /index.php?$query_string;
}

location ~ /\.(?!well-known).* {
    deny all;
}

# Security headers
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
```

#### Option B: HTTP Proxy (Alternative)

If you prefer using PHP's built-in server:

1. Uncomment the `app-http` service in `docker-compose.custom.yml`
2. Start the service: `docker-compose -f docker-compose.custom.yml up -d app-http`
3. In NPM, create a standard proxy host:
   - Forward Port: `8080`
   - No custom configuration needed

### 4. SSL Configuration

In Nginx Proxy Manager:
1. Go to SSL tab
2. Select "Request a new SSL Certificate"
3. Enable "Force SSL"
4. Add your email for Let's Encrypt

### 5. Verify the Installation

1. Access your Invoice Ninja instance at your configured domain
2. Login with the credentials from `.env`
3. Check Settings → Account Management to verify all features are enabled
4. Create a test invoice and download the PDF to verify white label is working

## Network Configuration

### If NPM is on the Same Docker Network

```yaml
# Add to docker-compose.custom.yml
networks:
  app-network:
    external: true
    name: nginxproxymanager_default  # Or your NPM network name
```

### If NPM is on a Different Host

Use the host's IP address in NPM configuration and ensure ports are accessible.

## Troubleshooting

### 502 Bad Gateway
- Check if app container is running: `docker ps`
- Verify PHP-FPM is listening: `docker exec app ss -tlnp | grep 9000`
- Check logs: `docker-compose -f docker-compose.custom.yml logs app`

### Blank Page
- Clear Laravel cache: `docker exec app php artisan cache:clear`
- Check permissions: `docker exec app chown -R www-data:www-data storage bootstrap/cache`

### PDF Generation Issues
- Verify Chrome is installed: `docker exec app which google-chrome-stable`
- Check Chrome path: `docker exec app printenv SNAPPDF_CHROMIUM_PATH`

## Security Recommendations

1. Change default passwords in `.env`
2. Use strong database passwords
3. Enable HTTPS in production
4. Restrict database port (3306) to localhost only
5. Regular backups of volumes

## Maintenance

### Backup
```bash
# Backup volumes
docker run --rm -v invoiceninja_app_storage:/data -v $(pwd):/backup alpine tar czf /backup/storage-backup.tar.gz -C /data .
docker run --rm -v invoiceninja_mysql_data:/data -v $(pwd):/backup alpine tar czf /backup/mysql-backup.tar.gz -C /data .
```

### Update
```bash
# Pull latest changes
git pull

# Rebuild with updated code
docker-compose -f docker-compose.custom.yml build --no-cache

# Restart services
docker-compose -f docker-compose.custom.yml down
docker-compose -f docker-compose.custom.yml up -d
```

## Features Enabled by Paywall Bypass

✅ White Label (no Invoice Ninja branding)
✅ Custom invoice designs
✅ Unlimited clients
✅ API access
✅ All report types
✅ Multi-user support
✅ Document management
✅ Custom email templates
✅ All enterprise features