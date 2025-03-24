import 'package:ebookapp/firebase_options.dart';
import 'package:ebookapp/screen/admin-panel/admindashboard.dart';
import 'package:ebookapp/screen/admin-panel/productdisplay.dart';
import 'package:ebookapp/screen/admin-panel/userdetail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:ebookapp/screen/admin-panel/category.dart';
import 'package:ebookapp/screen/admin-panel/drawer.dart';
import 'package:ebookapp/utility/app_content.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(home: Admin()));
}

class Admin extends StatelessWidget {
  const Admin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppConstant.appMainColor),
      drawer: Draw(), // Ensure class Draw exists in drawer.dart
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Admin Panel"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryPage()),
                );
              },
              child: Text("Go to Category Page"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookDisplayPage()),
                );
              },
              child: Text("Go to Category show"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminUsersDashboard(),
                  ),
                );
              },
              child: Text("Go users"),
            ),

             ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminDashboard()),
                );
              },
              child: Text("Go to admin dash show"),
            ),

          ],
        ),
      ),
    );
  }
}
