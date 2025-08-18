# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Critical Information

**WARNING**: This is a modified version of Invoice Ninja v5 with licensing bypasses. This codebase should only be used for educational analysis. For production use, obtain proper licensing from https://www.invoiceninja.com.

## Development Commands

### Build and Run
```bash
# Frontend development
npm run dev          # Start Vite dev server with hot reload
npm run build        # Production build

# Backend development
php artisan serve    # Local development server
php artisan migrate  # Run database migrations
php artisan db:seed  # Seed database with sample data
php artisan queue:work  # Process background jobs
```

### Testing and Quality
```bash
# PHP testing
composer test              # Run PHPUnit tests
composer test-coverage     # Generate test coverage report
./vendor/bin/phpunit tests/Unit/YourTest.php  # Run single test file

# Code quality
composer lint              # Laravel Pint linting
composer format            # PHP CS Fixer formatting
./vendor/bin/phpstan analyze  # Static analysis (Level 5)

# Frontend testing
npm run cypress:open       # Open Cypress for E2E testing
```

### Common Artisan Commands
```bash
php artisan cache:clear    # Clear application cache
php artisan config:clear   # Clear configuration cache
php artisan view:clear     # Clear compiled views
php artisan optimize       # Optimize for production
php artisan tinker         # Interactive REPL
```

## Architecture Overview

### Multi-Tenant System
Invoice Ninja uses company-based multi-tenancy with the `MultiDB` library. Each company can have isolated data while sharing the same codebase. Key components:
- `app/Libraries/MultiDB/` - Multi-database management
- `app/Models/Company.php` - Company entity with isolated data
- Database connections dynamically switched based on company context

### Payment Processing Architecture
The payment system uses a driver pattern with 30+ gateway integrations:
- `app/PaymentDrivers/` - Payment gateway implementations
- `app/Services/Payment/` - Payment processing logic
- Each driver extends `BaseDriver` and implements gateway-specific methods
- Webhooks handled via dedicated controllers in `app/Http/Controllers/Gateways/`

### API Design
RESTful API with versioning and comprehensive documentation:
- Routes defined in `routes/api.php`, `routes/client.php`, `routes/vendor.php`
- Transformers in `app/Transformers/` format responses using Fractal
- API authentication via tokens stored in `company_tokens` table
- Rate limiting and throttling configured per endpoint

### Job Queue System
Background processing for heavy operations:
- `app/Jobs/` - Queue jobs for emails, PDF generation, imports/exports
- Uses Laravel Queue with Redis driver
- Supervisor manages queue workers in production
- Failed jobs tracked in `failed_jobs` table

### Service Layer Pattern
Business logic separated from controllers:
- `app/Services/` - Core business services
- `app/Repositories/` - Data access layer
- `app/Factory/` - Model creation with complex logic
- `app/Observers/` - Model event handling

## Key Modules and Their Responsibilities

### Invoice Management
- `app/Models/Invoice.php` - Invoice entity
- `app/Services/Invoice/` - Invoice creation, updates, calculations
- `app/Jobs/Invoice/` - Background processing (PDF generation, emailing)
- PDF templates in `resources/views/pdf/`

### Client Portal
- `app/Http/Controllers/ClientPortal/` - Client-facing controllers
- `app/Http/Livewire/` - Dynamic components using Livewire 3
- `resources/views/portal/` - Client portal views
- Tailwind CSS for styling

### Recurring Invoices
- `app/Services/Recurring/` - Recurring invoice engine
- `app/Jobs/RecurringInvoice/` - Automated invoice generation
- Cron scheduling via `app/Console/Kernel.php`

### E-Invoicing Standards
- `app/Services/EDocument/` - UBL, ZUGFeRD, Peppol compliance
- `app/Services/EDocument/Standards/` - Format implementations
- XML generation and validation

## Database Structure

### Core Tables
- `companies` - Multi-tenant companies
- `users` - System users (can belong to multiple companies)
- `clients` - Customer records per company
- `invoices`, `quotes`, `credits` - Financial documents
- `payments` - Payment records with gateway data
- `products` - Product/service catalog

### Relationships
- Company → has many → Users, Clients, Invoices
- Client → has many → Invoices, Payments
- Invoice → has many → InvoiceItems, Payments
- User → belongs to many → Companies (via company_user pivot)

## Testing Strategy

### Unit Tests
Located in `tests/Unit/` - Test individual components:
- Model methods and relationships
- Service class logic
- Utility functions

### Feature Tests
Located in `tests/Feature/` - Test complete features:
- API endpoints
- Payment processing flows
- PDF generation
- Email sending

### Integration Tests
Located in `tests/Integration/` - Test external integrations:
- Payment gateways
- Email providers
- Third-party APIs

Run specific test suites:
```bash
./vendor/bin/phpunit --testsuite Unit
./vendor/bin/phpunit --testsuite Feature
./vendor/bin/phpunit --filter TestClassName
```