# Contributing to ChatCall Pro

Thank you for your interest in contributing to ChatCall Pro! 🎉

We welcome contributions from developers of all skill levels. Whether you're fixing bugs, adding features, improving documentation, or helping with testing, your contributions are valuable to us.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Community](#community)

## 🤝 Code of Conduct

This project follows a code of conduct to ensure a welcoming environment for all contributors. By participating, you agree to:

- Be respectful and inclusive
- Focus on constructive feedback
- Accept responsibility for mistakes
- Show empathy towards other contributors
- Help create a positive community

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have:

- Flutter 3.32.8 or higher
- Dart 3.8.1 or higher
- Git
- A code editor (VS Code, Android Studio, etc.)
- Basic knowledge of Flutter/Dart

### Quick Setup

1. **Fork the repository** on GitHub
2. **Clone your fork**:
   ```bash
   git clone https://github.com/your-username/chat-app.git
   cd chat-app
   ```
3. **Set up upstream remote**:
   ```bash
   git remote add upstream https://github.com/sademmhamdi/chat-app.git
   ```
4. **Install dependencies**:
   ```bash
   flutter pub get
   ```
5. **Run the app**:
   ```bash
   flutter run
   ```

## 💡 How to Contribute

### Types of Contributions

- 🐛 **Bug Fixes** - Fix existing issues
- ✨ **Features** - Add new functionality
- 📚 **Documentation** - Improve docs and guides
- 🎨 **UI/UX** - Enhance user interface and experience
- 🧪 **Testing** - Add or improve tests
- 🌍 **Internationalization** - Add language support
- ♿ **Accessibility** - Improve accessibility features

### Finding Issues to Work On

1. Check [GitHub Issues](https://github.com/sademmhamdi/chat-app/issues) for open issues
2. Look for issues labeled `good first issue` or `help wanted`
3. Comment on the issue to indicate you're working on it
4. Wait for maintainer approval before starting work

## 🛠️ Development Setup

### Environment Configuration

1. **Firebase Setup**:
   - Create a Firebase project
   - Enable Authentication, Firestore, and Storage
   - Download configuration files

2. **Agora Setup** (for video calling):
   ```bash
   # Create environment file
   cp .env.example .env
   # Edit .env with your Agora App ID
   ```

3. **Run with environment variables**:
   ```bash
   flutter run --dart-define=AGORA_APP_ID=your_app_id
   ```

### Development Workflow

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following our coding standards

3. **Test your changes**:
   ```bash
   flutter analyze
   flutter test
   ```

4. **Commit your changes**:
   ```bash
   git add .
   git commit -m "feat: add amazing new feature"
   ```

5. **Push and create PR**:
   ```bash
   git push origin feature/your-feature-name
   ```

## 📝 Coding Standards

### Flutter/Dart Best Practices

- Follow the [Flutter Style Guide](https://flutter.dev/docs/development/tools/formatting)
- Use `flutter format` to format your code
- Write clear, descriptive variable and function names
- Add comments for complex logic
- Use const constructors where possible

### Code Structure

```
lib/
├── models/           # Data models (use freezed if possible)
├── screens/          # UI screens (keep widgets small)
├── services/         # Business logic (single responsibility)
├── utils/            # Utilities and helpers
├── widgets/          # Reusable widgets
└── main.dart         # App entry point
```

### Commit Message Format

We use conventional commits:

```
type(scope): description

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Testing
- `chore`: Maintenance

Examples:
```
feat: add dark mode support
fix: resolve video call connection issue
docs: update installation guide
```

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/auth_service_test.dart
```

### Writing Tests

- Write unit tests for services and utilities
- Write widget tests for UI components
- Add integration tests for critical user flows
- Aim for good test coverage (>80%)

Example test structure:
```dart
void main() {
  group('AuthService', () {
    test('should sign in user successfully', () async {
      // Test implementation
    });
  });
}
```

## 📤 Submitting Changes

### Pull Request Process

1. **Ensure your branch is up to date**:
   ```bash
   git fetch upstream
   git rebase upstream/master
   ```

2. **Create a Pull Request**:
   - Go to your fork on GitHub
   - Click "New Pull Request"
   - Select your feature branch
   - Fill out the PR template

3. **PR Requirements**:
   - Clear title and description
   - Reference any related issues
   - Include screenshots for UI changes
   - Ensure all tests pass
   - Code passes `flutter analyze`

4. **Wait for Review**:
   - Address any feedback from maintainers
   - Make requested changes
   - Keep your branch updated

### PR Template

```markdown
## Description
Brief description of the changes made

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## How Has This Been Tested?
- [ ] Unit tests
- [ ] Integration tests
- [ ] Manual testing

## Screenshots (if applicable)
Add screenshots of UI changes

## Checklist
- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
```

## 🌟 Recognition

Contributors will be:
- Listed in the project's contributors file
- Mentioned in release notes
- Recognized in the README
- Invited to join the project maintainers (for significant contributions)

## 📞 Getting Help

- 📧 **Email**: sademmhamdi@github.com
- 💬 **Discussions**: [GitHub Discussions](https://github.com/sademmhamdi/chat-app/discussions)
- 🐛 **Issues**: [GitHub Issues](https://github.com/sademmhamdi/chat-app/issues)

## 📋 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Agora Documentation](https://docs.agora.io/)

---

Thank you for contributing to ChatCall Pro! 🚀