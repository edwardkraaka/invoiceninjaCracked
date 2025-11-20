# Invoice Ninja Deployment Debug Guide

## Issue: Database user and admin password not working

### Quick Diagnosis Commands

Run these commands on your server to diagnose the issue:

```bash
# 1. Check if .env file is mounted in the container
docker exec invoiceninja cat /var/www/html/.env | grep -E "DB_|IN_USER"

# 2. Check MariaDB users
docker exec invoiceninja-mariadb mysql -u root -pRemunerationPendantBroomIntrusion -e "SELECT user, host FROM mysql.user;"

# 3. Check if database exists
docker exec invoiceninja-mariadb mysql -u root -pRemunerationPendantBroomIntrusion -e "SHOW DATABASES;"

# 4. Check if invoiceninja user can access the database
docker exec invoiceninja-mariadb mysql -u invoiceninja -pGotDiscardConsonantChauffeur -e "USE invoiceninja; SHOW TABLES;"

# 5. Check if migrations ran (check for users table)
docker exec invoiceninja-mariadb mysql -u root -pRemunerationPendantBroomIntrusion invoiceninja -e "SHOW TABLES LIKE 'users';"

# 6. Check if admin user exists
docker exec invoiceninja-mariadb mysql -u root -pRemunerationPendantBroomIntrusion invoiceninja -e "SELECT email FROM users LIMIT 5;"

# 7. Check Invoice Ninja logs
docker logs invoiceninja --tail 100
```

---

## Solution Paths

### Solution 1: Database User Doesn't Exist (Most Likely)

**Symptom:** Error connecting to database or "Access denied for user 'invoiceninja'"

**Fix:**
```bash
# Connect to MariaDB as root and create the user manually
docker exec -it invoiceninja-mariadb mysql -u root -pRemunerationPendantBroomIntrusion

# Then run these SQL commands:
CREATE DATABASE IF NOT EXISTS invoiceninja CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS 'invoiceninja'@'%' IDENTIFIED BY 'GotDiscardConsonantChauffeur';
GRANT ALL PRIVILEGES ON invoiceninja.* TO 'invoiceninja'@'%';
FLUSH PRIVILEGES;
EXIT;

# Restart the Invoice Ninja container
docker restart invoiceninja

# Check logs
docker logs -f invoiceninja
```

---

### Solution 2: Migrations Didn't Run

**Symptom:** Database exists but no tables or empty users table

**Fix:**
```bash
# Run migrations manually
docker exec invoiceninja php artisan migrate --force

# Check if it worked
docker exec invoiceninja php artisan tinker --execute="echo User::count();"
```

---

### Solution 3: Admin User Doesn't Exist

**Symptom:** Can't login with IN_USER_EMAIL and IN_PASSWORD

**Fix Option A - Create via Artisan:**
```bash
# Create admin account manually
docker exec invoiceninja php artisan ninja:create-account \
  --email=support@routespring.shop \
  --password=CantHaCk101 \
  --first_name=Admin \
  --last_name=User
```

**Fix Option B - Reset Admin Password:**
```bash
# If user exists but password is wrong, reset it via database
docker exec invoiceninja-mariadb mysql -u root -pRemunerationPendantBroomIntrusion invoiceninja -e "
UPDATE users 
SET password = '\$2y\$10\$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi' 
WHERE email = 'support@routespring.shop';
"

# This sets password to: password
# Login with: support@routespring.shop / password
# Then change it in settings
```

---

### Solution 4: Complete Reset (Nuclear Option)

**If nothing else works, start fresh:**

```bash
# Stop and remove containers
cd /path/to/invoiceninja
docker compose down

# Remove volumes (THIS DELETES ALL DATA!)
docker volume rm invoiceninja_invoiceninja-mariadb-data
docker volume rm invoiceninja_invoiceninja-storage
docker volume rm invoiceninja_invoiceninja-public

# Ensure .env file is in the correct location
# Should be in same directory as docker-compose.yml
ls -la .env

# Start fresh
docker compose up -d

# Watch logs to see initialization
docker logs -f invoiceninja
```

---

## Common Issues & Fixes

### Issue: ".env file not found" in logs

**Cause:** .env file not mounted correctly in docker-compose.yml

**Fix:**
```yaml
# Check docker-compose.yml has:
volumes:
  - ./.env:/var/www/html/.env:ro
```

### Issue: "SQLSTATE[HY000] [1045] Access denied"

**Cause:** Database credentials mismatch

**Fix:**
1. Check what's in the container's .env: `docker exec invoiceninja cat /var/www/html/.env`
2. Check what's in your host .env: `cat .env`
3. Make sure they match
4. Restart container: `docker restart invoiceninja`

### Issue: "Base table or view not found"

**Cause:** Migrations didn't run

**Fix:**
```bash
docker exec invoiceninja php artisan migrate --force
```

### Issue: Login page loads but credentials don't work

**Cause:** Admin user wasn't created or password is different

**Fix:**
```bash
# Check if any users exist
docker exec invoiceninja php artisan tinker --execute="User::all()->pluck('email');"

# Create new admin
docker exec invoiceninja php artisan ninja:create-account \
  --email=support@routespring.shop \
  --password=CantHaCk101
```

---

## Verification Checklist

After applying fixes, verify everything works:

- [ ] Database user exists and can connect
  ```bash
  docker exec invoiceninja-mariadb mysql -u invoiceninja -pGotDiscardConsonantChauffeur -e "SELECT 1;"
  ```

- [ ] Tables exist
  ```bash
  docker exec invoiceninja-mariadb mysql -u invoiceninja -pGotDiscardConsonantChauffeur invoiceninja -e "SHOW TABLES;" | wc -l
  # Should show 80+ tables
  ```

- [ ] Admin user exists
  ```bash
  docker exec invoiceninja-mariadb mysql -u root -pRemunerationPendantBroomIntrusion invoiceninja -e "SELECT email, created_at FROM users;"
  ```

- [ ] Can access web interface
  ```bash
  curl -I https://invoicing.peekpro.org
  # Should return 200 OK
  ```

- [ ] Can login with credentials
  - Go to https://invoicing.peekpro.org
  - Login: support@routespring.shop
  - Password: CantHaCk101

---

## Understanding the Flow

When containers start for the first time:

1. **MariaDB container** starts
   - Reads MYSQL_* environment variables
   - Creates database and user
   - Initializes with default data

2. **Invoice Ninja container** starts
   - Runs `/usr/local/bin/init.sh`
   - Waits for database
   - Runs `php artisan migrate`
   - Creates admin account from IN_USER_EMAIL/IN_PASSWORD
   - Starts PHP-FPM

If the .env wasn't properly configured when containers first started, steps 1 and 2 used wrong values!

---

## What to Run First

Based on your output, **start with these commands**:

```bash
# 1. Check if database user exists
echo "Checking database user..."
docker exec invoiceninja-mariadb mysql -u root -pRemunerationPendantBroomIntrusion -e "SELECT user, host FROM mysql.user WHERE user='invoiceninja';"

# 2. Check if migrations ran
echo "Checking tables..."
docker exec invoiceninja-mariadb mysql -u root -pRemunerationPendantBroomIntrusion invoiceninja -e "SHOW TABLES;" 2>&1 | head -20

# 3. Check for admin user
echo "Checking for admin user..."
docker exec invoiceninja-mariadb mysql -u root -pRemunerationPendantBroomIntrusion invoiceninja -e "SELECT email FROM users WHERE email='support@routespring.shop';" 2>&1

# Based on the output above, follow the appropriate solution path
```

Run these three commands first and share the output - I'll tell you exactly what to do next!

