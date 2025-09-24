#!/bin/bash

# Invoice Ninja Deployment Verification Script
# This script checks that all components are working correctly after deployment

set -e

echo "================================================"
echo "Invoice Ninja Deployment Verification"
echo "================================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check function
check() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
        return 0
    else
        echo -e "${RED}✗${NC} $2"
        return 1
    fi
}

# Warning function
warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

ERRORS=0

# 1. Check Docker containers are running
echo "1. Checking Docker containers..."
echo "--------------------------------"

CONTAINERS=("invoiceninja" "invoiceninja-nginx" "invoiceninja-mariadb" "invoiceninja-redis")
for container in "${CONTAINERS[@]}"; do
    if docker ps --format '{{.Names}}' | grep -q "^${container}$"; then
        STATUS=$(docker inspect -f '{{.State.Status}}' "$container" 2>/dev/null)
        if [ "$STATUS" = "running" ]; then
            check 0 "$container is running"
        else
            check 1 "$container status: $STATUS"
            ((ERRORS++))
        fi
    else
        check 1 "$container not found"
        ((ERRORS++))
    fi
done
echo ""

# 2. Check container health
echo "2. Checking container health..."
echo "--------------------------------"

HEALTH_CONTAINERS=("invoiceninja" "invoiceninja-mariadb" "invoiceninja-redis")
for container in "${HEALTH_CONTAINERS[@]}"; do
    if docker ps --format '{{.Names}}' | grep -q "^${container}$"; then
        HEALTH=$(docker inspect -f '{{.State.Health.Status}}' "$container" 2>/dev/null || echo "none")
        if [ "$HEALTH" = "healthy" ] || [ "$HEALTH" = "none" ]; then
            check 0 "$container health: ${HEALTH:-no healthcheck}"
        else
            check 1 "$container health: $HEALTH"
            ((ERRORS++))
        fi
    fi
done
echo ""

# 3. Check file structure inside container
echo "3. Checking file structure..."
echo "------------------------------"

# Check React app directory
if docker exec invoiceninja test -d /var/www/html/public/react-app 2>/dev/null; then
    check 0 "React app directory exists"
else
    check 1 "React app directory missing"
    ((ERRORS++))
fi

# Check React bundles
BUNDLE_COUNT=$(docker exec invoiceninja sh -c 'ls /var/www/html/public/react-app/react/index-*.js 2>/dev/null | wc -l' 2>/dev/null || echo 0)
if [ "$BUNDLE_COUNT" -gt 0 ]; then
    check 0 "React bundles found: $BUNDLE_COUNT file(s)"
    if [ "$BUNDLE_COUNT" -gt 1 ]; then
        warn "Multiple bundle files detected. This may cause issues."
    fi
else
    check 1 "No React bundles found"
    ((ERRORS++))
fi

# Check TinyMCE directory
if docker exec invoiceninja test -d /var/www/html/public/react-app/tinymce_6.4.2 2>/dev/null; then
    check 0 "TinyMCE directory exists"
else
    check 1 "TinyMCE directory missing"
    ((ERRORS++))
fi

# Check symlinks
echo ""
echo "4. Checking symlinks..."
echo "-----------------------"

# React symlink
REACT_LINK=$(docker exec invoiceninja sh -c 'readlink /var/www/html/public/react 2>/dev/null' || echo "missing")
if [ "$REACT_LINK" = "/var/www/html/public/react-app/react" ]; then
    check 0 "React symlink correct"
elif [ "$REACT_LINK" = "missing" ]; then
    check 1 "React symlink missing"
    ((ERRORS++))
else
    check 1 "React symlink incorrect: $REACT_LINK"
    ((ERRORS++))
fi

# TinyMCE symlink
TINYMCE_LINK=$(docker exec invoiceninja sh -c 'readlink /var/www/html/public/tinymce_6.4.2 2>/dev/null' || echo "missing")
if [ "$TINYMCE_LINK" = "/var/www/html/public/react-app/tinymce_6.4.2" ]; then
    check 0 "TinyMCE symlink correct"
elif [ "$TINYMCE_LINK" = "missing" ]; then
    check 1 "TinyMCE symlink missing"
    ((ERRORS++))
else
    check 1 "TinyMCE symlink incorrect: $TINYMCE_LINK"
    ((ERRORS++))
fi

# 5. Check web accessibility
echo ""
echo "5. Checking web accessibility..."
echo "---------------------------------"

# Get APP_URL from .env
if [ -f .env ]; then
    APP_URL=$(grep "^APP_URL=" .env | cut -d '=' -f2 | tr -d '"' | tr -d "'")
    if [ -n "$APP_URL" ]; then
        echo "Testing $APP_URL..."

        # Check main page
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$APP_URL" 2>/dev/null || echo "000")
        if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "301" ] || [ "$HTTP_CODE" = "302" ]; then
            check 0 "Main page accessible (HTTP $HTTP_CODE)"
        else
            check 1 "Main page returned HTTP $HTTP_CODE"
            ((ERRORS++))
        fi

        # Check API health
        API_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$APP_URL/api/v1/health" 2>/dev/null || echo "000")
        if [ "$API_CODE" = "200" ]; then
            check 0 "API health check passed"
        else
            check 1 "API health check failed (HTTP $API_CODE)"
            ((ERRORS++))
        fi
    else
        warn "APP_URL not found in .env file"
    fi
else
    warn ".env file not found"
fi

# 6. Check database connectivity
echo ""
echo "6. Checking database..."
echo "------------------------"

DB_CHECK=$(docker exec invoiceninja php artisan tinker --execute="echo DB::connection()->getPdo() ? 'connected' : 'failed';" 2>/dev/null | grep -o 'connected\|failed' || echo "error")
if [ "$DB_CHECK" = "connected" ]; then
    check 0 "Database connection successful"
else
    check 1 "Database connection failed"
    ((ERRORS++))
fi

# Summary
echo ""
echo "================================================"
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    echo "Your Invoice Ninja deployment appears to be working correctly."
else
    echo -e "${RED}✗ $ERRORS check(s) failed${NC}"
    echo "Please review the errors above and check the logs:"
    echo "  docker compose logs -f"
fi
echo "================================================"

exit $ERRORS