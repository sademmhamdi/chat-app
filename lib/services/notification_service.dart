import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chattach/services/auth_service.dart';
import 'package:chattach/screens/home_screen.dart';
import 'package:chattach/screens/auth_screen.dart';

class NotificationService {
  static void showInAppNotification(
    BuildContext context, {
    required String title,
    required String message,
    IconData icon = Icons.notifications,
    Color color = Colors.blue,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 10,
        right: 10,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: color),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(message),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => overlayEntry.remove(),
                  child: Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto remove after 4 seconds
    Future.delayed(Duration(seconds: 4), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}

// Setup Instructions and Configuration

/*
SETUP INSTRUCTIONS:

1. FIREBASE SETUP:
   - Create a new Firebase project at https://console.firebase.google.com
   - Enable Authentication (Email/Password)
   - Enable Firestore Database
   - Enable Storage
   - Add your Android/iOS apps to the Firebase project
   - Download google-services.json (Android) and GoogleService-Info.plist (iOS)
   - Run: flutter pub add firebase_core firebase_auth cloud_firestore firebase_storage
   - Run: dart pub global activate flutterfire_cli
   - Run: flutterfire configure

2. AGORA SETUP:
   - Create account at https://www.agora.io
   - Create a project and get your App ID
   - Replace "YOUR_AGORA_APP_ID" in call_service.dart with your actual App ID
   - For production, implement token authentication

3. ANDROID CONFIGURATION:
   - Add to android/app/build.gradle:
     minSdkVersion 21
     compileSdkVersion 33
     targetSdkVersion 33
   
   - Add permissions to android/app/src/main/AndroidManifest.xml:
     <uses-permission android:name="android.permission.INTERNET" />
     <uses-permission android:name="android.permission.CAMERA" />
     <uses-permission android:name="android.permission.RECORD_AUDIO" />
     <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

4. IOS CONFIGURATION:
   - Add to ios/Runner/Info.plist:
     <key>NSCameraUsageDescription</key>
     <string>This app needs camera access for video calls</string>
     <key>NSMicrophoneUsageDescription</key>
     <string>This app needs microphone access for calls</string>
     <key>NSPhotoLibraryUsageDescription</key>
     <string>This app needs photo library access to share images</string>

5. DEPENDENCIES:
   Add to pubspec.yaml:
   dependencies:
     flutter:
       sdk: flutter
     firebase_core: ^2.24.2
     firebase_auth: ^4.15.3
     cloud_firestore: ^4.13.6
     firebase_storage: ^11.5.6
     agora_rtc_engine: ^6.3.2
     image_picker: ^1.0.4
     file_picker: ^6.1.1
     cached_network_image: ^3.3.0
     provider: ^6.1.1
     uuid: ^4.2.1
     intl: ^0.19.0

6. FIRESTORE SECURITY RULES:
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
         allow read: if request.auth != null;
       }
       
       match /chatRooms/{chatRoomId} {
         allow read, write: if request.auth != null && 
           request.auth.uid in resource.data.participants;
       }
       
       match /chatRooms/{chatRoomId}/messages/{messageId} {
         allow read, write: if request.auth != null;
       }
     }
   }

7. STORAGE SECURITY RULES:
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       match /chat_files/{allPaths=**} {
         allow read, write: if request.auth != null;
       }
       match /profile_images/{allPaths=**} {
         allow read, write: if request.auth != null;
       }
     }
   }

FEATURES INCLUDED:
✅ Firebase Authentication (Email/Password)
✅ Real-time Chat with Firestore
✅ Group Chat Creation
✅ File & Image Sharing
✅ Video/Audio Calls with Agora
✅ Built-in Games (Tic Tac Toe, Word Guess, Rock Paper Scissors, Number Guess)
✅ User Search & Contact Management
✅ Online Status Tracking
✅ Message History
✅ Professional UI/UX
✅ Loading States & Error Handling
✅ Responsive Design

PRODUCTION CONSIDERATIONS:
- Implement proper error handling and retry logic
- Add push notifications for messages and calls
- Implement message encryption for security
- Add user blocking and reporting features
- Implement proper file upload progress indicators
- Add message search functionality
- Implement call recording features
- Add message reactions and replies
- Implement voice messages
- Add dark mode support
- Implement user profiles with status messages
- Add call history tracking
- Implement group admin features
- Add message forwarding
- Implement read receipts
*/

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        if (authService.user != null) {
          return HomeScreen();
        }
        return AuthScreen();
      },
    );
  }
}
