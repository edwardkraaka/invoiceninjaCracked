#!/bin/sh -eu

# Set PDF generation browser path based on architecture
if [ "$(dpkg --print-architecture)" = "amd64" ]; then
    export SNAPPDF_CHROMIUM_PATH=/usr/bin/google-chrome-stable
elif [ "$(dpkg --print-architecture)" = "arm64" ]; then
    export SNAPPDF_CHROMIUM_PATH=/usr/bin/chromium
fi

# Create MySQL config to disable SSL
cat > /root/.my.cnf <<EOF
[client]
ssl-mode=DISABLED
ssl=0
EOF

if [ "$*" = 'supervisord -c /etc/supervisor/conf.d/supervisord.conf' ]; then

    # Check for required folders and create if needed
    [ -d /var/www/html/storage/framework/sessions ] || mkdir -p /var/www/html/storage/framework/sessions
    [ -d /var/www/html/storage/framework/views ] || mkdir -p /var/www/html/storage/framework/views
    [ -d /var/www/html/storage/framework/cache ] || mkdir -p /var/www/html/storage/framework/cache

    # Workaround for application updates
    if [ "$(ls -A /tmp/public)" ]; then
        echo "Updating public folder..."
        rm -rf /var/www/html/public/.htaccess \
            /var/www/html/public/.well-known \
            /var/www/html/public/*
        mv /tmp/public/* \
            /tmp/public/.htaccess \
            /tmp/public/.well-known \
            /var/www/html/public/
    fi
    echo "Public Folder is up to date"

    # Create symlink for React assets if it doesn't exist
    if [ ! -L /var/www/html/public/react ]; then
        echo "Creating symlink for React assets..."
        ln -sf /var/www/html/public/react-app/react /var/www/html/public/react
    fi

    # Create symlink for TinyMCE assets if it doesn't exist
    if [ ! -L /var/www/html/public/tinymce_6.4.2 ]; then
        echo "Creating symlink for TinyMCE assets..."
        ln -sf /var/www/html/public/react-app/tinymce_6.4.2 /var/www/html/public/tinymce_6.4.2
    fi

    # Create storage symlink if it doesn't exist
    if [ ! -L /var/www/html/public/storage ]; then
        echo "Creating storage symlink..."
        rm -rf /var/www/html/public/storage 2>/dev/null || true
        runuser -u www-data -- php artisan storage:link || {
            echo "artisan storage:link failed, creating manually..."
            ln -sf /var/www/html/storage/app/public /var/www/html/public/storage
        }
    fi

    # Ensure owner, file and directory permissions are correct
    chown -R www-data:www-data \
        /var/www/html/public \
        /var/www/html/storage
    find /var/www/html/public \
        /var/www/html/storage \
        -type f -exec chmod 644 {} \;
    find /var/www/html/public \
        /var/www/html/storage \
        -type d -exec chmod 755 {} \;

    # Clear and cache config in production
    if [ "$APP_ENV" = "production" ]; then
        # Disable SSL in Laravel database config
        sed -i "s/'strict' => true/'strict' => false/g" /var/www/html/config/database.php 2>/dev/null || true
        
        # Skip schema loading and run migrations directly
        runuser -u www-data -- php artisan optimize
        runuser -u www-data -- php artisan package:discover
        
        # Run migrations - this will apply all migrations including our custom_value fixes
        runuser -u www-data -- php artisan migrate --force --no-interaction || {
            echo "Migration failed, trying without schema..."
            rm -f /var/www/html/database/schema/mysql-schema.sql 2>/dev/null || true
            runuser -u www-data -- php artisan migrate --force --no-interaction
        }

        # If first IN run, it needs to be initialized
        if [ "$(php -d opcache.preload='' artisan tinker --execute='echo Schema::hasTable("accounts") && !App\Models\Account::all()->first();')" = "1" ]; then
            echo "Running initialization..."

            php artisan db:seed --force

            if [ -n "${IN_USER_EMAIL}" ] && [ -n "${IN_PASSWORD}" ]; then
                php artisan ninja:create-account --email "${IN_USER_EMAIL}" --password "${IN_PASSWORD}"
            else
                echo "Initialization failed - Set IN_USER_EMAIL and IN_PASSWORD in .env"
                exit 1
            fi
        fi

        echo "Production setup completed"
    fi

    # Clear and rebuild config cache to ensure REACT_URL is properly set
    echo "Clearing and rebuilding Laravel config cache..."
    php artisan config:clear
    php artisan config:cache

    echo "Starting supervisord..."
fi

exec "$@"