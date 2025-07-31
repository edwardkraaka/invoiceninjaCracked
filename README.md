# Invoice Ninja Custom Edition

A customized version of Invoice Ninja v5 with all premium features enabled and white-label branding removed.

## ⚠️ Disclaimer

This repository is for **educational and testing purposes only**. Invoice Ninja is a commercial product, and this modification bypasses their licensing system. Please consider purchasing a legitimate license from [Invoice Ninja](https://www.invoiceninja.com) to support the developers.

## Features

This custom edition includes:

- ✅ **All Premium Features Enabled**
  - Unlimited clients
  - Custom invoice designs
  - API access
  - Advanced reports
  - Email templates and reminders
  - Buy now buttons
  - Client portal password protection
  - Custom URLs

- ✅ **Enterprise Features**
  - Multi-user support
  - User permissions
  - Document management
  - White label (Invoice Ninja branding removed)

- ✅ **Docker Setup**
  - Custom Docker build with modifications pre-applied
  - Nginx Proxy Manager compatible (PHP-FPM on port 9000)
  - Includes MySQL and Redis

## Quick Start

### Prerequisites

- Docker and Docker Compose
- Nginx Proxy Manager (optional, for web access)
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/invoiceninja-custom.git
   cd invoiceninja-custom
   ```

2. **Configure environment**
   ```bash
   cp .env.custom .env
   # Edit .env with your settings
   ```

3. **Deploy with Docker**
   ```bash
   ./deploy.sh
   ```

4. **Configure Nginx Proxy Manager**
   - See [NGINX_PROXY_MANAGER_SETUP.md](NGINX_PROXY_MANAGER_SETUP.md)

### Manual Build

```bash
# Build the custom Docker image
docker-compose -f docker-compose.custom.yml build

# Start services
docker-compose -f docker-compose.custom.yml up -d
```

## Architecture

### Modifications

The paywall bypass is implemented through minimal changes to:
- `app/Models/Account.php` - Feature validation methods

Key methods modified:
- `isPaid()` → Always returns `true`
- `isPremium()` → Always returns `true`
- `hasFeature()` → All features return `true`

### Docker Structure

```
├── Dockerfile.custom         # Custom build with modifications
├── docker-compose.custom.yml # Without Nginx, PHP-FPM exposed
├── .env.custom              # Pre-configured environment
└── invoiceninja/            # Modified source code
```

## Configuration

### Environment Variables

Key variables in `.env`:
- `NINJA_ENVIRONMENT=selfhost` - Enables self-hosted mode
- `APP_URL` - Your domain URL
- `DB_*` - Database credentials
- `IN_USER_EMAIL` / `IN_PASSWORD` - Initial admin credentials

### Nginx Proxy Manager

For FastCGI configuration:
```nginx
location ~ \.php$ {
    fastcgi_pass app:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME /var/www/html/public$fastcgi_script_name;
    include fastcgi_params;
}
```

## Maintenance

### Backup

```bash
# Backup volumes
docker run --rm -v invoiceninja_app_storage:/data -v $(pwd):/backup alpine \
    tar czf /backup/storage-backup.tar.gz -C /data .
```

### Update

```bash
# Pull latest changes
git pull

# Rebuild
docker-compose -f docker-compose.custom.yml build --no-cache
docker-compose -f docker-compose.custom.yml up -d
```

### Logs

```bash
# View all logs
docker-compose -f docker-compose.custom.yml logs -f

# App logs only
docker-compose -f docker-compose.custom.yml logs -f app
```

## Troubleshooting

See [DOCKER_TROUBLESHOOTING.md](DOCKER_TROUBLESHOOTING.md) for common issues.

## Documentation

- [Paywall Bypass Details](PAYWALL_BYPASS_SUMMARY.md)
- [Nginx Proxy Manager Setup](NGINX_PROXY_MANAGER_SETUP.md)
- [Docker Troubleshooting](DOCKER_TROUBLESHOOTING.md)

## Security Notes

- Always use HTTPS in production
- Change default passwords
- Keep the repository private
- Regular backups recommended
- Monitor for security updates

## Credits

Based on [Invoice Ninja](https://github.com/invoiceninja/invoiceninja) v5.

## License

This modification is provided as-is for educational purposes. Invoice Ninja is licensed under the Elastic License. Please respect the original license terms and consider purchasing a legitimate license.