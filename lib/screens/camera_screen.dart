import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'result_screen.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({super.key, required this.cameras});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  /// 🛠️ Initialize Camera
Future<void> _initializeCamera() async {
  try {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw Exception('No cameras found');
    }

    CameraController controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
    );

    await controller.initialize();

    setState(() {
      _controller = controller;
    });
  } catch (e) {
    debugPrint('Camera Initialization Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to initialize camera: $e')),
    );
  }
}


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 📸 Capture and Classify Image
  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      final image = await _controller.takePicture();

      var response = await _classifyImage(image.path);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            imagePath: image.path,
            fruitName: response['fruit'] ?? 'Unknown',
            confidence: response['confidence'] ?? 0.0,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to take picture: $e')),
      );
      debugPrint('Error taking picture: $e');
    }
  }

  /// 🔗 Classify Image with Backend API
  Future<Map<String, dynamic>> _classifyImage(String imagePath) async {
    try {
      var uri = Uri.parse('http://127.0.0.1:8000/api/predict/');
      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('file', imagePath));

      var response = await request.send();

      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        final data = json.decode(res.body);

        return {
          'fruit': data['fruit'] ?? 'Unknown',
          'confidence': data['confidence'] ?? 0.0,
        };
      } else {
        throw Exception('Failed to classify image: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during classification: $e')),
      );
      return {'fruit': 'Error', 'confidence': 0.0};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
        backgroundColor: const Color(0xFF50E3C2),
      ),
      body: _isCameraInitialized
          ? FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          : const Center(
              child: Text(
                'Initializing Camera...',
                style: TextStyle(fontSize: 18),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: const Icon(Icons.camera),
        backgroundColor: const Color(0xFF50E3C2),
      ),
    );
  }
}
