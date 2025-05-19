# CBDC API Documentation

## Base URL

`/api/v1`

## Authentication

All protected routes require authentication middleware
Authentication header required for protected routes

## Routes

### Authentication `/user`

| Method | Endpoint    | Parameters                | Description    |
| ------ | ----------- | ------------------------- | -------------- |
| POST   | `/register` | `{name, email, password}` | Create account |
| POST   | `/login`    | `{email, password}`       | Login          |
| GET    | `/logout`   | -                         | Logout         |

### User Management `/user`

| Method | Endpoint              | Parameters                   | Description         |
| ------ | --------------------- | ---------------------------- | ------------------- |
| GET    | `/`                   | -                            | Get all users       |
| POST   | `/setPin`             | `{userId, transactionPin}`   | Set transaction pin |
| GET    | `/showMe/:id`         | id (URL param)               | Get current user    |
| PATCH  | `/updateUser`         | `{email, name}`              | Update profile      |
| PATCH  | `/updateUserPassword` | `{oldPassword, newPassword}` | Update password     |
| GET    | `/getBalance/:id`     | id (URL param)               | Get user balance    |

### Bank Management `/banks`

| Method | Endpoint        | Parameters                   | Description          |
| ------ | --------------- | ---------------------------- | -------------------- |
| GET    | `/`             | -                            | Get all banks        |
| POST   | `/`             | `{name, email, password}`    | Register a new bank  |
| GET    | `/:id`          | id (URL param)               | Get bank details     |
| PATCH  | `/:id`          | `{email, name}`              | Update bank details  |
| PATCH  | `/:id/password` | `{oldPassword, newPassword}` | Update bank password |
| PATCH  | `/:id/status`   | `{status}`                   | Update bank status   |
| GET    | `/:id/balance`  | id (URL param)               | Get bank balance     |

### Transactions `/transactions`

| Method | Endpoint                    | Parameters                                                     | Description             |
| ------ | --------------------------- | -------------------------------------------------------------- | ----------------------- |
| POST   | `/`                         | `{senderId, receiverId, amount, transactionType, description}` | Create transaction      |
| POST   | `/bank-to-user`             | `{bankId, userId, amount, description}`                        | Bank to user transfer   |
| GET    | `/:id`                      | id (URL param)                                                 | List all transactions   |
| GET    | `/getSingleTransaction/:id` | transactionId (URL param)                                      | Get transaction details |

### Minting Operations `/mint`

| Method | Endpoint          | Role Required | Parameters         | Description                                          |
| ------ | ----------------- | ------------- | ------------------ | ---------------------------------------------------- |
| POST   | `/`               | admin, bank   | `{amount}`         | Mint tokens to Central Bank                          |
| POST   | `/transfer-to-cb` | admin         | `{bankId, amount}` | Transfer tokens from Central Bank to Commercial Bank |

### Images `/images`

| Method | Endpoint                     | Parameters     | Description                | Body Format |
| ------ | ---------------------------- | -------------- | -------------------------- | ----------- |
| POST   | `/profile/:id`               | id (URL param) | Upload profile photo       | form-data   |
| POST   | `/government-id/:id`         | id (URL param) | Upload government ID       | form-data   |
| GET    | `/profile/:id`               | id (URL param) | Get user's profile photo   | -           |
| GET    | `/government-id/:id`         | id (URL param) | Get user's government ID   | -           |
| POST   | `/complete-registration/:id` | id (URL param) | Complete user registration | form-data   |

### KYC Management `/kyc`

| Method | Endpoint       | Role Required | Parameters     | Description                           |
| ------ | -------------- | ------------- | -------------- | ------------------------------------- |
| GET    | `/pending`     | admin, bank   | -              | Get all users with pending KYC status |
| POST   | `/approve/:id` | admin, bank   | id (URL param) | Approve KYC status for specified user |
| POST   | `/reject/:id`  | admin, bank   | id (URL param) | Reject KYC status for specified user  |

### Hierarchy Visualization `/hierarchy`

| Method | Endpoint       | Parameters             | Description                                |
| ------ | -------------- | ---------------------- | ------------------------------------------ |
| GET    | `/:rootUserId` | rootUserId (URL param) | Get hierarchical transaction visualization |

### Homepage `/homepage`

| Method | Endpoint | Parameters | Description                      |
| ------ | -------- | ---------- | -------------------------------- |
| GET    | `/`      | -          | Get homepage data and statistics |

#### Complete Registration Details

The `/complete-registration/:id` endpoint accepts:

- **URL Parameter**: user ID
- **Form Data**:
  - `dateOfBirth`: User's date of birth
  - `governmentIdNumber`: Government ID number/string
  - `profilePhoto`: Profile photo image file (max 5MB)
  - `governmentIdImage`: Government ID image file (max 5MB)
- **Response**: Updates user profile with all provided information and sets KYC status to "pending"

## Status Codes

- 200: OK
- 201: Created
- 400: Bad Request
- 401: Unauthorized
- 404: Not Found
- 500: Server Error

## Transaction Types

- transfer
- deposit
- withdrawal

## Models

```javascript
User {
  name: String,
  email: String,
  password: String,
  balance: Number,
  role: String,
  profilePhoto: {
    data: Buffer,
    contentType: String
  },
  governmentId: {
    data: Buffer,
    contentType: String
  },
  kycStatus: String,  // "not_submitted", "pending", "approved", "rejected"
  transactionPin: String
}

Transaction {
  sender: ObjectId,
  receiver: ObjectId,
  amount: Number,
  transactionType: String,
  description: String,
  status: String
}
```

## File Upload Requirements

### Profile Photo

- Max size: 5MB
- Type: Images only (JPEG, PNG, etc.)
- Updates user's profile photo field

### Government ID

- Max size: 5MB
- Type: Images only (JPEG, PNG, etc.)
- Updates user's government ID field
- Automatically sets KYC status to "pending" for admin review
