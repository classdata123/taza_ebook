import 'package:ebookapp/screen/Home/bottom.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'edit_profile.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    if (user == null) {
      return Scaffold(body: Center(child: Text("No user logged in")));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Account')),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: _db.collection('users').doc(user.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text("No user data found"));
            }

            final userData = snapshot.data?.data() as Map<String, dynamic>? ?? {};
            String name = userData['name'] ?? "No Name";
            String email = userData['email'] ?? "No Email";
            String phone = userData['phone'] ?? "No Phone";
            String imageUrl = userData['image'] ?? "";

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.black12,
                    backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                    child: imageUrl.isEmpty ? Icon(Icons.person, size: 50) : null,
                  ),
                  const SizedBox(height: 20),
                  _buildInfoTile('Name:', name),
                  _buildInfoTile('E-mail:', email),
                  _buildInfoTile('Phone:', phone),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => Get.to(() => EditProfileScreen()),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                        child: const Text('Edit Profile'),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: () async {
                          await _auth.signOut();
                          Get.offAllNamed('/login'); // consistent with Get routing
                        },
                        child: const Text('Log out'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
            bottomNavigationBar: bottom(),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
