import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookapp/component/global_app_bar.dart';
import 'package:ebookapp/screen/Home/home.dart';
import 'package:ebookapp/screen/admin-panel/Product.dart';
import 'package:ebookapp/screen/admin-panel/category.dart';
import 'package:ebookapp/screen/admin-panel/userdetail.dart';
import 'package:ebookapp/utility/app_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
          await db.collection('users').where('uId', isEqualTo: user!.uid).get();

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
            padding: const EdgeInsets.only(top: 20),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text(userdata!['name']),
              subtitle: Text(userdata!['email']),
              leading: CircleAvatar(
                backgroundColor: AppConstant.appMainbg,
                child: Text('A'),
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
                            HomeScreen(), // Replace with your actual Product screen widget
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
              leading: Icon(Icons.production_quantity_limits),
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
              title: Text('Users'),
              leading: Icon(Icons.verified_user),
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
              title: Text('Request'),
              leading: Icon(Icons.request_page),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Add navigation logic here
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
