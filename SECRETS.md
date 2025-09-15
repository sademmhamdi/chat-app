# Environment Variables & Secrets

This Flutter app uses environment variables to securely manage API keys and secrets. This prevents hard-coded secrets from being committed to version control.

## Setup

### 1. Create Environment Variables

Create a `.env` file in the root of your project (add it to `.gitignore`):

```bash
# Agora RTC Engine
AGORA_APP_ID=your_actual_agora_app_id_here

# Firebase (if needed)
FIREBASE_API_KEY=your_firebase_api_key
FIREBASE_PROJECT_ID=your_project_id
```

### 2. Build Commands with Secrets

#### Android APK:
```bash
flutter build apk --dart-define=AGORA_APP_ID=your_actual_app_id
```

#### Android App Bundle:
```bash
flutter build appbundle --dart-define=AGORA_APP_ID=your_actual_app_id
```

#### iOS:
```bash
flutter build ios --dart-define=AGORA_APP_ID=your_actual_app_id
```

#### Web:
```bash
flutter build web --dart-define=AGORA_APP_ID=your_actual_app_id
```

### 3. Development

For development, you can set environment variables in your IDE or use:

```bash
# Windows PowerShell
$env:AGORA_APP_ID="your_actual_app_id"
flutter run

# Or inline
flutter run --dart-define=AGORA_APP_ID=your_actual_app_id
```

## Security Best Practices

1. **Never commit secrets** to version control
2. **Use different keys** for development and production
3. **Rotate keys regularly** for security
4. **Use CI/CD secrets** for automated builds
5. **Validate keys** before deployment

## CI/CD Integration

### GitHub Actions Example:
```yaml
- name: Build Android
  run: flutter build apk --dart-define=AGORA_APP_ID=${{ secrets.AGORA_APP_ID }}
```

### Firebase App Distribution:
```yaml
- name: Distribute to Firebase
  run: |
    flutter build apk --dart-define=AGORA_APP_ID=${{ secrets.AGORA_APP_ID }}
    firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk \
      --app ${{ secrets.FIREBASE_APP_ID }} \
      --groups "testers"
```

## Current Secrets

- `AGORA_APP_ID`: Required for video calling functionality
- Default fallback: Shows placeholder until real key is provided

## Validation

The app will show a warning if secrets are not properly configured:
- Video calling will be disabled on web (by design)
- Mobile apps will show "YOUR_AGORA_APP_ID" placeholder until configured