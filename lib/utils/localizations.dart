import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // App strings
  String get appName => 'ChatCall Pro';
  String get welcome => 'Welcome to ChatCall Pro';
  String get login => 'Login';
  String get register => 'Register';
  String get email => 'Email';
  String get password => 'Password';
  String get displayName => 'Display Name';
  String get chat => 'Chat';
  String get calls => 'Calls';
  String get contacts => 'Contacts';
  String get settings => 'Settings';
  String get videoCall => 'Video Call';
  String get voiceCall => 'Voice Call';
  String get endCall => 'End Call';
  String get mute => 'Mute';
  String get unmute => 'Unmute';
  String get cameraOn => 'Camera On';
  String get cameraOff => 'Camera Off';
  String get sendMessage => 'Send Message';
  String get typeMessage => 'Type a message...';
  String get connecting => 'Connecting...';
  String get callEnded => 'Call Ended';
  String get noInternet => 'No internet connection';
  String get tryAgain => 'Try Again';
  String get cancel => 'Cancel';
  String get ok => 'OK';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es', 'fr', 'de'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
