# Docker Build Troubleshooting

## Common Issues and Solutions

### 1. Composer Install Fails with Preload Error

**Error:**
```
PHP Fatal error: Failed opening required '/var/www/html/vendor/autoload.php'
```

**Solution:**
The Dockerfile has been updated to handle this by temporarily moving preload.php during composer install.

### 2. Build Context Issues

**Error:**
```
COPY failed: file not found
```

**Solution:**
Ensure you're running docker-compose from the root directory containing both the Dockerfile and the `invoiceninja/` folder:

```bash
# Correct directory structure:
.
├── Dockerfile.custom
├── docker-compose.custom.yml
├── dockerfiles/          # Original docker files
│   └── debian/
│       ├── php/
│       ├── scripts/
│       └── supervisor/
└── invoiceninja/        # Modified source code
    ├── app/
    ├── composer.json
    └── ...
```

### 3. Permission Denied Errors

**Error:**
```
Permission denied: storage/logs/laravel.log
```

**Solution:**
The Dockerfile sets proper permissions. If issues persist:

```bash
docker exec app chown -R www-data:www-data /var/www/html/storage
docker exec app chmod -R 775 /var/www/html/storage
```

### 4. Memory Issues During Build

**Error:**
```
Killed (composer install fails)
```

**Solution:**
Increase Docker memory allocation:
- Docker Desktop: Preferences → Resources → Memory (increase to 4GB+)
- Or add swap space on Linux hosts

### 5. Network Issues During Build

**Error:**
```
Could not download package
```

**Solution:**
```bash
# Clean build with no cache
docker-compose -f docker-compose.custom.yml build --no-cache

# Or use a different mirror for composer
docker-compose -f docker-compose.custom.yml build --build-arg COMPOSER_MIRROR_URL=https://packagist.org
```

### 6. Paywall Bypass Not Working

**Symptoms:**
- Invoice Ninja logo still appears on PDFs
- Premium features disabled

**Check:**
```bash
# Verify the bypass is in the container
docker exec app grep -n "return true; // Bypass" /var/www/html/app/Models/Account.php
```

**Fix:**
Rebuild the image to ensure modified files are included:
```bash
docker-compose -f docker-compose.custom.yml build --no-cache
docker-compose -f docker-compose.custom.yml up -d --force-recreate
```

### 7. PHP-FPM Not Starting

**Error:**
```
502 Bad Gateway in Nginx Proxy Manager
```

**Check:**
```bash
# Check if PHP-FPM is running
docker exec app ps aux | grep php-fpm

# Check PHP-FPM logs
docker exec app tail -f /var/log/php-fpm.log
```

### 8. Database Connection Issues

**Error:**
```
SQLSTATE[HY000] [2002] Connection refused
```

**Solution:**
```bash
# Ensure MySQL is healthy
docker-compose -f docker-compose.custom.yml ps mysql

# Check MySQL logs
docker-compose -f docker-compose.custom.yml logs mysql

# Verify .env database settings match docker-compose
grep DB_ .env
```

### 9. Redis Connection Issues

**Error:**
```
Connection refused [tcp://redis:6379]
```

**Solution:**
```bash
# Check Redis health
docker exec redis redis-cli ping

# Verify Redis is in the same network
docker network ls
docker inspect <network_name>
```

### Clean Rebuild Process

If all else fails, try a clean rebuild:

```bash
# Stop and remove everything
docker-compose -f docker-compose.custom.yml down -v

# Remove old images
docker rmi invoiceninja/invoiceninja-custom:latest

# Clean build cache
docker builder prune -f

# Rebuild from scratch
docker-compose -f docker-compose.custom.yml build --no-cache

# Start fresh
docker-compose -f docker-compose.custom.yml up -d
```

### Debugging Build Process

To debug the build process:

```bash
# Build with verbose output
DOCKER_BUILDKIT=0 docker-compose -f docker-compose.custom.yml build

# Or build step by step
docker build -f Dockerfile.custom --target <stage_name> .
```

### Getting Help

1. Check container logs: `docker-compose -f docker-compose.custom.yml logs -f app`
2. Access container shell: `docker exec -it app bash`
3. Check Laravel logs: `docker exec app tail -f /var/www/html/storage/logs/laravel.log`