import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserBookRequestForm extends StatefulWidget {
  @override
  _UserBookRequestFormState createState() => _UserBookRequestFormState();
}

class _UserBookRequestFormState extends State<UserBookRequestForm> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  String? selectedUser;
  String? selectedBook;
  String? userEmail;
  String? userId;
  String? bookPrice;

  Future<void> submitRequest() async {
    if (selectedUser == null || selectedBook == null) {
      Get.snackbar("Error", "Please select both user and book");
      return;
    }
    await db.collection('requests').add({
      'userId': userId,
      'username': selectedUser,
      'userEmail': userEmail,
      'bookId': selectedBook,
      'bookName': selectedBook,
      'price': bookPrice,
      'status': 'pending',
    });
    Get.snackbar("Success", "Request submitted successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Purchase Request")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select User"),
            StreamBuilder(
              stream: db.collection('users').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return DropdownButton<String>(
                  value: selectedUser,
                  onChanged: (newValue) {
                    setState(() {
                      selectedUser = newValue;
                      userId =
                          snapshot.data!.docs
                              .firstWhere((doc) => doc['name'] == newValue)
                              .id;
                      userEmail =
                          snapshot.data!.docs.firstWhere(
                            (doc) => doc['name'] == newValue,
                          )['email'];
                    });
                  },
                  items:
                      snapshot.data!.docs.map((doc) {
                        return DropdownMenuItem<String>(
                          value: doc['name'],
                          child: Text(doc['name']),
                        );
                      }).toList(),
                );
              },
            ),

            SizedBox(height: 16),
            Text("Select Book"),
            StreamBuilder(
              stream: db.collection('books').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return DropdownButton<String>(
                  value: selectedBook,
                  onChanged: (newValue) {
                    setState(() {
                      selectedBook = newValue;
                      bookPrice =
                          snapshot.data!.docs.firstWhere(
                            (doc) => doc['Bookname'] == newValue,
                          )['price'];
                    });
                  },
                  items:
                      snapshot.data!.docs.map((doc) {
                        return DropdownMenuItem<String>(
                          value: doc['Bookname'],
                          child: Text(doc['Bookname']),
                        );
                      }).toList(),
                );
              },
            ),

            SizedBox(height: 24),
            ElevatedButton(
              onPressed: submitRequest,
              child: Text("Submit Request"),
            ),
          ],
        ),
      ),
    );
  }
}
