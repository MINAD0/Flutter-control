import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF50E3C2),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 26, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : const AssetImage('images/avatar.jpg') as ImageProvider,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 20),

            /// User Display Name
            Text(
              user?.displayName ?? 'No Name',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 10),

            /// User Email
            Text(
              user?.email ?? 'No Email',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),

            /// Additional User Info
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.blueGrey),
              title: const Text(
                'Additional User Information',
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text(
                'User ID: ${FirebaseAuth.instance.currentUser?.uid ?? 'No ID'}',
              ),
            ),

            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF50E3C2),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              onPressed: () {
                Navigator.pop(context); // Go back to Home
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: const Text(
                'Back to Home',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
