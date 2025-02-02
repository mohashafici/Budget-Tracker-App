# 📊 Personal Budget Tracker

A Flutter-based mobile application that helps users track their income, expenses, and budget goals efficiently. The app integrates with a Node.js backend using MongoDB as the database.

## 📌 Features

- **User Authentication**: Login and register securely.
- **Transaction Management**: Add, edit, and delete transactions.
- **Search & Filter Transactions**: Easily find and filter transactions.
- **Monthly Budget Goal Tracking**: Set and track budget goals.
- **Data Visualization**: View charts and reports for better insights.
- **Secure API Communication**: JWT authentication for secure data transfer.
- **Export Transactions**: Save transactions as CSV files.

## 🚀 Tech Stack

### Frontend (Mobile App)
- **Flutter (Dart)**
- **GetX**: State management.
- **Dio**: API calls.
- **Flutter Secure Storage**: Token storage.

### Backend (Server)
- **Node.js (Express.js)**
- **MongoDB**: Database.
- **Mongoose**: ODM.
- **Bcrypt.js**: Password hashing.
- **JWT (JSON Web Token)**: Authentication.

## 🛠 Installation & Setup

### Clone the Repository
```bash
git clone https://github.com/mohashafici/Budget-Tracker-App
cd personal-budget-tracker
```

### Backend Setup
1. Navigate to the backend folder:
   ```bash
   cd backend
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Create a `.env` file and add:
   ```env
   MONGO_URI=your_mongodb_connection
   JWT_SECRET=your_jwt_secret
   PORT=8000
   ```
4. Run the backend:
   ```bash
   npm start
   ```

### Flutter Setup
1. Navigate to the Flutter folder:
   ```bash
   cd flutter-app
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## 👥 Team & Responsibilities

| Name                        | Role                          | Assigned Files                                                                 |
|-----------------------------|-------------------------------|--------------------------------------------------------------------------------|
| Mohamed Shafici (Admin)     | Project Manager & API Lead    | Backend (Server, API, Database)                                                |
| Mohamed Shafici             | Authentication & Security     | `auth_service.dart`, `auth_controller.dart`, `login_screen.dart`, `register_screen.dart` |
| Mohamed Abdi Ali            | UI/UX Design & Navigation     | `main_screen.dart`, `home_screen.dart`, `settings_screen.dart`                 |
| Abdi Shakuur Mohamed Nuur   | Transactions & Filtering      | `transaction_controller.dart`, `add_transaction_screen.dart`, `transaction_list_screen.dart`, `transaction_search_delegate.dart` |
| Abdirizaq calas Ali       | Budget Tracking & Analytics   | `budget_controller.dart`, `stats_screen.dart`                                  |
| Naasir Osman Abdi           | Database & Backend API        | `server.js`, `routes/transactions.js`, `routes/auth.js`, `models/userModel.js` |

## 🎯 API Endpoints

| Endpoint                  | Method | Description                      |
|---------------------------|--------|----------------------------------|
| `/api/users/register`     | POST   | Register a new user              |
| `/api/users/login`        | POST   | Login user & get JWT token       |
| `/api/transactions`       | GET    | Get all transactions             |
| `/api/transactions`       | POST   | Add a new transaction            |
| `/api/transactions/:id`   | PUT    | Update transaction               |
| `/api/transactions/:id`   | DELETE | Delete transaction               |
| `/api/budget`             | GET    | Get user budget goal             |
| `/api/budget`             | POST   | Set budget goal                  |

## 📌 Future Enhancements

- Add multi-currency support.
- Implement dark mode UI.
- Integrate Google Sign-In.
- Add expense category insights.



## 📄 License

This project is MIT licensed. Feel free to use and modify.

🎉 Happy Coding! 🚀
