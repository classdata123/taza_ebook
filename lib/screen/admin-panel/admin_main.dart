import 'package:ebookapp/component/base_scaffold.dart';
import 'package:ebookapp/firebase_options.dart';
import 'package:ebookapp/screen/admin-panel/admindashboard.dart';
import 'package:ebookapp/screen/admin-panel/productdisplay.dart';
import 'package:ebookapp/screen/admin-panel/userdetail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ebookapp/screen/admin-panel/category.dart';
import 'package:ebookapp/utility/app_content.dart';
import 'package:ebookapp/screen/admin-panel/Product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(home: Admin()));
}

class Admin extends StatefulWidget {
  // Changed to StatefulWidget
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Add scaffold key

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "",
      key: _scaffoldKey, // Add the key to Scaffold      
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

