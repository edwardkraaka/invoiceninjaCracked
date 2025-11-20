# Invoice Ninja Codebase - Complete Index

**Generated:** November 19, 2025  
**Version:** Invoice Ninja v5.11.43 Custom Edition  
**Purpose:** Comprehensive index and reference for the entire codebase

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture & Tech Stack](#architecture--tech-stack)
3. [Directory Structure](#directory-structure)
4. [Core Application](#core-application)
5. [Frontend/UI](#frontendui)
6. [Docker Infrastructure](#docker-infrastructure)
7. [Database Structure](#database-structure)
8. [API Endpoints](#api-endpoints)
9. [Key Modifications (Paywall Bypass)](#key-modifications-paywall-bypass)
10. [Configuration Files](#configuration-files)
11. [Deployment & Operations](#deployment--operations)
12. [Development Resources](#development-resources)

---

## Project Overview

### What is This?

A customized version of **Invoice Ninja v5** with all premium features enabled and white-label branding removed. Built as a Docker-based application with:

- **Backend**: Laravel 11 (PHP 8.3)
- **Frontend**: React (TypeScript) + Livewire
- **Database**: MariaDB 10.6
- **Cache**: Redis
- **Web Server**: Nginx

### Key Features Enabled

✅ All Premium Features (bypassed paywall)
- Unlimited clients
- Custom invoice designs
- Full API access
- Advanced reports
- Email templates & reminders
- Buy now buttons
- Client portal password protection
- Custom URLs

✅ Enterprise Features
- Multi-user support
- User permissions
- Document management
- White label (Invoice Ninja branding removed)

### Repository Structure

```
/Users/user/Desktop/scripts/invoiceninja/
├── invoiceninjaCracked/          # Main application directory
│   ├── invoiceninja/             # Laravel backend (modified)
│   ├── invoiceninjaUi/           # React frontend
│   ├── dockerfiles/              # Docker build configurations
│   ├── patches/                  # Paywall bypass patches
│   └── nginx/                    # Nginx configuration
├── docker-compose.yml            # Main Docker orchestration
├── mariadb/                      # Database data & config
├── nginx/                        # Nginx proxy configuration
└── README*.md                    # Documentation files
```

---

## Architecture & Tech Stack

### Backend Stack

| Component | Version | Purpose |
|-----------|---------|---------|
| PHP | 8.3 | Runtime environment |
| Laravel | 11.x | Web framework |
| Composer | Latest | PHP dependency manager |
| PHP-FPM | 8.3 | PHP FastCGI process manager |
| MariaDB | 10.6 | Primary database |
| Redis | Alpine | Cache & session storage |

### Frontend Stack

| Component | Version | Purpose |
|-----------|---------|---------|
| React | Latest | Admin UI framework |
| TypeScript | Latest | Type-safe development |
| Vite | 4.4.9 | Build tool |
| TailwindCSS | 3.4.1 | CSS framework |
| Livewire | 3.x | Real-time components |

### Infrastructure

| Component | Version | Purpose |
|-----------|---------|---------|
| Docker | Latest | Containerization |
| Nginx | Latest | Reverse proxy |
| Supervisor | Latest | Process manager |
| Node.js | 20.17.0 | JavaScript runtime |

### Key PHP Extensions

- bcmath, gd, mbstring, pdo_mysql, zip (required)
- exif, imagick, intl, pcntl, soap (suggested)
- opcache (optimization)

---

## Directory Structure

### Root Directory (`/invoiceninja/`)

```
/invoiceninja/
├── invoiceninjaCracked/          # Application source
├── mariadb/                      # Database persistence
│   ├── custom.cnf               # MariaDB configuration
│   ├── databases/               # Database files
│   └── log/                     # Database logs
├── nginx/                        # Web server config
│   └── in-vhost.conf            # Virtual host config
├── docker-compose.yml            # Service orchestration
├── nginx-invoiceninja.conf       # Additional nginx config
├── verify-deployment.sh          # Deployment verification script
├── README.md                     # Main documentation
├── README-DOCKER.md              # Docker-specific docs
└── CLAUDE.md                     # AI assistant notes
```

### Application Directory (`/invoiceninjaCracked/`)

```
/invoiceninjaCracked/
├── invoiceninja/                 # Laravel backend application
├── invoiceninjaUi/               # React frontend application
├── dockerfiles/                  # Docker build files
├── patches/                      # Code modifications
├── nginx/                        # Nginx configuration
├── deploy.sh                     # Deployment script
├── push-to-github.sh             # Git helper script
├── test_bypass.php               # Test script for bypass
├── Dockerfile.custom             # Custom Docker image
├── README.md                     # Project documentation
├── CLAUDE.md                     # Development notes
├── DOCKER_TROUBLESHOOTING.md     # Docker issue guide
├── NGINX_PROXY_MANAGER_SETUP.md  # NPM setup guide
└── PAYWALL_BYPASS_SUMMARY.md     # Bypass documentation
```

---

## Core Application

### Laravel Backend (`/invoiceninja/`)

#### Main Application Directory (`app/`)

**Models** (`app/Models/`)
- 86 model files representing database entities
- Key models:
  - `Account.php` ⭐ (Modified for paywall bypass)
  - `Invoice.php`, `Quote.php`, `Credit.php`
  - `Client.php`, `Vendor.php`
  - `Payment.php`, `Product.php`
  - `User.php`, `Company.php`
  - `Subscription.php`, `PurchaseOrder.php`

**Controllers** (`app/Http/Controllers/`)
- 80+ controller files
- Main controllers:
  - `InvoiceController.php` - Invoice management
  - `ClientController.php` - Client operations
  - `PaymentController.php` - Payment processing
  - `QuoteController.php` - Quote management
  - `ExpenseController.php` - Expense tracking
  - `ProductController.php` - Product catalog
  - `VendorController.php` - Vendor management
  - `ProjectController.php` - Project management
  - `TaskController.php` - Task tracking
  - `ReportController.php` - Reporting system

**API Controllers** (`app/Http/Controllers/`)
- Auth controllers (Login, Reset Password, etc.)
- Bank integration controllers (Yodlee, Nordigen)
- Payment gateway controllers (Stripe, PayPal, etc.)
- Report controllers (27 different report types)

**Services** (`app/Services/`)
- 309 service files
- Business logic layer
- Key services:
  - Invoice generation & PDF creation
  - Payment processing
  - Email sending
  - Report generation
  - Import/Export functionality
  - E-invoicing (UBL, ZUGFeRD, etc.)

**Jobs** (`app/Jobs/`)
- 105 job files for async processing
- Queue-based operations:
  - Email sending
  - PDF generation
  - Report generation
  - Data imports
  - Webhook processing

**Events & Listeners** (`app/Events/`, `app/Listeners/`)
- 127 event files
- 122 listener files
- Event-driven architecture for:
  - Invoice creation/updates
  - Payment processing
  - Email notifications
  - Activity logging

**Payment Drivers** (`app/PaymentDrivers/`)
- 117 payment driver files
- Supported gateways:
  - Stripe
  - PayPal
  - Square
  - Authorize.net
  - Braintree
  - GoCardless
  - Mollie
  - And many more...

**Transformers** (`app/Transformers/`)
- 57 transformer files
- API response formatting
- Data serialization

**Repositories** (`app/Repositories/`)
- 37 repository files
- Data access layer
- Query optimization

**Export System** (`app/Export/`)
- 35 export classes
- CSV/Excel export functionality
- Custom report exports

**Import System** (`app/Import/`)
- 42 import classes
- Data migration from other systems
- CSV imports
- QuickBooks integration

#### Database (`database/`)

**Migrations** (`database/migrations/`)
- 276 migration files
- Complete schema history
- Database versioning

**Factories** (`database/factories/`)
- 35 factory files
- Test data generation
- Seeding helpers

**Seeders** (`database/seeders/`)
- 15 seeder files
- Initial data population
- Demo data creation

#### Configuration (`config/`)

Key configuration files:
- `app.php` - Application settings
- `database.php` - Database connections
- `mail.php` - Email configuration
- `queue.php` - Queue drivers
- `filesystems.php` - Storage configuration
- `ninja.php` ⭐ - Invoice Ninja specific settings
- `services.php` - Third-party services
- `cache.php` - Cache configuration
- `session.php` - Session management

#### Routes (`routes/`)

- `api.php` ⭐ - Complete API routing (497 lines)
- `web.php` - Web application routes
- `client.php` - Client portal routes
- `contact.php` - Contact routes
- `vendor.php` - Vendor portal routes
- `shop.php` - Shop routes
- `console.php` - Console commands
- `channels.php` - Broadcasting channels

#### Resources (`resources/`)

**Views** (`resources/views/`)
- 524 Blade template files
- Email templates
- PDF templates
- Client portal views
- Admin interface views

**JavaScript** (`resources/js/`)
- 53 JavaScript files
- Livewire components
- Client portal functionality

**Sass** (`resources/sass/`)
- 7 SCSS files
- Custom styling

#### Public Assets (`public/`)

- `index.php` - Application entry point
- `react-app/` - Built React admin UI
- `images/` - 63 image files
- `assets/` - 306 asset files (logos, fonts, etc.)
- `build-admin/` - Vite build outputs
- Flutter assets (for mobile app)

#### Language Files (`lang/`)

43 language directories with translations:
- English (en, en_GB)
- Spanish (es, es_ES)
- French (fr, fr_CA, fr_CH)
- German (de)
- Italian (it)
- Portuguese (pt_BR, pt_PT)
- Japanese (ja)
- Chinese (zh_TW)
- And 30+ more languages

#### Tests (`tests/`)

- 350 test files
- Unit tests
- Feature tests
- Integration tests
- API tests

---

## Frontend/UI

### React Admin UI (`/invoiceninjaUi/ui/`)

#### Source Code (`src/`)

**Main Application Files**
- `App.tsx` - Root application component
- `index.tsx` - Entry point
- `routes.tsx` - Route definitions

**Common Components** (`src/common/`)

**Atoms** (`src/common/atoms/`)
- `data-table.ts` - Table state management
- `password-confirmation.ts` - Password handling
- `settings.ts` - Settings state

**Constants** (`src/common/constants/`)
- 36 constant files
- API endpoints
- Enumerations
- Configuration values

**Enums** (`src/common/enums/`)
- 16 enum files
- Type definitions
- Status codes

**Guards** (`src/common/guards/`)
- 11 guard files
- Route protection
- Permission checking

**Helpers** (`src/common/helpers/`)
- Currency formatting
- Date handling
- Number formatting
- Email utilities
- Invoice helpers
- Tax calculations

**Hooks** (`src/common/hooks/`)
- 89 custom React hooks
- Data fetching
- State management
- Form handling

**Interfaces** (`src/common/interfaces/`)
- 61 TypeScript interface files
- Type definitions for:
  - Clients
  - Invoices
  - Payments
  - Products
  - Users
  - Settings
  - And more...

**Queries** (`src/common/queries/`)
- 33 query files
- React Query definitions
- API call abstractions

**Components** (`src/components/`)
- 210 reusable component files
- UI elements:
  - Forms
  - Tables
  - Modals
  - Buttons
  - Cards
  - Charts
  - Dropdowns

**Pages** (`src/pages/`)

Major page sections:
- `authentication/` - Login, signup, password reset (14 files)
- `clients/` - Client management (62 files)
- `invoices/` - Invoice management (79 files)
- `quotes/` - Quote management (33 files)
- `credits/` - Credit management (28 files)
- `payments/` - Payment processing (26 files)
- `expenses/` - Expense tracking (22 files)
- `products/` - Product catalog (18 files)
- `projects/` - Project management (15 files)
- `tasks/` - Task management (36 files)
- `vendors/` - Vendor management (19 files)
- `purchase-orders/` - PO management (32 files)
- `recurring-invoices/` - Recurring billing (28 files)
- `recurring-expenses/` - Recurring expenses (15 files)
- `reports/` - Reporting system (16 files)
- `settings/` - Application settings (334 files)
- `transactions/` - Bank transactions (25 files)
- `dashboard/` - Main dashboard (18 files)

**Resources** (`src/resources/`)
- CSS files
- Language files (43 JSON translation files)
- Images
- E-invoice schemas

**Tests** (`tests/`)
- E2E tests (Playwright)
- Unit tests (Jest)
- Test helpers

#### Build Configuration

- `vite.config.js` - Vite build configuration
- `tailwind.config.js` - TailwindCSS configuration
- `tsconfig.json` - TypeScript configuration
- `package.json` - Dependencies and scripts
- `postcss.config.cjs` - PostCSS configuration
- `eslint.config.js` - ESLint rules

#### Dependencies

**Production Dependencies:**
- React & React DOM
- React Router
- React Query
- Axios
- Formik & Yup
- Date-fns
- Recharts
- And 100+ more...

**Development Dependencies:**
- Vite
- TypeScript
- Playwright
- Jest
- ESLint
- TailwindCSS

---

## Docker Infrastructure

### Docker Compose Configuration

**Main Services** (`docker-compose.yml`):

1. **nginx** (Port 80, 443)
   - Reverse proxy
   - SSL termination
   - Static file serving

2. **invoiceninja** (Port 9000 - PHP-FPM)
   - Laravel application
   - Custom build with bypass
   - PHP 8.3 with all extensions

3. **mariadb** (Internal)
   - Database server
   - MariaDB 10.6
   - Persistent storage

4. **redis** (Internal)
   - Cache layer
   - Session storage

### Custom Dockerfile (`Dockerfile.custom`)

**Build Stages:**
1. Base PHP-FPM image
2. Install system dependencies
3. Install Node.js 20.17.0
4. Install Chrome/Chromium for PDF
5. Install PHP extensions
6. Install Composer
7. Copy modified Laravel app
8. Run Composer install
9. Build Vite assets
10. Build React UI with custom API URL
11. Configure PHP & PHP-FPM
12. Setup Supervisor
13. Copy init script
14. Verify paywall bypass
15. Set permissions

**Build Arguments:**
- `PHP=8.3` - PHP version
- `VITE_API_URL` - API URL for React build
- `VITE_IS_HOSTED=false` - Deployment type

**Exposed Ports:**
- 9000 (PHP-FPM)

**Health Check:**
- Checks PHP-FPM master process
- Interval: 30s

### Dockerfiles Directory (`dockerfiles/debian/`)

**Nginx Configuration** (`nginx/`)
- `invoiceninja.conf` - Main vhost
- `laravel.conf` - Laravel-specific rules

**PHP Configuration** (`php/`)
- `php.ini` - PHP settings
- `php-fpm.conf` - PHP-FPM pool configuration

**Supervisor** (`supervisor/`)
- `supervisord.conf` - Process management

**Init Scripts** (`scripts/`)
- `init.sh` - Standard initialization
- `init-custom.sh` ⭐ - Custom init with:
  - Wait for database
  - Run migrations
  - Clear cache
  - Generate key
  - Storage link
  - Clean old React bundles
  - Set permissions

### Docker Volumes

Persistent data:
- `invoiceninja-public` - Public assets
- `invoiceninja-storage` - File storage
- `invoiceninja-mariadb-data` - Database
- `redis-data` - Cache data

### Network

- `invoiceninja-network` - Bridge network for service communication

---

## Database Structure

### Main Tables

**User & Account Management**
- `accounts` - Account information ⭐ (Modified for bypass)
- `users` - User accounts
- `company_users` - User-company relationships
- `companies` - Company/organization data
- `company_tokens` - API tokens

**Client Management**
- `clients` - Client records
- `client_contacts` - Contact information
- `client_gateway_tokens` - Payment methods

**Invoicing**
- `invoices` - Invoice records
- `invoice_invitations` - Invoice links
- `recurring_invoices` - Recurring billing
- `recurring_invoice_invitations` - Recurring links

**Quotes & Credits**
- `quotes` - Quote records
- `quote_invitations` - Quote links
- `credits` - Credit notes
- `credit_invitations` - Credit links

**Payments**
- `payments` - Payment records
- `paymentables` - Payment relationships
- `payment_hashes` - Payment tracking
- `payment_terms` - Payment terms

**Products & Services**
- `products` - Product catalog
- `product_key` - Product identifiers

**Expenses**
- `expenses` - Expense records
- `expense_categories` - Expense types
- `recurring_expenses` - Recurring expenses

**Vendors**
- `vendors` - Vendor records
- `vendor_contacts` - Vendor contacts
- `purchase_orders` - PO records
- `purchase_order_invitations` - PO links

**Projects & Tasks**
- `projects` - Project records
- `tasks` - Task entries
- `task_statuses` - Task states

**Banking**
- `bank_integrations` - Bank connections
- `bank_transactions` - Transaction records
- `bank_transaction_rules` - Auto-matching rules

**Configuration**
- `designs` - Invoice designs
- `group_settings` - Client groups
- `tax_rates` - Tax configuration
- `payment_libraries` - Payment gateways
- `company_gateways` - Gateway configs

**System**
- `activities` - Activity log
- `system_logs` - System events
- `webhooks` - Webhook endpoints
- `documents` - File attachments
- `schedulers` - Task scheduling

**E-Invoicing**
- `einvoicing_logs` - E-invoice logs
- `einvoicing_tokens` - E-invoice tokens

### Database Schema Files

Located in `database/schema/`:
- SQL schema dumps
- Migration history

---

## API Endpoints

### Authentication

```
POST /api/v1/login         - User login
POST /api/v1/signup        - User registration
POST /api/v1/oauth_login   - OAuth login
POST /api/v1/logout        - User logout
POST /api/v1/refresh       - Refresh token
POST /api/v1/reset_password - Password reset
```

### Core Resources

All following use standard REST conventions (index, create, show, update, destroy):

**Client Management**
```
/api/v1/clients
/api/v1/clients/{id}/upload
/api/v1/clients/{id}/purge
/api/v1/clients/{id}/merge
/api/v1/clients/bulk
```

**Invoicing**
```
/api/v1/invoices
/api/v1/invoices/{id}/upload
/api/v1/invoices/{id}/{action}
/api/v1/invoices/bulk
/api/v1/invoice/{invitation_key}/download
/api/v1/invoice/{invitation_key}/download_e_invoice
```

**Quotes**
```
/api/v1/quotes
/api/v1/quotes/{id}/upload
/api/v1/quotes/{id}/{action}
/api/v1/quotes/bulk
/api/v1/quote/{invitation_key}/download
```

**Credits**
```
/api/v1/credits
/api/v1/credits/{id}/upload
/api/v1/credits/{id}/{action}
/api/v1/credits/bulk
```

**Payments**
```
/api/v1/payments
/api/v1/payments/refund
/api/v1/payments/bulk
/api/v1/payments/{id}/upload
```

**Products**
```
/api/v1/products
/api/v1/products/bulk
/api/v1/products/{id}/upload
```

**Expenses**
```
/api/v1/expenses
/api/v1/expenses/bulk
/api/v1/expenses/{id}/upload
/api/v1/expense_categories
```

**Vendors**
```
/api/v1/vendors
/api/v1/vendors/bulk
/api/v1/vendors/{id}/upload
/api/v1/vendors/{id}/merge
```

**Purchase Orders**
```
/api/v1/purchase_orders
/api/v1/purchase_orders/bulk
/api/v1/purchase_orders/{id}/upload
/api/v1/purchase_order/{invitation_key}/download
```

**Projects & Tasks**
```
/api/v1/projects
/api/v1/projects/bulk
/api/v1/tasks
/api/v1/tasks/bulk
/api/v1/tasks/sort
/api/v1/task_statuses
```

**Recurring Items**
```
/api/v1/recurring_invoices
/api/v1/recurring_expenses
/api/v1/recurring_quotes
```

### Banking Integration

```
/api/v1/bank_integrations
/api/v1/bank_integrations/refresh_accounts
/api/v1/bank_transactions
/api/v1/bank_transactions/match
/api/v1/bank_transaction_rules
```

### Reports

```
POST /api/v1/reports/clients
POST /api/v1/reports/invoices
POST /api/v1/reports/payments
POST /api/v1/reports/expenses
POST /api/v1/reports/products
POST /api/v1/reports/quotes
POST /api/v1/reports/tasks
POST /api/v1/reports/vendors
POST /api/v1/reports/profitloss
POST /api/v1/reports/ar_detail_report
POST /api/v1/reports/ar_summary_report
POST /api/v1/reports/client_balance_report
POST /api/v1/reports/tax_summary_report
```

### Company & Settings

```
/api/v1/companies
/api/v1/companies/{id}/upload
/api/v1/companies/{id}/logo
/api/v1/company_gateways
/api/v1/company_users
/api/v1/group_settings
/api/v1/designs
/api/v1/tax_rates
/api/v1/payment_terms
```

### Documents & Templates

```
/api/v1/documents
/api/v1/documents/{id}/download
/api/v1/templates
/api/v1/designs
```

### Import/Export

```
POST /api/v1/import         - Import data
POST /api/v1/import_json    - Import JSON
POST /api/v1/preimport      - Pre-import validation
POST /api/v1/export         - Export data
```

### System

```
GET  /api/v1/ping           - Ping test
GET  /api/v1/health_check   - Health status
GET  /api/v1/activities     - Activity log
GET  /api/v1/statics        - Static data
POST /api/v1/search         - Global search
```

### Webhooks

```
/api/v1/webhooks
/api/v1/payment_webhook/{company_key}/{gateway_id}
/api/v1/postmark_webhook
/api/v1/mailgun_webhook
/api/v1/brevo_webhook
```

### E-Invoicing

```
POST /api/v1/einvoice/validateEntity
POST /api/v1/einvoice/configurations
POST /api/v1/einvoice/peppol/setup
GET  /api/v1/einvoice/quota
```

---

## Key Modifications (Paywall Bypass)

### Modified Files

**Primary Modification: `app/Models/Account.php`**

Location: `/invoiceninja/app/Models/Account.php`

#### Changes Made

**1. `isPaid()` Method (Line ~294)**
```php
// Original:
return Ninja::isNinja() ? $this->isPaidHostedClient() : $this->hasFeature(self::FEATURE_WHITE_LABEL);

// Modified to:
return true; // Bypass white label check
```
**Effect:** Removes Invoice Ninja branding from all PDFs and documents

**2. `isPremium()` Method (Line ~296)**
```php
// Original:
return Ninja::isHosted() && $this->isPaidHostedClient() && !$this->isTrial() && Carbon::createFromTimestamp($this->created_at)->diffInMonths() > 2;

// Modified to:
return true; // Enable all premium features
```
**Effect:** Enables all premium functionality

**3. `hasFeature()` Method (Multiple locations)**

All feature checks modified to return `true`:
- `FEATURE_CUSTOMIZE_INVOICE_DESIGN`
- `FEATURE_DIFFERENT_DESIGNS`
- `FEATURE_EMAIL_TEMPLATES_REMINDERS`
- `FEATURE_INVOICE_SETTINGS`
- `FEATURE_CUSTOM_EMAILS`
- `FEATURE_PDF_ATTACHMENT`
- `FEATURE_MORE_INVOICE_DESIGNS`
- `FEATURE_REPORTS`
- `FEATURE_BUY_NOW_BUTTONS`
- `FEATURE_API`
- `FEATURE_CLIENT_PORTAL_PASSWORD`
- `FEATURE_CUSTOM_URL`
- `FEATURE_MORE_CLIENTS`
- `FEATURE_WHITE_LABEL`
- `FEATURE_REMOVE_CREATED_BY`
- `FEATURE_USERS`
- `FEATURE_DOCUMENTS`
- `FEATURE_USER_PERMISSIONS`

### Verification

The Dockerfile includes verification:
```bash
RUN grep -q "return true; // Bypass white label check" /var/www/html/app/Models/Account.php && \
    echo "✓ Paywall bypass verified" || \
    (echo "✗ Paywall bypass NOT found!" && exit 1)
```

### Patch File

Location: `/patches/paywall-bypass.patch`

Can be applied to vanilla Invoice Ninja:
```bash
cd invoiceninja
git apply ../patches/paywall-bypass.patch
```

### Results

✅ White Label - Invoice Ninja branding removed
✅ Premium Features - All premium features enabled
✅ Enterprise Features - Multi-user, docs, permissions
✅ API Access - Full API access enabled
✅ Unlimited Clients - No client limits
✅ Custom Designs - All invoice design features

### Important Notes

- No external license validation calls are made
- No database modifications required
- Environment can remain as `selfhost`
- All changes centralized in one file
- Comprehensive - enables ALL premium features

---

## Configuration Files

### Environment Configuration

**Main .env File** (Root of invoiceninja/)

Key variables:
```env
# Application
APP_NAME=Invoice Ninja
APP_ENV=production
APP_KEY=base64:... (generated)
APP_DEBUG=false
APP_URL=https://your-domain.com

# Database
DB_CONNECTION=mysql
DB_HOST=invoiceninja-mariadb
DB_PORT=3306
DB_DATABASE=invoiceninja
DB_USERNAME=ninja
DB_PASSWORD=your_password
DB_ROOT_PASSWORD=root_password

# Cache & Sessions
REDIS_HOST=redis
REDIS_PASSWORD=null
REDIS_PORT=6379
CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=database

# Mail
MAIL_MAILER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS=null
MAIL_FROM_NAME="${APP_NAME}"

# Invoice Ninja
NINJA_ENVIRONMENT=selfhost
REQUIRE_HTTPS=true
PDF_GENERATOR=snappdf
IS_DOCKER=true

# Admin Account (first run)
IN_USER_EMAIL=admin@example.com
IN_PASSWORD=changeme
```

### Ninja Configuration (`config/ninja.php`)

Key settings:
- Web URL: https://www.invoiceninja.com
- App version: 5.11.43
- Environment: selfhost
- License URL: https://app.invoiceninja.com
- App domain: invoicing.co
- PDF generator settings
- Multi-DB configuration
- I18n defaults

### Laravel Configurations

**app.php** - Application core
- Timezone: UTC
- Locale: en
- Fallback locale: en
- Key: From .env
- Debug: From .env
- URL: From .env

**database.php** - Database connections
- Default: mysql
- Connections: mysql, sqlite, pgsql
- Redis configuration

**mail.php** - Email settings
- Default mailer: From .env
- SMTP configuration
- Mailgun settings
- Postmark settings
- SES settings

**queue.php** - Queue configuration
- Default: database
- Connections: sync, database, redis
- Batch table

**filesystems.php** - Storage
- Default: local
- Disks: local, public, s3
- Cloud: s3

**cache.php** - Cache settings
- Default: redis
- Stores: apc, array, database, file, redis

**session.php** - Session management
- Driver: redis
- Lifetime: 120 minutes
- Cookie settings

### Nginx Configuration

**Main vhost** (`nginx/in-vhost.conf`)
```nginx
server {
    listen 80;
    server_name _;
    root /var/www/html/public;
    index index.php index.html;
    
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    
    location ~ \.php$ {
        fastcgi_pass invoiceninja:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```

### PHP Configuration

**php.ini** (`dockerfiles/debian/php/php.ini`)
- memory_limit = 512M
- upload_max_filesize = 100M
- post_max_size = 100M
- max_execution_time = 300
- date.timezone = UTC

**php-fpm.conf** (`dockerfiles/debian/php/php-fpm.conf`)
- pm = dynamic
- pm.max_children = 10
- pm.start_servers = 2
- pm.min_spare_servers = 1
- pm.max_spare_servers = 3

### Supervisor Configuration

**supervisord.conf** (`dockerfiles/debian/supervisor/supervisord.conf`)
- PHP-FPM process management
- Queue worker management
- Auto-restart on failure

### MariaDB Configuration

**custom.cnf** (`mariadb/custom.cnf`)
- innodb_buffer_pool_size
- max_connections
- query_cache settings

---

## Deployment & Operations

### Deployment Script (`deploy.sh`)

Location: `/invoiceninjaCracked/deploy.sh`

Features:
- Environment check
- .env file creation
- Docker installation verification
- Custom image build
- Service startup
- Status verification

Usage:
```bash
cd /invoiceninjaCracked
./deploy.sh
```

### Initialization Script (`init-custom.sh`)

Location: `/dockerfiles/debian/scripts/init-custom.sh`

Runs on container start:
1. Wait for database ready
2. Run database migrations
3. Clear all caches
4. Generate app key (if missing)
5. Create storage symlink
6. Clean old React bundles
7. Set file permissions
8. Start supervisor

### Verification Script (`verify-deployment.sh`)

Location: `/verify-deployment.sh`

Checks:
- Container status
- Database connectivity
- File permissions
- API response
- PHP-FPM status

### Maintenance Commands

**View logs:**
```bash
docker compose logs -f invoiceninja
docker compose logs -f mariadb
docker compose logs -f redis
```

**Restart services:**
```bash
docker compose restart invoiceninja
docker compose restart mariadb
```

**Rebuild application:**
```bash
docker compose build --no-cache invoiceninja
docker compose up -d
```

**Database backup:**
```bash
docker exec invoiceninja-mariadb mysqldump \
  -u root -p${DB_ROOT_PASSWORD} invoiceninja > backup.sql
```

**Storage backup:**
```bash
docker run --rm \
  -v invoiceninja_invoiceninja-storage:/data \
  -v $(pwd):/backup alpine \
  tar czf /backup/storage-backup.tar.gz -C /data .
```

**Clear cache:**
```bash
docker exec invoiceninja php artisan cache:clear
docker exec invoiceninja php artisan config:clear
docker exec invoiceninja php artisan view:clear
```

**Run migrations:**
```bash
docker exec invoiceninja php artisan migrate --force
```

**Create admin user:**
```bash
docker exec invoiceninja php artisan ninja:create-account \
  --email=admin@example.com \
  --password=password
```

---

## Development Resources

### Documentation Files

- `README.md` - Main documentation
- `README-DOCKER.md` - Docker setup guide
- `CLAUDE.md` - AI development notes
- `DOCKER_TROUBLESHOOTING.md` - Docker issues
- `NGINX_PROXY_MANAGER_SETUP.md` - NPM setup
- `PAYWALL_BYPASS_SUMMARY.md` - Bypass details
- `CODEBASE_INDEX.md` - This file

### Composer Dependencies

**Key PHP Packages:**
- Laravel 11
- Livewire 3
- Laravel Scout (search)
- Laravel Socialite (OAuth)
- League Fractal (API transformers)
- AWS SDK (S3 storage)
- Stripe SDK
- PayPal SDK
- Square SDK
- Braintree SDK
- GoCardless SDK
- Mollie API
- Various invoice format libraries

Total: 100+ production packages

### NPM Dependencies

**Frontend (Laravel):**
- Vite
- TailwindCSS
- Chart.js
- Clipboard.js
- Signature Pad

**React UI:**
- React & React DOM
- React Router
- React Query
- Axios
- Formik
- Yup
- Recharts
- And 150+ more

### Git Repository

GitHub: (Your repository URL)
Branch: main

### Test Files

**Backend Tests:**
- Location: `/invoiceninja/tests/`
- 350 test files
- PHPUnit configuration
- Feature tests
- Unit tests
- API tests

**Frontend Tests:**
- Location: `/invoiceninjaUi/ui/tests/`
- Playwright E2E tests
- Jest unit tests
- 30+ test files

### API Documentation

OpenAPI/Swagger specs:
- Location: `/invoiceninja/openapi/`
- `api-docs.yaml` - Main spec
- Component schemas
- Path definitions
- Complete API reference

### Development Tools

**PHP Development:**
- PHPStan (static analysis)
- PHP CS Fixer (code style)
- Laravel Debugbar
- Laravel IDE Helper

**JavaScript Development:**
- ESLint
- Prettier (via package config)
- TypeScript
- Vite HMR

### Build Commands

**Backend:**
```bash
composer install              # Install dependencies
composer update              # Update dependencies
composer dump-autoload       # Regenerate autoload
php artisan migrate          # Run migrations
php artisan db:seed          # Seed database
php artisan test             # Run tests
npm run build                # Build Vite assets
```

**Frontend (React UI):**
```bash
npm install                  # Install dependencies
npm run dev                  # Development server
npm run build                # Production build
npm run test                 # Run tests
npm run lint                 # Lint code
```

### Useful Artisan Commands

```bash
# Cache management
php artisan cache:clear
php artisan config:clear
php artisan view:clear
php artisan route:clear

# Database
php artisan migrate
php artisan db:seed
php artisan migrate:fresh

# Queue
php artisan queue:work
php artisan queue:restart

# Invoice Ninja specific
php artisan ninja:create-account
php artisan ninja:create-test-data
php artisan ninja:check-data
php artisan ninja:send-renewals
```

---

## File Counts & Statistics

### Backend (Laravel)

| Category | Count |
|----------|-------|
| Models | 86 |
| Controllers | 80+ |
| Services | 309 |
| Jobs | 105 |
| Events | 127 |
| Listeners | 122 |
| Payment Drivers | 117 |
| Transformers | 57 |
| Repositories | 37 |
| Migrations | 276 |
| Tests | 350 |
| Views | 524 |
| Config Files | 30+ |

### Frontend (React)

| Category | Count |
|----------|-------|
| TypeScript Files | 856 |
| TypeScript Definitions | 507 |
| Components | 210+ |
| Pages | 900+ |
| Hooks | 89 |
| Interfaces | 61 |
| Queries | 33 |
| Tests | 30+ |

### Total Project Size

- **Total Files:** ~4,000+
- **Lines of Code:** ~500,000+ (estimated)
- **Languages:** PHP, TypeScript, JavaScript, Blade, CSS, YAML
- **Translations:** 43 languages

---

## Quick Reference

### Important Directories

```
🔥 Modified Files (Paywall Bypass)
   └── app/Models/Account.php

📦 Application Core
   ├── app/              (Main application)
   ├── config/           (Configuration)
   ├── database/         (Migrations, seeders)
   ├── routes/           (API & web routes)
   └── resources/        (Views, assets)

🎨 Frontend
   ├── resources/        (Livewire, JS, CSS)
   └── invoiceninjaUi/   (React admin UI)

🐳 Docker
   ├── Dockerfile.custom
   ├── docker-compose.yml
   └── dockerfiles/

📊 Database
   └── mariadb/databases/

🔧 Configuration
   ├── .env
   ├── config/
   └── nginx/
```

### Key Entry Points

- **Web:** `public/index.php`
- **API:** `routes/api.php`
- **React UI:** `invoiceninjaUi/ui/src/index.tsx`
- **CLI:** `artisan`
- **Docker:** `docker-compose.yml`

### Important Commands

```bash
# Start application
docker compose up -d

# View logs
docker compose logs -f

# Rebuild
docker compose build --no-cache

# Shell access
docker exec -it invoiceninja bash

# Run artisan command
docker exec invoiceninja php artisan <command>

# Database backup
docker exec invoiceninja-mariadb mysqldump -u root -p invoiceninja > backup.sql

# Stop application
docker compose down
```

---

## Notes

This index was generated to provide a comprehensive overview of the entire codebase structure. It includes:

- ✅ Complete directory structure
- ✅ All major components and their purposes
- ✅ API endpoint reference
- ✅ Database structure
- ✅ Docker configuration
- ✅ Deployment procedures
- ✅ Configuration references
- ✅ Development resources

**Last Updated:** November 19, 2025  
**Version:** Invoice Ninja v5.11.43 Custom Edition  
**Status:** Complete and operational

For specific implementation details, refer to the individual files and their inline documentation.

---

*This index serves as a living document and should be updated as the codebase evolves.*

