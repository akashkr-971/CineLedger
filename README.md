# 🎬 CineLedger

CineLedger is a **personal movie tracking application** built with **Flutter and Firebase** that allows users to log, rate, and remember every movie they’ve watched — all in one clean, cinematic interface.

This project is currently **under active development** 🚧.

---

## ✨ What is CineLedger?

Most people casually track movies using notes or multiple streaming apps. CineLedger solves this by providing a **single, personal movie ledger** where you can:

- Track movies you’ve watched
- Rate and review them
- Organize them by year, genre, and franchise
- Discover new movies based on your taste (planned)

CineLedger is **not a social network** — it’s designed as a **private, personal journal** for movie lovers.

---

## 🚧 Project Status

> **⚠️ Ongoing Project**

CineLedger is actively being developed. Core infrastructure and authentication are complete, and feature development is in progress.

Planned features and improvements are listed below.

---

## 🛠️ Tech Stack

### Frontend

- **Flutter** (Material 3)
- **Dart**
- **Riverpod** (State Management)

### Backend & Services

- **Firebase Authentication**
  - Google Sign-In
  - Email/Password (planned)
- **Cloud Firestore** (planned)
- **TMDB API** (planned – movie metadata)

### Platform

- Android (Primary)
- iOS (Planned)

---

## 🎨 Design Philosophy

- **Dark, cinematic theme** inspired by movie theaters
- Minimal UI that keeps focus on movie posters
- Emotion-driven accents for ratings and highlights
- Consistent design system with centralized theming

---

## 🔐 Authentication (Completed)

- Google Sign-In using Firebase Auth
- Secure user session handling
- Auth-based routing (Login ↔ Home)

---

## 🧱 Current Features

- ✅ Firebase setup & authentication
- ✅ Google Sign-In
- ✅ App theming & branding
- ✅ Custom app icon & splash screen
- ✅ Clean project architecture

---

## 🚀 Planned Features

- 🔍 Movie search using TMDB API
- 🎞️ Movie card UI (poster, rating, year)
- ➕ Add movies to personal library
- ⭐ Rate & review movies
- 📊 Viewing statistics & insights
- 🧠 Movie recommendations
- 📷 OCR import from notes (future enhancement)
- 📱 iOS support

---

## 📂 Project Structure

```text
lib/
├── core/
│   └── theme/
├── features/
│   ├── auth/
│   ├── home/
│   └── movies/ (upcoming)
├── main.dart
assets/
└── logo/
```

---

## 🔧 Setup Instructions

> **Note:** Firebase configuration files are intentionally excluded from this repository for security reasons.

### Clone the repository

```bash
git clone https://github.com/<your-username>/cineledger.git
cd cineledger
```

### Install dependencies

```bash
flutter pub get
```

### Set up Firebase

- Create a Firebase project
- Enable Google Authentication
- Add your own google-services.json file

Run the app

```bash
flutter run
```

---

## 🔒 Security Notice

Sensitive configuration files such as:

- google-services.json

- GoogleService-Info.plist

are not included in this repository and must be added locally.

---

## 🤝 Contributing

This project is currently a personal learning & portfolio project, but suggestions and feedback are always welcome.

Feel free to:

- Open an issue

- Suggest features

- Share feedback

---

## 📌 License

This project is currently not licensed for commercial use.

License details will be added once the project stabilizes.
