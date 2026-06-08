# Honkai Star Retail

A mobile marketplace application inspired by Honkai Star Rail, developed for Mobile Hybrid Lab.

## Features

### Authentication
- User Registration
- User Login
- JWT Authentication
- Google OAuth Login

### Product Management
- Browse Products
- Search Products
- View Product Details
- Product Images
- Stock Management

### Transactions
- Purchase Products
- Transaction History
- Purchase Validation

### Roles
- User
- Admin

## Tech Stack

### Frontend
- Flutter 3.44.1
- Dart

### Backend
- Node.js
- Express.js
- JWT
- Multer

### Database
- MySQL (XAMPP)

## Project Structure

```
MobileHybridLab-Kelompok 3
│
├── backend
├── frontend
├── screenshot
├── honkai_star_retail_db.sql
├── honkai_star_retail_db.csv
└── documentation.docx
```

## API Endpoints

### Authentication
POST /api/register

POST /api/login

POST /api/oauth

### Resources
GET /api/resources

GET /api/resources/:id

POST /api/resources

PUT /api/resources/:id

DELETE /api/resources/:id

POST /api/resources/upload

### Transactions
POST /api/transactions/buy

GET /api/transactions

GET /api/transactions/all

## Database

Tables:
- users
- resources
- transactions

## Authors

Mobile Hybrid Lab Group 3
BINUS University
