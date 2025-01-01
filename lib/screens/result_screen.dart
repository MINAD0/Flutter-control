import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ResultScreen extends StatelessWidget {
  final String imagePath;
  final String fruitName;
  final double confidence;

  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.fruitName,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fruit Detection Result'),
        backgroundColor: const Color(0xFF50E3C2),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🖼️ Image Preview
              kIsWeb
                  ? Image.network(
                      imagePath,
                      height: 300,
                      width: 300,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(imagePath),
                      height: 300,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(height: 20),

              // 🍎 Detected Fruit
              Text(
                'Detected Fruit: $fruitName',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // 📊 Confidence Score
              Text(
                'Confidence: ${(confidence * 100).toStringAsFixed(2)}%',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // 🔙 Back to Home Button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF50E3C2),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
