import 'package:ebookapp/firebase_options.dart';
import 'package:ebookapp/screen/Home/bottom.dart';
import 'package:ebookapp/utility/app_content.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(home: UserRequestForm()));
}

class UserRequestForm extends StatefulWidget {
  @override
  _UserRequestFormState createState() => _UserRequestFormState();
}

class _UserRequestFormState extends State<UserRequestForm> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  String? selectedUser;
  String? selectedBook;
  String userEmail = '';
  String bookPrice = '';

  Future<void> submitRequest() async {
    if (selectedUser == null || selectedBook == null) {
      Get.snackbar(
        "Error",
        "Please select a user and a book",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    await db.collection('requests').add({
      'userId': selectedUser,
      'bookId': selectedBook,
      'userEmail': userEmail,
      'bookPrice': bookPrice,
      'status': 'pending',
    });

    Get.snackbar(
      "Success",
      "Request submitted successfully",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appMainbg,
      appBar: AppBar(
        title: Text("User Request Form", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            StreamBuilder(
              stream: db.collection('users').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return DropdownButtonFormField(
                  dropdownColor: Colors.grey[900],
                  style: TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Select User"),
                  value: selectedUser,
                  items:
                      snapshot.data!.docs.map((doc) {
                        return DropdownMenuItem(
                          value: doc.id,
                          child: Text(
                            doc['name'],
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedUser = value as String?;
                      userEmail =
                          snapshot.data!.docs.firstWhere(
                            (doc) => doc.id == value,
                          )['email'];
                    });
                  },
                );
              },
            ),
            SizedBox(height: 20),
            StreamBuilder(
              stream: db.collection('books').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return DropdownButtonFormField(
                  dropdownColor: Colors.grey[900],
                  style: TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Select Book"),
                  value: selectedBook,
                  items:
                      snapshot.data!.docs.map((doc) {
                        return DropdownMenuItem(
                          value: doc.id,
                          child: Text(
                            doc['Bookname'],
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBook = value as String?;
                      bookPrice =
                          snapshot.data!.docs.firstWhere(
                            (doc) => doc.id == value,
                          )['price'];
                    });
                  },
                );
              },
            ),
            SizedBox(height: 20),
            TextField(
              enabled: false,
              style: TextStyle(color: Colors.white),
              decoration: _inputDecoration("User Email: $userEmail"),
            ),
            SizedBox(height: 20),
            TextField(
              enabled: false,
              style: TextStyle(color: Colors.white),
              decoration: _inputDecoration("Book Price: $bookPrice"),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: submitRequest,
              child: Text(
                "Submit Request",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
            bottomNavigationBar: bottom(),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[900],
      hintText: label,
      hintStyle: TextStyle(color: Colors.white54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}
