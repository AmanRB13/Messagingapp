# 💬 MessagingApp – Real-Time Chat Application

A modern **one-to-one real-time chat application** built using **Flutter** and **Firebase**.

MessagingApp provides secure authentication, instant messaging, user search, dark mode support, and a clean Material Design interface. The application uses **Firebase Authentication** for user management, **Cloud Firestore** for real-time message synchronization, and **Provider** for efficient state management.

---

# 📱 Application Screenshots

## 🔐 Authentication

### Login Screen

<img width="301" height="503" alt="image" src="https://github.com/user-attachments/assets/3a41c8d6-3e49-4c17-936e-1d898e06fe55" />


### Registration Screen

<img width="321" height="556" alt="image" src="https://github.com/user-attachments/assets/7c2cbb6f-6e9c-47ef-8a79-9c03d84c8c8b" />

---

## 🏠 Home Screen

The home screen displays registered users and allows users to search and start conversations.
<img width="302" height="665" alt="image" src="https://github.com/user-attachments/assets/03dba5a7-d8b0-4546-bf80-7217f892e10f" />

---

## 💬 Chat Screen

Real-time one-to-one messaging interface with message actions.

<img width="312" height="662" alt="image" src="https://github.com/user-attachments/assets/86c78279-0309-45b7-8975-6426d7aafb99" />

---

## 🌙 Dark Mode

Supports dynamic light and dark themes.

<img width="307" height="681" alt="image" src="https://github.com/user-attachments/assets/ca6c4841-6217-4f63-872f-62ae8910e7f8" />


---

# ✨ Features

## 🔐 Authentication

- User registration using Firebase Authentication
- Email and password-based login
- Secure authentication flow
- Persistent user sessions
- Logout functionality
- Firebase user management


---

# 💬 Real-Time Messaging

- One-to-one private conversations
- Instant message synchronization using Cloud Firestore
- Messages update automatically without refreshing
- Unique chat rooms for different users
- Timestamp support for messages
- Real-time updates using `StreamBuilder`


---

# 👥 User Management

- Displays all registered users
- Search users by email
- Start conversations instantly
- Automatically hides the current logged-in user
- User data stored securely in Firestore


---

# 📋 Message Features

Users can interact with messages using:

- 📋 Copy message text
- 🗑 Delete sent messages
- Long press message options
- Message timestamps
- Separate sender and receiver message styling


---

# ⌨️ Chat Experience

- Multi-line message input
- Smooth keyboard handling
- Responsive chat layout
- Automatic message updates
- Clean chat bubble interface


---

# 🌙 Dark Mode

- Dynamic theme switching
- Light and dark theme support
- Theme state management using Provider
- Consistent theme across the application


---

# 🎨 UI/UX Features

- Clean Material Design interface
- Responsive layouts
- Modern authentication screen
- Custom chat bubbles
- Smooth navigation
- Reusable UI components


---

# 🏗 Application Architecture

The project follows a structured and maintainable architecture.

```
lib/
│
├── Functions/
│   └── auth.dart
│
├── Pages/
│   ├── homepage.dart
│   └── loginpage.dart
    └── auth_wrapper.dart

│
├── Services/
│   ├── chats.dart
│   
│
├── Theme/
│   └── themeprovider.dart
    └── mode.dart
│
└── main.dart
```

---

# 🔥 Firebase Structure

## Users Collection

```
users
 |
 └── userId
      |
      ├── uid
      ├── email
      └── createdAt
```

## Chats Collection

```
chats
 |
 └── chatId
      |
      └── messages
            |
            ├── text
            ├── senderUid
            └── timestamp
```

---

# 🛠 Tech Stack

## Frontend

- Flutter
- Dart
- Material Design


## Backend

- Firebase Authentication
- Cloud Firestore


## State Management

- Provider
- StreamBuilder


## Additional Packages

- `firebase_auth`
- `cloud_firestore`
- `google_sign_in`
- `provider`
- `intl`
- `url_launcher`

---

# 🚀 Getting Started

## 1. Clone the Repository

```bash
git clone https://github.com/yourusername/messagingapp.git
```

---

## 2. Install Dependencies

```bash
flutter pub get
```

---

## 3. Configure Firebase

Create a Firebase project and connect it with your Flutter application.

Enable:

- Firebase Authentication
- Cloud Firestore


Add Firebase configuration files:

### Android

```
android/app/google-services.json
```

### iOS

```
ios/Runner/GoogleService-Info.plist
```

---

## 4. Run Application

```bash
flutter run
```

---

# 🔑 Firebase Authentication Setup

Enable:

```
Firebase Console
        |
        |
Authentication
        |
        |
Sign-in providers
        |
        |
Enable Email/Password
```

For Google Sign-In:

- Enable Google provider
- Add SHA-1 and SHA-256 fingerprints
- Download updated Firebase configuration


---

# 📂 Screenshots Folder

Add screenshots inside:

```
screenshots/
│
├── login.png
├── register.png
├── home.png
├── chat.png
└── dark_mode.png
```

---

# 🔮 Future Improvements

Upcoming features:

- 👤 User profile pictures
- 🟢 Online/offline status
- ✍️ Typing indicator
- ✓ Message delivery status
- 👀 Read receipts
- 📷 Image sharing
- 📎 File sharing
- 🔔 Push notifications
- 👥 Group chats
- 🎤 Voice messages
- ❤️ Message reactions


---

# 🤝 Contribution

Contributions, issues, and feature requests are welcome.

Feel free to improve the project and submit a pull request.


---

# 👨‍💻 Developer

Developed with:

**Flutter + Firebase**

---

⭐ If you find this project useful, consider giving it a star!
