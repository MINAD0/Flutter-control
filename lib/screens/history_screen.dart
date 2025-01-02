import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  const HistoryScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: const Color(0xFF50E3C2),
      ),
      body: history.isEmpty
          ? const Center(
              child: Text(
                'No history available.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];
                return ListTile(
                  leading: Image.network(
                    item['imagePath'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image, color: Colors.grey);
                    },
                  ),
                  title: Text('Fruit: ${item['fruitName']}'),
                  subtitle: Text(
                      'Confidence: ${(item['confidence'] * 100).toStringAsFixed(2)}%'),
                  trailing: Text(item['date'] ?? 'No Date'),
                );
              },
            ),
    );
  }
}
