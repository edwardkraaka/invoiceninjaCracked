# Invoice Ninja - Architecture & Patterns Guide

**Companion to:** CODEBASE_INDEX.md  
**Purpose:** Deep dive into architecture, patterns, and data flow

---

## Table of Contents

1. [System Architecture](#system-architecture)
2. [Data Flow Diagrams](#data-flow-diagrams)
3. [Design Patterns](#design-patterns)
4. [Security Architecture](#security-architecture)
5. [API Architecture](#api-architecture)
6. [Payment Processing Flow](#payment-processing-flow)
7. [PDF Generation Pipeline](#pdf-generation-pipeline)
8. [Email System](#email-system)
9. [Job Queue System](#job-queue-system)
10. [Caching Strategy](#caching-strategy)

---

## System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Client Browser                           │
│  ┌──────────────┐  ┌──────────────┐  ┌────────────────────┐   │
│  │   React UI   │  │   Client     │  │   Vendor Portal    │   │
│  │  (Admin App) │  │   Portal     │  │                    │   │
│  └──────┬───────┘  └──────┬───────┘  └──────┬─────────────┘   │
└─────────┼──────────────────┼──────────────────┼─────────────────┘
          │ HTTPS/API        │ HTTPS            │ HTTPS
          ▼                  ▼                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                         Nginx (Port 80/443)                      │
│                    Reverse Proxy / SSL Termination               │
└─────────────────────────────┬───────────────────────────────────┘
                              │ FastCGI
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Invoice Ninja (PHP-FPM 9000)                 │
│  ┌────────────────────────────────────────────────────────┐    │
│  │                  Laravel Application                    │    │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐            │    │
│  │  │   API    │  │   Web    │  │  Client  │            │    │
│  │  │ Routes   │  │  Routes  │  │  Routes  │            │    │
│  │  └────┬─────┘  └────┬─────┘  └────┬─────┘            │    │
│  │       │             │              │                   │    │
│  │       └─────────────┼──────────────┘                   │    │
│  │                     │                                  │    │
│  │  ┌──────────────────▼──────────────────────────────┐  │    │
│  │  │            Controllers Layer                     │  │    │
│  │  │  • InvoiceController  • ClientController        │  │    │
│  │  │  • PaymentController  • ExpenseController       │  │    │
│  │  └────────────────┬─────────────────────────────────┘  │    │
│  │                   │                                     │    │
│  │  ┌────────────────▼─────────────────────────────────┐  │    │
│  │  │            Services Layer                        │  │    │
│  │  │  • Invoice\CreateInvitations                    │  │    │
│  │  │  • Payment\PaymentService                       │  │    │
│  │  │  • Pdf\PdfService                               │  │    │
│  │  │  • Email\EmailService                           │  │    │
│  │  └────────────────┬─────────────────────────────────┘  │    │
│  │                   │                                     │    │
│  │  ┌────────────────▼─────────────────────────────────┐  │    │
│  │  │         Repositories Layer                       │  │    │
│  │  │  • InvoiceRepository                            │  │    │
│  │  │  • ClientRepository                             │  │    │
│  │  │  • PaymentRepository                            │  │    │
│  │  └────────────────┬─────────────────────────────────┘  │    │
│  │                   │                                     │    │
│  │  ┌────────────────▼─────────────────────────────────┐  │    │
│  │  │              Models (Eloquent)                   │  │    │
│  │  │  • Invoice  • Client  • Payment  • Product      │  │    │
│  │  │  • Account* (MODIFIED - Bypass)                 │  │    │
│  │  └────────────────┬─────────────────────────────────┘  │    │
│  └───────────────────┼──────────────────────────────────────┘    │
│                      │                                           │
│  ┌───────────────────▼──────────────────────────────────────┐   │
│  │                Event & Job System                        │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────────────────┐  │   │
│  │  │  Events  │→ │Listeners │→ │  Queue Jobs          │  │   │
│  │  │          │  │          │  │  • SendEmail         │  │   │
│  │  │          │  │          │  │  • GeneratePdf       │  │   │
│  │  │          │  │          │  │  • ProcessPayment    │  │   │
│  │  └──────────┘  └──────────┘  └──────────────────────┘  │   │
│  └───────────────────────────────────────────────────────────┘   │
└─────────────────────────────┬───────────────────────────────────┘
                              │
          ┌───────────────────┼───────────────────┐
          │                   │                   │
          ▼                   ▼                   ▼
┌──────────────────┐  ┌──────────────┐  ┌────────────────┐
│   MariaDB 10.6   │  │    Redis     │  │  File Storage  │
│   (Database)     │  │   (Cache)    │  │   (Volumes)    │
│                  │  │              │  │                │
│ • Invoices       │  │ • Sessions   │  │ • Uploads      │
│ • Clients        │  │ • Cache      │  │ • PDFs         │
│ • Payments       │  │ • Queues     │  │ • Documents    │
│ • Products       │  │              │  │ • Logos        │
└──────────────────┘  └──────────────┘  └────────────────┘
```

### Container Architecture

```
Docker Host
│
├── invoiceninja-nginx (80, 443)
│   ├── Static file serving
│   ├── SSL termination
│   └── FastCGI proxy to PHP-FPM
│
├── invoiceninja (9000)
│   ├── PHP 8.3-FPM
│   ├── Laravel Application
│   ├── Node.js 20 (for builds)
│   ├── Chrome/Chromium (for PDFs)
│   └── Supervisor (process manager)
│       ├── PHP-FPM pool
│       └── Queue workers
│
├── invoiceninja-mariadb (3306)
│   ├── MariaDB 10.6
│   └── Persistent volume
│
└── invoiceninja-redis (6379)
    ├── Redis server
    └── In-memory cache/sessions

Network: invoiceninja-network (bridge)
```

---

## Data Flow Diagrams

### Invoice Creation Flow

```
User (React UI)
    │
    │ POST /api/v1/invoices
    ▼
API Route (api.php)
    │
    │ Middleware: auth, token_auth
    ▼
InvoiceController@store
    │
    ├─→ Validate request data
    │
    ├─→ InvoiceRepository->save()
    │   │
    │   ├─→ Create Invoice model
    │   ├─→ Save line items
    │   ├─→ Calculate totals
    │   └─→ Save to database
    │
    ├─→ Fire InvoiceWasCreated event
    │   │
    │   └─→ Listeners
    │       ├─→ CreateInvoiceInvitation
    │       ├─→ LogActivity
    │       └─→ UpdateClientBalance
    │
    ├─→ Transform response (InvoiceTransformer)
    │
    └─→ Return JSON response
        │
        ▼
React UI updates state
```

### Payment Processing Flow

```
Client Portal
    │
    │ Select Payment Gateway
    ▼
Payment Gateway Selection
    │
    ├─→ Stripe
    ├─→ PayPal
    ├─→ Square
    └─→ etc...
        │
        ▼
PaymentWebhookController
    │
    ├─→ Verify webhook signature
    │
    ├─→ PaymentService->processPayment()
    │   │
    │   ├─→ Create Payment record
    │   ├─→ Update Invoice status
    │   ├─→ Update Client balance
    │   ├─→ Record transaction
    │   └─→ Fire PaymentWasCreated event
    │       │
    │       └─→ Listeners
    │           ├─→ SendPaymentConfirmation (email)
    │           ├─→ LogActivity
    │           └─→ UpdateClientStats
    │
    ├─→ Generate receipt PDF (queued)
    │
    └─→ Send confirmation email (queued)
```

### PDF Generation Flow

```
Generate PDF Request
    │
    ▼
PdfService@makePdf()
    │
    ├─→ Load Invoice data
    │   ├─→ Client
    │   ├─→ Company
    │   ├─→ Line items
    │   └─→ Settings
    │
    ├─→ Select Design
    │   ├─→ Custom design
    │   └─→ Default template
    │
    ├─→ Render Blade template
    │   └─→ Generate HTML
    │
    ├─→ SnappDF (Chromium)
    │   ├─→ Launch headless browser
    │   ├─→ Load HTML
    │   ├─→ Apply styles
    │   ├─→ Render to PDF
    │   └─→ Close browser
    │
    ├─→ Save PDF to storage
    │   └─→ storage/invoices/{hash}.pdf
    │
    ├─→ Store document reference
    │   └─→ documents table
    │
    └─→ Return PDF path/URL
```

### Email Sending Flow

```
Email Trigger (Invoice, Payment, etc.)
    │
    ▼
EmailService->send()
    │
    ├─→ Check email quota (Account model)
    │   └─→ Verify limit not exceeded
    │
    ├─→ Load email template
    │   ├─→ Custom template
    │   └─→ Default template
    │
    ├─→ Replace variables
    │   ├─→ $client.name
    │   ├─→ $invoice.number
    │   ├─→ $invoice.amount
    │   └─→ etc...
    │
    ├─→ Generate preview
    │
    ├─→ Attach PDFs (if configured)
    │
    ├─→ Queue NinjaMailerJob
    │   │
    │   └─→ Queue Worker
    │       │
    │       ├─→ Select mail driver
    │       │   ├─→ SMTP
    │       │   ├─→ Mailgun
    │       │   ├─→ Postmark
    │       │   └─→ Brevo
    │       │
    │       ├─→ Send email
    │       │
    │       ├─→ Track sending
    │       │   └─→ email_history table
    │       │
    │       └─→ Handle webhooks (bounces, opens, clicks)
    │
    └─→ Return success
```

---

## Design Patterns

### Repository Pattern

**Purpose:** Abstraction layer between business logic and data access

**Example:** InvoiceRepository

```php
// app/Repositories/InvoiceRepository.php

class InvoiceRepository extends BaseRepository
{
    public function save(array $data, Invoice $invoice)
    {
        // Data transformation
        $data = $this->prepareData($data);
        
        // Save invoice
        $invoice->fill($data);
        $invoice->save();
        
        // Save line items
        $this->saveLineItems($data['line_items'], $invoice);
        
        // Calculate totals
        $invoice = $this->calculateTotals($invoice);
        
        return $invoice;
    }
}
```

### Service Pattern

**Purpose:** Business logic encapsulation

**Example:** PaymentService

```php
// app/Services/Payment/PaymentService.php

class PaymentService
{
    public function processPayment(Payment $payment, Invoice $invoice)
    {
        // Apply payment to invoice
        $this->applyPayment($payment, $invoice);
        
        // Update invoice status
        $this->updateInvoiceStatus($invoice);
        
        // Update client balance
        $this->updateClientBalance($invoice->client);
        
        // Fire events
        event(new PaymentWasCreated($payment));
        
        return $payment;
    }
}
```

### Transformer Pattern

**Purpose:** API response formatting

**Example:** InvoiceTransformer

```php
// app/Transformers/InvoiceTransformer.php

class InvoiceTransformer extends EntityTransformer
{
    public function transform(Invoice $invoice)
    {
        return [
            'id' => $this->encodePrimaryKey($invoice->id),
            'number' => $invoice->number,
            'amount' => (float) $invoice->amount,
            'balance' => (float) $invoice->balance,
            'client_id' => $this->encodePrimaryKey($invoice->client_id),
            'status_id' => (int) $invoice->status_id,
            // ... more fields
        ];
    }
    
    public function includeClient(Invoice $invoice)
    {
        return $this->item($invoice->client, new ClientTransformer);
    }
}
```

### Observer Pattern

**Purpose:** React to model events

**Example:** InvoiceObserver

```php
// app/Observers/InvoiceObserver.php

class InvoiceObserver
{
    public function created(Invoice $invoice)
    {
        // Log activity
        $this->logActivity($invoice);
        
        // Create invitations
        CreateInvitationJob::dispatch($invoice);
    }
    
    public function updated(Invoice $invoice)
    {
        if ($invoice->isDirty('balance')) {
            // Update client balance
            $this->updateClientBalance($invoice->client);
        }
    }
}
```

### Factory Pattern

**Purpose:** Object creation

**Example:** InvoiceFactory

```php
// app/Factory/InvoiceFactory.php

class InvoiceFactory
{
    public static function create(Company $company, User $user): Invoice
    {
        $invoice = new Invoice;
        $invoice->company_id = $company->id;
        $invoice->user_id = $user->id;
        $invoice->status_id = Invoice::STATUS_DRAFT;
        $invoice->number = $this->getNextInvoiceNumber($company);
        $invoice->date = now();
        // ... set defaults
        
        return $invoice;
    }
}
```

### Presenter Pattern

**Purpose:** View logic separation

**Example:** InvoicePresenter

```php
// app/Models/Presenters/InvoicePresenter.php

class InvoicePresenter extends EntityPresenter
{
    public function amount()
    {
        return Number::formatMoney($this->entity->amount, $this->entity->client);
    }
    
    public function status()
    {
        return Invoice::$statuses[$this->entity->status_id];
    }
}
```

---

## Security Architecture

### Authentication System

```
User Login
    │
    ├─→ Email/Password
    │   ├─→ LoginController@apiLogin
    │   ├─→ Hash verification (bcrypt)
    │   ├─→ 2FA check (if enabled)
    │   └─→ Generate token (JWT-like)
    │
    ├─→ OAuth (Google, Microsoft, Apple)
    │   ├─→ Socialite integration
    │   ├─→ External auth
    │   └─→ Generate token
    │
    └─→ API Token
        ├─→ Company tokens table
        └─→ Permission-based access
```

### Authorization Levels

1. **Super Admin**
   - Full system access
   - Multi-company management

2. **Company Admin**
   - Full company access
   - User management
   - All features

3. **Standard User**
   - Limited by permissions
   - Configurable access

4. **Client Portal**
   - Own invoices only
   - Payment processing
   - Download documents

5. **Vendor Portal**
   - Own purchase orders
   - Expense submission

### Middleware Stack

```php
// API Request Middleware Chain
[
    'throttle:api',           // Rate limiting
    'api_secret_check',       // API secret validation
    'api_db',                 // Database selection
    'token_auth',             // Token authentication
    'locale',                 // Language setting
    'user_verified',          // Email verification
    'password_protected'      // Additional password check
]
```

### Permission System

```php
// User permissions checked via CompanyUser pivot
$user->hasPermission('view_invoice');
$user->hasPermission('create_client');
$user->hasPermission('edit_settings');

// Defined in:
// app/Utils/Traits/UserPermissions.php
```

### XSS Protection

- Blade `{{ }}` escaping
- HTMLPurifier for rich text
- CSP headers
- Input validation

### CSRF Protection

- Laravel built-in CSRF tokens
- API uses token auth (stateless)
- Double submit cookies

### SQL Injection Protection

- Eloquent ORM (parameterized)
- Query builder escaping
- Prepared statements

---

## API Architecture

### RESTful Design

```
Resource: /api/v1/invoices

GET    /invoices           → index()    (list)
POST   /invoices           → store()    (create)
GET    /invoices/{id}      → show()     (read)
PUT    /invoices/{id}      → update()   (update)
DELETE /invoices/{id}      → destroy()  (delete)
```

### Response Format

**Success Response:**
```json
{
  "data": {
    "id": "aBc123",
    "number": "INV-0001",
    "amount": 1000.00,
    "balance": 1000.00,
    "status_id": 2,
    "client": {
      "id": "xYz789",
      "name": "Acme Corp"
    }
  }
}
```

**Collection Response:**
```json
{
  "data": [ /* array of resources */ ],
  "meta": {
    "pagination": {
      "total": 100,
      "count": 20,
      "per_page": 20,
      "current_page": 1,
      "total_pages": 5
    }
  }
}
```

**Error Response:**
```json
{
  "message": "The given data was invalid.",
  "errors": {
    "email": [
      "The email field is required."
    ]
  }
}
```

### API Versioning

- URL-based: `/api/v1/`
- Header-based: `Accept: application/json`

### Rate Limiting

```php
// Different rates for different endpoints
'throttle:api'      // 60 requests/minute (general)
'throttle:login'    // 10 requests/minute (login)
'throttle:1000,1'   // 1000 requests/minute (webhooks)
```

### Pagination

```php
// Query parameters
?per_page=50        // Items per page
?page=2             // Page number
```

### Filtering & Searching

```php
// Filtering
?filter=status_id:2,amount:>1000

// Searching
?search=client_name:Acme

// Sorting
?sort=created_at|desc
```

### Including Relations

```php
// Include related resources
?include=client,items,payments
```

---

## Payment Processing Flow

### Gateway Integration Architecture

```
Payment Request
    │
    ▼
CompanyGateway (Configuration)
    │
    ├─→ Gateway credentials
    ├─→ Gateway settings
    └─→ Fee configuration
        │
        ▼
PaymentDriver (Abstract)
    │
    ├─→ StripePaymentDriver
    ├─→ PayPalPaymentDriver
    ├─→ SquarePaymentDriver
    └─→ etc...
        │
        ├─→ authorize()
        ├─→ purchase()
        ├─→ refund()
        └─→ processWebhook()
            │
            ▼
Gateway API
    │
    └─→ Transaction Response
        │
        ▼
PaymentService
    │
    ├─→ Store payment
    ├─→ Update invoice
    ├─→ Fire events
    └─→ Return result
```

### Webhook Processing

```
Gateway Webhook → PaymentWebhookController
    │
    ├─→ Verify signature
    ├─→ Parse payload
    ├─→ Find payment
    ├─→ Process event
    │   ├─→ payment.succeeded
    │   ├─→ payment.failed
    │   ├─→ refund.created
    │   └─→ subscription.updated
    └─→ Return 200 OK
```

---

## PDF Generation Pipeline

### SnappDF Architecture

```
PDF Request
    │
    ├─→ Load Invoice/Quote/Credit
    │
    ├─→ PdfService->makePdf()
        │
        ├─→ Design Selection
        │   ├─→ Load custom design
        │   └─→ Apply variables
        │
        ├─→ HTML Generation
        │   ├─→ Render Blade template
        │   ├─→ Inject CSS
        │   └─→ Apply fonts
        │
        ├─→ SnappDF Renderer
        │   ├─→ Launch Chrome/Chromium
        │   ├─→ Set viewport
        │   ├─→ Load HTML
        │   ├─→ Wait for rendering
        │   ├─→ Print to PDF
        │   └─→ Close browser
        │
        ├─→ Storage
        │   └─→ Save to disk/S3
        │
        └─→ Return PDF path
```

### Design System

- Custom HTML/CSS designs
- Blade templating
- Variable replacement
- Multi-language support
- Custom fonts (Noto CJK for Unicode)

---

## Email System

### Multi-Provider Architecture

```
Email Request
    │
    ▼
EmailService
    │
    ├─→ Check quota
    ├─→ Load template
    ├─→ Replace variables
    └─→ Queue job
        │
        ▼
NinjaMailerJob
    │
    ├─→ Select Provider
    │   ├─→ SMTP (PHPMailer)
    │   ├─→ Mailgun (API)
    │   ├─→ Postmark (API)
    │   ├─→ Brevo (API)
    │   └─→ Amazon SES
    │
    ├─→ Send email
    │
    ├─→ Track sending
    │   └─→ email_history table
    │
    └─→ Process webhooks
        ├─→ Delivered
        ├─→ Opened
        ├─→ Clicked
        └─→ Bounced
```

---

## Job Queue System

### Queue Architecture

```
┌──────────────────────┐
│   Queue Driver       │
├──────────────────────┤
│  • Database (default)│
│  • Redis             │
│  • SQS               │
│  • Beanstalkd        │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   Queue Workers      │
├──────────────────────┤
│  • php artisan queue │
│    :work             │
│  • Supervised        │
│  • Auto-restart      │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   Job Processing     │
├──────────────────────┤
│  • SendEmail         │
│  • GeneratePdf       │
│  • ProcessImport     │
│  • SendWebhook       │
│  • UpdateData        │
└──────────────────────┘
```

### Job Types

**High Priority:**
- Payment processing
- Real-time notifications

**Medium Priority:**
- Email sending
- PDF generation

**Low Priority:**
- Report generation
- Data imports
- Cleanup tasks

---

## Caching Strategy

### Cache Layers

```
┌──────────────────────────────┐
│    Application Cache         │
├──────────────────────────────┤
│  Redis (Primary)             │
│  • Config cache              │
│  • Route cache               │
│  • View cache                │
│  • Query cache               │
└──────────────────────────────┘

┌──────────────────────────────┐
│    Session Storage           │
├──────────────────────────────┤
│  Redis                       │
│  • User sessions             │
│  • CSRF tokens               │
└──────────────────────────────┘

┌──────────────────────────────┐
│    Database Query Cache      │
├──────────────────────────────┤
│  Redis                       │
│  • Frequently accessed data  │
│  • Settings                  │
│  • Static data               │
└──────────────────────────────┘
```

### Cache Keys

```php
// Settings cache
"company_{$company_id}_settings"

// Client cache
"client_{$client_id}_data"

// Static data
"countries_list"
"currencies_list"
"timezones_list"
```

### Cache Invalidation

- Event-based invalidation
- Tag-based cache clearing
- TTL for automatic expiry

---

## Summary

This architecture guide complements the main index by providing:

- ✅ Visual system architecture
- ✅ Data flow diagrams
- ✅ Design pattern examples
- ✅ Security architecture
- ✅ API design patterns
- ✅ Payment processing flow
- ✅ PDF generation pipeline
- ✅ Email system architecture
- ✅ Job queue system
- ✅ Caching strategy

For implementation details, refer to the CODEBASE_INDEX.md and source code.

---

*This guide serves as a technical reference for understanding the system architecture and design decisions.*

