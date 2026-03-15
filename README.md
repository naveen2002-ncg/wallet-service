# Wallet & Transaction Service (Backend API)

A production-style backend service for managing user wallets and transactions with JWT authentication.

## 🌐 Live Demo

- **Live App (Dashboard)**: https://wallet-service-qze7.onrender.com
- **Login Page**: https://wallet-service-qze7.onrender.com/login.html
- **API Base URL**: https://wallet-service-qze7.onrender.com/api/v1

## 🏗️ Architecture

```
Client
  ↓
REST API (Flask)
  ↓
Service Layer (Business Logic)
  ↓
Repository Layer (DB)
  ↓
PostgreSQL
```

## 🚀 Features

- **Authentication**: User signup/login with JWT tokens
- **Wallet**: One wallet per user with balance tracking
- **Transactions**: Credit/debit operations with overdraft prevention
- **Transaction History**: View all transactions
- **Data Persistence**: PostgreSQL with proper relationships and constraints

## 📁 Project Structure

```
wallet-service/
├── app/
│   ├── main.py                 # Application entry point
│   ├── config.py               # Configuration
│   ├── models/                 # Database models
│   │   ├── user.py
│   │   ├── wallet.py
│   │   └── transaction.py
│   ├── routes/                 # API routes
│   │   ├── auth.py
│   │   ├── wallet.py
│   │   └── transaction.py
│   ├── services/               # Business logic
│   │   ├── auth_service.py
│   │   └── transaction_service.py
│   ├── repositories/           # Data access layer
│   │   ├── user_repository.py
│   │   ├── wallet_repository.py
│   │   └── transaction_repository.py
│   ├── schemas/                # Request/response validation
│   │   ├── auth.py
│   │   └── transaction.py
│   └── utils/                  # Utilities
│       ├── jwt.py
│       └── hash.py
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── .env.example
└── README.md
```

## 🛠️ Setup Instructions

### Prerequisites

- Python 3.10+
- Docker and Docker Compose (recommended)
- PostgreSQL (if not using Docker)

### Option 1: Using Docker (Recommended)

1. **Clone the repository** (if applicable)

2. **Create environment file**:
   ```bash
   cp .env.example .env
   ```
   Edit `.env` and update the secret keys.

3. **Build and run with Docker Compose**:
   ```bash
   docker-compose up --build
   ```

   The API will be available at `http://localhost:5000`

### Option 2: Local Development

1. **Create virtual environment**:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

3. **Set up environment variables**:
   ```bash
   cp .env.example .env
   ```
   Update `.env` with your configuration.

4. **Start PostgreSQL** (ensure it's running locally or use Docker for just the DB):
   ```bash
   docker-compose up db
   ```

5. **Run the application**:
   ```bash
   python app/main.py
   ```

## 📚 API Endpoints

Base URL: `http://localhost:5000/api/v1`

### Authentication

#### Register User
```http
POST /auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "StrongPass123"
}
```

**Response** (201):
```json
{
  "message": "User registered successfully"
}
```

#### Login
```http
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "StrongPass123"
}
```

**Response** (200):
```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}
```

### Wallet

#### Get Wallet Balance
```http
GET /wallet
Authorization: Bearer <token>
```

**Response** (200):
```json
{
  "balance": 1500.00
}
```

### Transactions

#### Credit Money
```http
POST /transactions/credit
Authorization: Bearer <token>
Content-Type: application/json

{
  "amount": 500
}
```

**Response** (200):
```json
{
  "message": "Amount credited successfully",
  "new_balance": 1500
}
```

#### Debit Money
```http
POST /transactions/debit
Authorization: Bearer <token>
Content-Type: application/json

{
  "amount": 200
}
```

**Response** (200):
```json
{
  "message": "Amount debited successfully",
  "new_balance": 1300
}
```

**Error Response** (400 - Insufficient balance):
```json
{
  "error": "Insufficient balance"
}
```

#### Get Transaction History
```http
GET /transactions
Authorization: Bearer <token>
```

**Response** (200):
```json
[
  {
    "id": "uuid",
    "type": "debit",
    "amount": 200,
    "created_at": "2026-01-01T10:00:00"
  },
  {
    "id": "uuid",
    "type": "credit",
    "amount": 500,
    "created_at": "2026-01-01T09:00:00"
  }
]
```

## 🗄️ Database Schema

### Users
- `id` (UUID, Primary Key)
- `email` (VARCHAR, Unique, Not Null)
- `password_hash` (TEXT, Not Null)
- `created_at` (TIMESTAMP)

### Wallets
- `id` (UUID, Primary Key)
- `user_id` (UUID, Foreign Key → users.id, Unique)
- `balance` (NUMERIC(12,2), Default: 0.00)
- `updated_at` (TIMESTAMP)

### Transactions
- `id` (UUID, Primary Key)
- `wallet_id` (UUID, Foreign Key → wallets.id)
- `type` (VARCHAR(10), Check: 'credit' or 'debit')
- `amount` (NUMERIC(12,2), Check: amount > 0)
- `created_at` (TIMESTAMP)

## 🔒 Security Features

- Password hashing using bcrypt
- JWT-based authentication
- Input validation with Marshmallow
- SQL injection protection via SQLAlchemy ORM
- Database constraints for data integrity

## 📝 Notes

- One wallet is automatically created per user upon registration
- Overdraft prevention is enforced at the service layer
- All monetary values use NUMERIC(12,2) for precision
- UUIDs are used for all primary keys
- Cascade delete ensures data consistency

## 🧪 Testing the API

You can test the API using `curl` or any HTTP client like Postman:

```bash
# Register
curl -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# Login
curl -X POST http://localhost:5000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# Get Balance (replace TOKEN with actual token)
curl -X GET http://localhost:5000/api/v1/wallet \
  -H "Authorization: Bearer TOKEN"

# Credit
curl -X POST http://localhost:5000/api/v1/transactions/credit \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"amount":1000}'

# Debit
curl -X POST http://localhost:5000/api/v1/transactions/debit \
  -H "Authorization: Bearer TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"amount":200}'

# Get Transactions
curl -X GET http://localhost:5000/api/v1/transactions \
  -H "Authorization: Bearer TOKEN"
```

## 📄 License

This project is for demonstration purposes.
