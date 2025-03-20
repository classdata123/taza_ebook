import 'package:ebookapp/screen/admin-panel/category.dart';
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
      drawer: Draw(),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Aligns content in center
          children: [
            Text("Admin Panel"),
            SizedBox(height: 20), // Adds spacing
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryPage()),
                );
              },
              child: Text("Go to Category Page"),
            ),
          ],
        ),
      ),
    );
  }
}
