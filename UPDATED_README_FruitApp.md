
# 🍎 Fruit Detector Flutter App

Welcome to the Fruit Detector App! This Flutter application allows users to detect fruits from images using machine learning and displays predictions with confidence scores. The app is integrated with Firebase for authentication and a Django backend for image classification.

## 📲 Features

- **User Authentication**: Sign up and log in securely via Firebase.
- **Image Classification**: Upload an image or use the camera to classify fruits.
- **Results Display**: Shows fruit name and prediction confidence.
- **History**: Track previous classification results.
- **Backend Integration**: Django-based API for image processing.

---

## ⚙️ Setup Instructions

### 1️⃣ **Clone the Repository**
```bash
git clone https://github.com/your-repo/fruit_detector.git
cd fruit_detector
```

### 2️⃣ **Install Dependencies**
Ensure you have Flutter installed. Then, run:
```bash
flutter pub get
```

### 3️⃣ **Firebase Configuration**
1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Create a new project.
3. Add an Android and iOS app and download the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files.
4. Place these files in the respective folders:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
5. Update the `firebase_options.dart` file if necessary.

### 4️⃣ **Backend API Configuration**
- Update the backend API URL in your Flutter app:
  Open `lib/main.dart` or relevant config file and replace the API endpoint:
```dart
const String backendApiUrl = 'http://your-backend-url/api/predict/';
```

### 5️⃣ **Run the Application**
For Android:
```bash
flutter run
```
For Web:
```bash
flutter run -d chrome
```

---

## 🔑 **Environment Variables**
Ensure your Firebase and API configurations are properly set up in:
- `google-services.json` (Android)
- `GoogleService-Info.plist` (iOS)
- Backend API URL in Dart configuration files.

---

## 🤝 Contributing
Feel free to contribute by submitting a pull request. Make sure to discuss significant changes via issues first.

---

## 🛠️ Troubleshooting
- **Camera not working on Web:** Check browser permissions.
- **Firebase Authentication Error:** Ensure correct API keys and app IDs are set.

---

## 📝 License
This project is licensed under the MIT License.

---

Happy Coding! 🚀
