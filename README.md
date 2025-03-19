# BHub - Badminton Hub Application

BHub is a comprehensive platform for badminton enthusiasts to join hub groups, make payments, and manage their profiles. The project consists of two main components:

1. **API Backend** - A Go-based REST API that handles data management and business logic
2. **Mobile App** - A Flutter-based mobile application for end users

## Project Structure

```
/apps
  /api        - Go backend API
  /bhub       - Flutter mobile application
```

## Prerequisites

To run the complete BHub application, you'll need:

- **For API Backend:**
  - Go 1.21 or higher
  - Firebase project with Firestore
  - Firebase service account credentials

- **For Mobile App:**
  - Flutter SDK
  - Dart SDK
  - Firebase project setup
  - Android Studio or Xcode (for device emulation)

## Setting Up the API Backend

### 1. Configure Environment

Create a `.env` file in the `/apps/api` directory with the following variables:

```
APP_ENV=development
FIREBASE_CREDENTIALS_PATH=/path/to/your/firebase-credentials.json
GOOGLE_CLOUD_PROJECT=your-project-id
PORT=8080
```

Note: The Firebase credentials file should be placed in a secure location and referenced in the `.env` file.

### 2. Run the API

```bash
cd /apps/api
go mod download  # Download dependencies
go run cmd/main.go
```

Alternatively, you can use Docker:

```bash
cd /apps/api
docker build -t bhub-api .
docker run -p 8080:8080 --env-file .env bhub-api
```

### 3. Verify API is Running

Access `http://localhost:8080/health` in your browser or via curl. You should receive a response:

```json
{"status": "ok"}
```

## Setting Up the Mobile App

### 1. Install Dependencies

```bash
cd /apps/bhub
flutter pub get
```

### 2. Configure Firebase

Follow the instructions in the Firebase console to add your app to your Firebase project:

- For Android: Place the `google-services.json` file in `/apps/bhub/android/app/`
- For iOS: Place the `GoogleService-Info.plist` file in `/apps/bhub/ios/Runner/`

### 3. Run the App

```bash
cd /apps/bhub
flutter run
```

This will launch the app on a connected device or emulator.

## Features

### API Backend

- User authentication and management
- BHub creation and management
- Payment processing
- Data storage with Firestore

### Mobile App

- User authentication with Firebase
- Browse available BHubs
- Join BHubs and make payments
- View payment history
- Manage user profile

## Architecture

### API Backend

The API follows a standard Go application structure with:

- Controllers for handling HTTP requests
- Services for business logic
- Repositories for data access
- Models for data structures

### Mobile App

The mobile app follows the MVC (Model-View-Controller) architecture pattern:

- **Models**: Define data structures
- **Views**: UI components and screens
- **Controllers**: Business logic and API communication

## Troubleshooting

### API Issues

- **Firebase Connection Errors**: Verify your credentials file and permissions
- **Port Already in Use**: Change the PORT in your .env file
- **Missing Dependencies**: Run `go mod tidy` to update dependencies

### Mobile App Issues

- **Build Errors**: Run `flutter clean` followed by `flutter pub get`
- **Firebase Configuration**: Ensure Firebase is properly configured for both platforms
- **API Connection**: Check that the API URL in the app is correctly pointing to your running API instance

## Development

### API Development

For hot-reloading during development, you can use Air:

```bash
cd /apps/api
air
```

### Mobile App Development

For hot-reloading during development:

```bash
cd /apps/bhub
flutter run --hot
```

## Security Notes

- The Firebase credentials file (`bhub-local.json`) contains sensitive information and should not be committed to version control
- The `.env` file should also be excluded from version control
- Both files are already added to `.gitignore`