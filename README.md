# Internal Wallet Transaction API

This project is a simple Internal Wallet Transaction API built with Ruby on Rails. It provides a way to handle transactions such as **deposits**, **withdrawals**, and **transfers** between user wallets. 

## 1. Overview

The API supports basic wallet operations for users:
- **Depositing** money into a wallet (Credit)
- **Withdrawing** money from a wallet (Debit)
- **Transferring** money between wallets (Transfer)

Each **User** is associated with a **Wallet** that holds their balance. Transactions record these movements of money.

---

## 2. Entities and Relationships

### **User**
- Each user is created with an associated wallet that stores their balance.

### **Wallet**
- Stores the user's balance and is automatically created upon user creation.

### **Transaction**
- Records money transfers, deposits, and withdrawals.
- Types: **credit**, **debit**, **transfer**.

---

## 3. Flow of the Wallet System

1. **User Creation**: Users are created with an empty wallet (balance = `0.0` by default).
2. **Transaction Types**:
   - **Credit (Deposit)**: Adds money to a user’s wallet.
   - **Debit (Withdrawal)**: Subtracts money from a user’s wallet.
   - **Transfer**: Moves money from one wallet to another.
3. **Error Handling**:
   - Errors occur if there are insufficient funds or invalid wallet/user IDs.

---

## 4. Endpoints and Usage

### **1. Get All Transactions (GET /transactions)**

**Description**: Retrieve all transactions.

- **Method**: GET
- **Endpoint**: `/transactions`

**Response Example**:
```json
[
  {
    "id": 1,
    "source_wallet_id": null,
    "target_wallet_id": 2,
    "amount": 500.0,
    "transaction_type": "credit",
    "created_at": "2024-09-21T06:30:21Z",
    "updated_at": "2024-09-21T06:30:21Z"
  },
  {
    "id": 2,
    "source_wallet_id": 1,
    "target_wallet_id": null,
    "amount": 100.0,
    "transaction_type": "debit",
    "created_at": "2024-09-21T06:32:15Z",
    "updated_at": "2024-09-21T06:32:15Z"
  }
]
