import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/screens/home.page.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/register.page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tflite/tflite.dart';

/// Point d'entrée principal de l'application Flutter.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialisation de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Chargement du modèle TFLite
  await loadTFLiteModel();

  runApp(const MyApp());
}

/// 📦 Charger le modèle TFLite
Future<void> loadTFLiteModel() async {
  try {
    String? result = await Tflite.loadModel(
      model: "assets/CNN_fruits.tflite", // Chemin du modèle TFLite
    );
    print("✅ Modèle TFLite chargé avec succès : $result");
  } catch (e) {
    print("❌ Erreur lors du chargement du modèle TFLite : $e");
  }
}

/// 🏠 Widget principal de l'application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 25, 111, 224),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Mehdi\'s App',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}
