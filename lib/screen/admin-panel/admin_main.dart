import 'package:ebookapp/screen/admin-panel/drawer.dart';
import 'package:ebookapp/utility/app_content.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Admin()));
}

class Admin extends StatelessWidget {
  const Admin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppConstant.appMainColor),

      drawer: Draw(), // Ensure this matches the class name in drawer.dart
      body: Center(
        child: Text("Admin Panel"),
      ), // Added a body for better display
    );
  }
}
