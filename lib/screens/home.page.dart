import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';

import 'camera_screen.dart';
import 'profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _selectedImage; // Pour stocker l'image sélectionnée
  String? _predictionResult; // Pour stocker le résultat de la prédiction

  /// 📷 Ouvrir la caméra
  Future<void> _openCamera(BuildContext context) async {
    try {
      final cameras = await availableCameras();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(cameras: cameras),
        ),
      );
    } catch (e) {
      print('Error initializing camera: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open camera: $e')),
      );
    }
  }

  /// 🖼️ Sélectionner une image depuis la galerie
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _predictionResult = null; // Réinitialiser le résultat précédent
      });
      _classifyImage(pickedFile.path);
    }
  }

  /// 🧠 Classifier l'image avec le modèle TFLite
  Future<void> _classifyImage(String imagePath) async {
    try {
      var recognitions = await Tflite.runModelOnImage(
        path: imagePath,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 6,
        threshold: 0.5,
      );

      setState(() {
        if (recognitions != null && recognitions.isNotEmpty) {
          _predictionResult =
              "${recognitions[0]['label']} (${(recognitions[0]['confidence'] * 100).toStringAsFixed(2)}%)";
        } else {
          _predictionResult = "Aucune prédiction trouvée.";
        }
      });
    } catch (e) {
      print("Erreur lors de la classification : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la classification : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF50E3C2),
        centerTitle: true,
        title: const Text(
          "Home Page",
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF50E3C2)),
              accountName: Text(
                user?.displayName ?? 'No Name',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                user?.email ?? 'No Email',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : const AssetImage("images/avatar.jpg") as ImageProvider,
                radius: 30,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('History'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(color: Color(0xFF50E3C2)),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
            const Divider(color: Color(0xFF50E3C2)),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Welcome to the fruits detector!!",
              style: TextStyle(fontSize: 30, color: Colors.blueGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.upload_file),
              label: const Text("Upload Image for Prediction"),
            ),
            const SizedBox(height: 20),
            if (_selectedImage != null) ...[
              Image.file(_selectedImage!, height: 200),
              const SizedBox(height: 10),
            ],
            if (_predictionResult != null) ...[
              Text(
                "Prediction: $_predictionResult",
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF50E3C2),
        onPressed: () => _openCamera(context),
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
