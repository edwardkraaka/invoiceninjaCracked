# Invoice Ninja Docker Deployment

This repository contains a Docker Compose setup for Invoice Ninja v5 with a custom React UI build process.

## Prerequisites

- Docker and Docker Compose installed
- Git
- A domain with SSL (for production)
- At least 2GB RAM available

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/edwardkraaka/invoiceninjaCracked.git
cd invoiceninja
```

### 2. Configure Environment

Copy the example environment file and configure it:

```bash
cp env.example .env
```

Edit `.env` and set the following critical values:

```env
# Application URL (MUST match your domain - this is the ONLY place you need to set it)
APP_URL=https://your-domain.com

# Database credentials
DB_DATABASE=invoiceninja
DB_USERNAME=ninja
DB_PASSWORD=your_secure_password
DB_ROOT_PASSWORD=your_root_password

# Initial admin account
IN_USER_EMAIL=admin@your-domain.com
IN_PASSWORD=your_admin_password

# App key (generate with: openssl rand -base64 32)
APP_KEY=base64:your_generated_key_here
```

**IMPORTANT:** The `APP_URL` in your `.env` file is automatically used by both the backend API and the React UI. You do NOT need to edit `docker-compose.yml`.

### 3. Build and Deploy

```bash
# Build the custom Invoice Ninja image
docker compose build --no-cache

# Start all services
docker compose up -d

# Check logs
docker compose logs -f
```

### 5. Initial Setup

The first deployment will:
1. Run database migrations
2. Create the initial admin account (using IN_USER_EMAIL and IN_PASSWORD from .env)
3. Set up storage links
4. Configure React UI with correct API URL

## Architecture

### Services

- **nginx**: Reverse proxy (ports 80/443)
- **invoiceninja**: PHP-FPM application server
- **mariadb**: Database server
- **redis**: Cache and session storage

### Directory Structure

```
/var/www/html/
├── public/
│   ├── react-app/        # React UI build files
│   │   ├── react/         # JS/CSS bundles
│   │   └── tinymce_6.4.2/ # TinyMCE editor assets
│   ├── react -> react-app/react  # Symlink
│   └── tinymce_6.4.2 -> react-app/tinymce_6.4.2  # Symlink
└── storage/               # Application storage
```

## Common Issues & Solutions

### Issue: Authentication fails with "These credentials do not match our records"

**Cause**: React UI is trying to connect to the wrong API URL

**Solution**:
1. Verify `APP_URL` in your `.env` file matches your actual domain/URL
2. Rebuild the container: `docker compose build --no-cache invoiceninja`
3. Restart: `docker compose up -d`

**Note**: The React UI now automatically uses the `APP_URL` from your `.env` file at runtime. You don't need to edit any Docker configuration files.

### Issue: TinyMCE editor shows blank/not loading

**Cause**: TinyMCE symlink pointing to wrong location

**Solution**:
```bash
docker exec invoiceninja bash -c "
  rm -f /var/www/html/public/tinymce_6.4.2
  ln -sf /var/www/html/public/react-app/tinymce_6.4.2 /var/www/html/public/tinymce_6.4.2
"
```

### Issue: Multiple React bundle files causing wrong version to load

**Cause**: Old bundle files not cleaned up during deployment

**Solution**: The init script now automatically cleans old bundles on startup. To manually clean:
```bash
docker exec invoiceninja bash -c "
  cd /var/www/html/public/react-app/react
  ls -t index-*.js | tail -n +2 | xargs rm -f
  ls -t index-*.css | tail -n +2 | xargs rm -f
"
```

## Deployment Verification

After deployment, verify everything works:

1. **Check services are running**:
   ```bash
   docker compose ps
   ```
   All services should show "healthy" status

2. **Test authentication**:
   - Navigate to https://your-domain.com
   - Login with credentials from IN_USER_EMAIL/IN_PASSWORD

3. **Test TinyMCE editor**:
   - Go to Settings → Invoice Design
   - Verify rich text editors display properly

4. **Check API connectivity**:
   ```bash
   curl -I https://your-domain.com/api/v1/health
   ```

## Updating

To update to the latest version:

```bash
# Pull latest changes
git pull

# Rebuild and restart
docker compose build --no-cache
docker compose up -d
```

## Backup

### Database Backup
```bash
docker exec invoiceninja-mariadb mysqldump -u root -p${DB_ROOT_PASSWORD} invoiceninja > backup.sql
```

### File Backup
```bash
docker run --rm -v invoiceninja_invoiceninja-storage:/data -v $(pwd):/backup alpine tar czf /backup/storage-backup.tar.gz -C /data .
```

## Troubleshooting

Enable debug mode for more detailed error messages:

1. Edit `.env` and set:
   ```env
   APP_DEBUG=true
   ```

2. Restart the application:
   ```bash
   docker compose restart invoiceninja
   ```

3. Check logs:
   ```bash
   docker compose logs -f invoiceninja
   ```

Remember to disable debug mode in production!

## Security Notes

- Always use HTTPS in production
- Change default passwords immediately
- Keep the `.env` file secure and never commit it to git
- Regularly update Docker images and the application

## Support

For issues specific to this Docker setup, please check the existing issues or create a new one.