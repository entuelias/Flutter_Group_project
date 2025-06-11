# Guardian App

A Flutter application for managing medical information and emergency contacts.

## Features

- User authentication (signup and login)
- Medical information management (add, edit, delete)
- Emergency contact management (add, edit, delete)
- User profile display

## Prerequisites

- Flutter SDK
- Node.js and npm
- MongoDB

## Setup

### Backend

1. Navigate to the `backend` directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create a `.env` file in the `backend` directory with the following content:
   ```
   MONGODB_URI=mongodb://localhost:27017/guardian_app
   JWT_SECRET=your_super_secret_jwt_key
   ```

4. Start the backend server:
   ```bash
   npm start
   ```

### Flutter App

1. Navigate to the project root directory.

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Usage

1. Sign up for a new account or log in with existing credentials.
2. Navigate through the app using the bottom navigation bar.
3. Add, edit, or delete medical information and emergency contacts as needed.
4. View your profile information.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
