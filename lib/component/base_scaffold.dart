import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookapp/component/global_app_bar.dart';
import 'package:ebookapp/screen/Home/home.dart';
import 'package:ebookapp/screen/admin-panel/Product.dart';
import 'package:ebookapp/screen/admin-panel/category.dart';
import 'package:ebookapp/screen/admin-panel/productdisplay.dart';
import 'package:ebookapp/screen/admin-panel/show_order.dart';
import 'package:ebookapp/screen/admin-panel/userdetail.dart';
import 'package:ebookapp/screen/auth-ui/login.dart';
import 'package:ebookapp/utility/app_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class BaseScaffold extends StatefulWidget {
  final Widget body;
  final String? title;

  const BaseScaffold({Key? key, required this.body, this.title})
    : super(key: key);

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

TextEditingController adminName = TextEditingController();
TextEditingController adminemail = TextEditingController();

class _BaseScaffoldState extends State<BaseScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: GlobalAppBar(scaffoldKey: _scaffoldKey, title: widget.title),
      drawer: Draw(),
      body: widget.body,
    );
  }
}

class Draw extends StatefulWidget {
  const Draw({super.key});

  @override
  State<Draw> createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  User? user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  Map<String, dynamic>? userdata;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      QuerySnapshot querySnapshot =
          await db.collection('users').where('uid', isEqualTo: user!.uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          userdata = querySnapshot.docs.first.data() as Map<String, dynamic>;
          isLoading = false; // Set loading to false once data is fetched
        });
      } else {
        // Handle case where user data is not found
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
      ),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(),
            child: Container(
              color: Color.fromARGB(255, 30, 29, 30), // black background
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  userdata!['name'],
                  style: TextStyle(color: Colors.white), // white text
                ),
                subtitle: Text(
                  userdata!['email'],
                  style: TextStyle(
                    color: Colors.white70,
                  ), // slightly lighter white
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.white, // white avatar background
                  child: Text(
                    'A',
                    style: TextStyle(color: Colors.black), // black letter
                  ),
                ),
              ),
            ),
          ),

          Divider(
            indent: 10.0,
            endIndent: 10.0,
            thickness: 3.5,
            color: const Color.fromARGB(31, 2, 2, 2),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text('Home'),
              leading: Icon(Icons.home),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Add navigation logic here
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            HomeScreenContent(), // Replace with your actual Product screen widget
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text('Product'),
              leading: Icon(Icons.shopping_bag),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Add navigation logic here

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            CategoryPage(), // Replace with your actual Product screen widget
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text('Category'),
              leading: Icon(Icons.shop),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            AdminUsersDashboard(), // Replace with your actual Product screen widget
                  ),
                );
                // Add navigation logic here
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text('Show product'),
              leading: Icon(Icons.shopping_bag),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            BookDisplayPage(), // Replace with your actual Product screen widget
                  ),
                );
                // Add navigation logic here
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text('Show order'),
              leading: Icon(Icons.receipt_long),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            OrdersScreen(), // Replace with your actual Product screen widget
                  ),
                );
                // Add navigation logic here
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text('Request'),
              leading: Icon(Icons.request_page),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Add navigation logic here
                Navigator.pop(context);
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListTile(
              textColor: AppConstant.textcolor,
              onTap: () {
                Get.to(LoginScreen());
              },
              title: Text('Logout'),
              leading: Icon(Icons.receipt_long, color: AppConstant.textcolor),
              trailing: Icon(Icons.account_balance),
            ),
          ),
        ],
      ),
    );
  }
}
