import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:typed_data';

class BookDisplayPage extends StatefulWidget {
  @override
  _BookDisplayPageState createState() => _BookDisplayPageState();
}

class _BookDisplayPageState extends State<BookDisplayPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController bookname = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController category = TextEditingController();
  String? base64Image;

  Future<void> deleteBook(String docId) async {
    await db.collection('books').doc(docId).delete();
    Get.snackbar(
      "Success",
      "Book Deleted Successfully",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  Future<void> updateBook(String docId) async {
    await db.collection('books').doc(docId).update({
      'Bookname': bookname.text,
      'price': price.text,
      'description': description.text,
      'category': category.text,
      'image': base64Image,
    });
    Get.snackbar(
      "Success",
      "Book Updated Successfully",
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book List", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
          stream: db.collection('books').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView(
              children:
                  snapshot.data!.docs.map((doc) {
                    Uint8List? imageBytes = base64Decode(doc['image']);
                    return Card(
                      color: Colors.grey[900],
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.memory(
                              imageBytes,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Name: ${doc['Bookname']}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Price: ${doc['price']}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "Category: ${doc['category']}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "Description: ${doc['description']}",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    bookname.text = doc['Bookname'];
                                    price.text = doc['price'];
                                    description.text = doc['description'];
                                    category.text = doc['category'];
                                    base64Image = doc['image'];
                                    updateBook(doc.id);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => deleteBook(doc.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            );
          },
        ),
      ),
    );
  }
}
