import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'result_screen.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraScreen({super.key, required this.cameras});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

Future<void> _takePicture() async {
  try {
    await _initializeControllerFuture;

    final image = await _controller.takePicture();

    // Send image to Django backend for classification
    var response = await _classifyImage(image.path);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          imagePath: image.path,
          fruitName: response['label'] ?? 'Unknown',
          confidence: response['confidence'] ?? 0.0,
        ),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to take picture: $e')),
    );
  }
}

Future<Map<String, dynamic>> _classifyImage(String imagePath) async {
  try {
    var uri = Uri.parse('http://127.0.0.1:8000/api/predict/');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', imagePath));

    var response = await request.send();

    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      final data = json.decode(res.body);

      print('API Response: $data');

      return {
        'fruit': data['fruit'] ?? 'Unknown',
        'confidence': data['confidence'] ?? 0.0,
      };
    } else {
      throw Exception('Failed to classify image: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
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
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: const Icon(Icons.camera),
        backgroundColor: const Color(0xFF50E3C2),
      ),
    );
  }
}
