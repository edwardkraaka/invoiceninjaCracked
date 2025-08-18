# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains Invoice Ninja v5, a comprehensive invoicing and business management application built with Laravel. The project uses a multi-layered architecture with separate applications for the API/backend (Laravel) and client portals.

## Project Structure

The main application is located in `/invoiceninja/` with the following key directories:
- `app/` - Core application code (Models, Controllers, Services, etc.)
- `routes/` - API and web route definitions
- `database/` - Migrations, factories, and seeders
- `tests/` - Unit, Integration, and Feature tests
- `public/` - Public assets and Flutter web app files
- `resources/` - Views and raw assets

A Docker setup is available in `/dockerfiles/debian/` for containerized deployment.

## Common Development Commands

### Installation & Setup
```bash
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate:fresh --seed
php artisan ninja:create-test-data  # Load sample data
```

### Running the Application
```bash
php artisan serve  # Development server
```

### Testing
```bash
./vendor/bin/phpunit                    # Run all tests
./vendor/bin/phpunit tests/Unit         # Run unit tests only
./vendor/bin/phpunit tests/Feature      # Run feature tests only
./vendor/bin/phpunit tests/Integration  # Run integration tests only
./vendor/bin/phpunit --filter TestName  # Run specific test
```

### Code Quality
```bash
composer pcf                            # PHP CS Fixer
./vendor/bin/phpstan analyse            # Static analysis
composer format                         # Code formatting
```

### Frontend Development
```bash
npm install
npm run dev    # Development build with hot reload
npm run build  # Production build
```

### Docker Development
```bash
cd dockerfiles/debian
docker-compose up -d  # Start all services
docker-compose logs -f app  # View application logs
```

## Architecture Overview

### Domain Design
The application follows a domain-driven design pattern where each business entity has:
- **Model** (`app/Models/`) - Eloquent ORM models
- **Controller** (`app/Http/Controllers/`) - HTTP request handlers
- **Repository** (`app/Repositories/`) - Data access layer
- **Service** (`app/Services/`) - Business logic layer
- **Transformer** (`app/Transformers/`) - API response formatting
- **Factory** (`app/Factory/`) - Object creation patterns
- **Observer** (`app/Observers/`) - Model event handlers

### API Request Flow
1. **Middleware** - Authentication and domain inspection
2. **Form Request** - Validation and authorization
3. **Controller** - Request handling and orchestration
4. **Repository** - Data persistence
5. **Service** - Business logic and side effects
6. **Events** - Non-blocking tasks via Laravel events
7. **Transformer** - Response formatting via Fractal

### Multi-Company Architecture
The application supports multiple companies per account with data isolation through:
- Company-scoped queries via global scopes
- CompanyUser pivot for user-company relationships
- Multi-database support for enterprise deployments

### Payment Processing
Multiple payment gateways are supported through a driver pattern:
- Base driver interface in `app/PaymentDrivers/BaseDriver.php`
- Gateway-specific implementations (Stripe, PayPal, etc.)
- Webhook handling for asynchronous payment events

### Client Portal
The client portal (`/client/*` routes) provides:
- Invoice viewing and payment
- Quote acceptance
- Document management
- Subscription management

### E-Invoicing Support
The application supports multiple e-invoicing standards:
- PEPPOL (Pan-European Public Procurement OnLine)
- FatturaPA (Italian e-invoicing)
- Facturae (Spanish e-invoicing)
- ZUGFeRD (German e-invoicing)

## Testing Strategy

Tests are organized by type:
- **Unit** - Isolated component testing
- **Feature** - API endpoint testing
- **Integration** - Cross-component testing
- **Pdf** - PDF generation testing

Key testing conventions:
- Use `MockAccountData` trait for test data setup
- Tests run with SQLite in-memory database
- Feature tests should test full API request/response cycle
- Always include tests for new functionality

## Important Notes

- PDF generation uses multiple drivers: hosted_ninja (default), snappdf, or phantom
- Queue processing is synchronous by default (QUEUE_CONNECTION=sync)
- The application includes both REST API and GraphQL interfaces
- Flutter web app is pre-compiled in public/ directory
- Recurring invoices/expenses use Laravel's scheduler
- Multi-language support with translations in lang/ directory