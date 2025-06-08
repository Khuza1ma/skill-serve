# Skill Serve

A modern Flutter web application for skill management and services.

## 🚀 Features

- Modern and responsive web interface
- Data visualization with charts and graphs
- Form handling and validation
- Secure data storage and encryption
- Cross-platform compatibility
- State management with GetX
- Beautiful UI with Material Design

## 📋 Prerequisites

- Flutter SDK (^3.32.)
- Dart SDK
- Web browser (Chrome recommended for development)
- Git

## 🛠️ Installation

1. Clone the repository:
```bash
git clone [https://github.com/Khuza1ma/skill-serve.git]
cd skill_serve
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run -d chrome
```

## 🏗️ Project Structure

```
lib/
├── app/
│   ├── constants/     # App-wide constants and configurations
│   ├── data/         # Data models and repositories
│   ├── middleware/   # Route middleware and interceptors
│   ├── modules/      # Feature modules
│   ├── routes/       # Route definitions
│   ├── ui/          # Shared UI components
│   └── utils/       # Utility functions and helpers
├── assets/
│   ├── images/      # Image assets
│   └── lottie/      # Lottie animation files
```

## 📦 Dependencies

- **State Management**: GetX (^4.7.2)
- **UI Components**: 
  - flutter_svg (^2.0.17)
  - google_fonts (^6.2.1)
  - flutter_form_builder (^10.0.1)
- **Data Handling**:
  - dio (^5.8.0+1)
  - get_storage (^2.1.1)
  - encrypt (^5.0.3)
- **Charts and Visualization**:
  - fl_chart (^0.68.0)
  - syncfusion_flutter_datagrid (^29.1.38)
- **Utilities**:
  - logger (^2.5.0)
  - cached_network_image (^3.1.0)
  - lottie (^3.3.1)
  - flutter_easyloading (^3.0.5)

## 🔧 Development

1. **Running in Development Mode**
```bash
flutter run -d chrome
```

2. **Building for Production**
```bash
flutter build web
```

## 📱 Supported Platforms

- Web (Chrome, Firefox, Safari, Edge)
- Responsive design for various screen sizes

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
