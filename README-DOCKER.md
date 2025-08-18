# Invoice Ninja Docker Setup with MariaDB

This Docker setup builds Invoice Ninja from your local bypassed source code using MariaDB instead of MySQL.

## Prerequisites

- Docker and Docker Compose installed
- At least 2GB of free disk space
- Port 80 and 443 available (or modify the ports in docker-compose.yml)

## Quick Start

1. **Configure your environment**:
   Edit the `.env` file to set your preferences:
   ```bash
   # Important settings to change:
   APP_URL=https://your-domain.com
   IN_USER_EMAIL=your-admin@email.com
   IN_PASSWORD=your-secure-password
   
   # Email settings (required for sending invoices):
   MAIL_HOST=smtp.gmail.com
   MAIL_PORT=587
   MAIL_USERNAME=your-email@gmail.com
   MAIL_PASSWORD=your-app-password
   MAIL_FROM_ADDRESS=your-email@gmail.com
   ```

2. **Build and start the containers**:
   ```bash
   # Build the Invoice Ninja image from source
   docker-compose build
   
   # Start all services
   docker-compose up -d
   ```

3. **Wait for initialization** (first run only):
   The first run will take 3-5 minutes to:
   - Install PHP dependencies
   - Run database migrations
   - Create the admin account
   - Set up storage directories
   
   Monitor the logs:
   ```bash
   docker-compose logs -f invoiceninja
   ```

4. **Access Invoice Ninja**:
   - Open http://localhost (or your configured domain)
   - Login with the credentials from your `.env` file

## Directory Structure

```
/Users/user/Desktop/scripts/invoiceninja/
├── docker-compose.yml           # Main orchestration file
├── .env                         # Environment configuration
├── nginx/
│   └── in-vhost.conf           # Nginx configuration
├── mariadb/                    # MariaDB data (created automatically)
├── invoiceninjaCracked/         # Source code with paywall bypass
│   ├── Dockerfile.custom        # Build configuration
│   └── invoiceninja/           # Laravel application
```

## Services

### 1. **Nginx** (Port 80/443)
- Serves static files
- Proxies PHP requests to PHP-FPM
- Handles SSL termination (when configured)

### 2. **Invoice Ninja** (Port 9000 internally)
- Built from local source with paywall bypass
- PHP 8.3-FPM with all required extensions
- Includes Chrome/Chromium for PDF generation
- All premium features enabled

### 3. **MariaDB** (Port 3306 internally)
- LinuxServer.io MariaDB 10.6.10
- Data persisted in `./mariadb/` directory
- Automatic health checks

### 4. **Redis** (Port 6379 internally)
- Session and cache storage
- Queue backend for background jobs

## Common Operations

### View logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f invoiceninja
docker-compose logs -f mariadb
```

### Stop services
```bash
docker-compose down
```

### Stop and remove all data (CAUTION!)
```bash
docker-compose down -v
rm -rf mariadb/
```

### Rebuild after source changes
```bash
docker-compose build --no-cache invoiceninja
docker-compose up -d
```

### Access container shell
```bash
docker exec -it invoiceninja bash
```

### Run artisan commands
```bash
docker exec -it invoiceninja php artisan cache:clear
docker exec -it invoiceninja php artisan optimize
```

### Backup database
```bash
docker exec invoiceninja-mariadb mysqldump -u invoiceninja -pGotDiscardConsonantChauffeur invoiceninja > backup.sql
```

### Restore database
```bash
cat backup.sql | docker exec -i invoiceninja-mariadb mysql -u invoiceninja -pGotDiscardConsonantChauffeur invoiceninja
```

## SSL/HTTPS Configuration

To enable HTTPS:

1. Obtain SSL certificates (Let's Encrypt, etc.)
2. Place certificates in `./nginx/ssl/`
3. Uncomment the HTTPS server block in `nginx/in-vhost.conf`
4. Update the server_name and certificate paths
5. Restart nginx: `docker-compose restart nginx`

## Troubleshooting

### Container won't start
```bash
# Check logs
docker-compose logs invoiceninja

# Verify build
docker-compose build --no-cache invoiceninja
```

### Database connection errors
```bash
# Check MariaDB is running
docker-compose ps mariadb

# Test connection
docker exec -it invoiceninja-mariadb mysql -u invoiceninja -pGotDiscardConsonantChauffeur -e "SELECT 1"
```

### Permission errors
```bash
# Fix storage permissions
docker exec -it invoiceninja chown -R www-data:www-data /var/www/html/storage
docker exec -it invoiceninja chmod -R 775 /var/www/html/storage
```

### PDF generation issues
```bash
# Check Chrome/Chromium installation
docker exec -it invoiceninja which google-chrome-stable
docker exec -it invoiceninja which chromium
```

### First run taking too long
This is normal. The first run needs to:
- Download and install all Composer dependencies
- Run all database migrations (250+ files)
- Create indexes and seed initial data
- Generate application keys and caches

## Performance Tuning

### Increase PHP workers
Edit `docker-compose.yml` and add:
```yaml
environment:
  - PM_MAX_CHILDREN=20  # Default is 10
```

### Increase MariaDB memory
Add to MariaDB environment in `docker-compose.yml`:
```yaml
environment:
  - MYSQL_INNODB_BUFFER_POOL_SIZE=512M
```

### Enable opcache preloading
Already configured in the Dockerfile for optimal performance.

## Security Notes

⚠️ **Important Security Considerations**:

1. **Change default passwords** in `.env` before deployment
2. **Use HTTPS** in production environments
3. **Restrict database access** to local network only
4. **Regular backups** are essential
5. **Monitor logs** for suspicious activity

## Features Enabled

Thanks to the paywall bypass, all premium features are enabled:
- ✅ Unlimited clients
- ✅ White label (no Invoice Ninja branding)
- ✅ Custom invoice designs
- ✅ API access
- ✅ Multiple users
- ✅ Advanced reports
- ✅ Client portal customization
- ✅ Email templates and reminders
- ✅ Document management
- ✅ All payment gateways

## Support

This is a modified version without official support. For the official version, visit:
https://www.invoiceninja.com

## Legal Notice

This setup includes modifications that bypass Invoice Ninja's licensing system. Use only for educational purposes or ensure you have proper licensing agreements.