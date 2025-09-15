# ChatCall Pro 📱💬

[![Flutter](https://img.shields.io/badge/Flutter-3.32.8-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.8.1-blue.svg)](https://dart.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

A modern, cross-platform chat and video calling application built with Flutter. Features real-time messaging, video calls, group chats, and more!

## ✨ Features

- 🔐 **Firebase Authentication** - Secure user authentication
- 💬 **Real-time Chat** - Instant messaging with Firestore
- 📹 **Video Calling** - High-quality video calls with Agora RTC
- 👥 **Group Chats** - Create and manage group conversations
- 📱 **Cross-Platform** - Android, iOS, and Web support
- 🌍 **Internationalization** - Multi-language support (EN, ES, FR, DE)
- ♿ **Accessibility** - Screen reader support and semantic widgets
- 🎨 **Modern UI** - Material Design 3 with beautiful animations
- 🔒 **Security First** - Environment variables for API keys
- 📸 **Media Sharing** - Image and file sharing capabilities

## 🚀 Quick Start

### Prerequisites

- Flutter 3.32.8 or higher
- Dart 3.8.1 or higher
- Firebase project setup
- Agora RTC Engine account (for video calling)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/sademmhamdi/chat-app.git
   cd chat-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication, Firestore, and Storage
   - Download `google-services.json` and place it in `android/app/`
   - Update `lib/firebase_options.dart` with your Firebase config

4. **Configure Agora (for video calling)**
   ```bash
   # Create .env file
   echo "AGORA_APP_ID=your_agora_app_id_here" > .env
   ```

5. **Run the app**
   ```bash
   flutter run --dart-define=AGORA_APP_ID=your_agora_app_id_here
   ```

## 🏗️ Build Commands

### Android
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release --dart-define=AGORA_APP_ID=your_key

# App Bundle
flutter build appbundle --release --dart-define=AGORA_APP_ID=your_key
```

### iOS (macOS only)
```bash
flutter build ios --release --dart-define=AGORA_APP_ID=your_key
```

### Web
```bash
flutter build web --release --dart-define=AGORA_APP_ID=your_key
```

## 📁 Project Structure

```
lib/
├── models/           # Data models
├── screens/          # UI screens
├── services/         # Business logic and API calls
├── utils/            # Utilities and helpers
├── widgets/          # Reusable widgets
└── main.dart         # App entry point

android/              # Android-specific code
ios/                  # iOS-specific code
web/                  # Web-specific code
```

## 🤝 Contributing

We welcome contributions from the community! Here's how you can help:

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
4. **Test your changes**
   ```bash
   flutter test
   flutter analyze
   ```
5. **Commit your changes**
   ```bash
   git commit -m 'Add amazing feature'
   ```
6. **Push to the branch**
   ```bash
   git push origin feature/amazing-feature
   ```
7. **Open a Pull Request**

### Development Guidelines

- Follow Flutter best practices
- Write clear, concise commit messages
- Add tests for new features
- Update documentation as needed
- Ensure code passes `flutter analyze`

### Areas for Contribution

- 🐛 **Bug Fixes** - Help us squash bugs
- ✨ **New Features** - Add exciting new functionality
- 🎨 **UI/UX Improvements** - Enhance the user experience
- 🌍 **Translations** - Add support for more languages
- 📱 **Platform Support** - Desktop or other platforms
- 🧪 **Testing** - Improve test coverage
- 📚 **Documentation** - Help improve docs

## 🔧 Configuration

### Environment Variables

Create a `.env` file in the root directory:

```bash
# Agora RTC Engine
AGORA_APP_ID=your_agora_app_id

# Firebase (optional - can be configured in firebase_options.dart)
FIREBASE_API_KEY=your_firebase_api_key
```

### Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Enable Authentication with Email/Password
4. Enable Firestore Database
5. Enable Storage
6. Add your app and download config files

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## 📊 Code Quality

```bash
# Analyze code
flutter analyze

# Format code
dart format lib/

# Check for unused files
flutter pub run dart_code_metrics:metrics check-unused-files lib
```

## 🚀 Deployment

### Android
- Generate signed APK/AAB using Android Studio or command line
- Upload to Google Play Store

### iOS
- Configure code signing in Xcode
- Archive and upload to App Store Connect

### Web
- Deploy to Firebase Hosting, Vercel, or any static hosting
- Configure PWA settings in `web/manifest.json`

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) - The framework that makes this possible
- [Firebase](https://firebase.google.com/) - Backend services
- [Agora](https://www.agora.io/) - Video calling SDK
- [Material Design](https://material.io/) - Design system

## 📞 Support

- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/sademmhamdi/chat-app/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/sademmhamdi/chat-app/discussions)
- 📧 **Email**: sademmhamdi@github.com

## 🎯 Roadmap

- [ ] Push notifications
- [ ] Voice messages
- [ ] File sharing improvements
- [ ] Dark mode
- [ ] End-to-end encryption
- [ ] Desktop app support
- [ ] Advanced call features (screen sharing, recording)

---

**Made with ❤️ by [Sadem Mhamdi](https://github.com/sademmhamdi)**

⭐ Star this repo if you find it helpful!
