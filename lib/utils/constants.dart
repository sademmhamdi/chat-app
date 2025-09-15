import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'ChatCall Pro';
  static const String appVersion = '1.0.0';
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color secondaryColor = Color(0xFF42A5F5);
  static const Color errorColor = Color(0xFFE53935);
  static const Color successColor = Color(0xFF43A047);

  // Dimensions
  static const double defaultPadding = 16.0;
  static const double borderRadius = 12.0;

  // Message Types
  static const int maxMessageLength = 1000;
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB

  // Call Settings
  static const String agoraAppId =
      String.fromEnvironment('AGORA_APP_ID', defaultValue: 'YOUR_AGORA_APP_ID');
  static const int callTimeoutDuration = 30; // seconds
}
