import 'package:ebookapp/utility/app_content.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPage createState() => _CategoryPage();
}

class _CategoryPage extends State<CategoryPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  String? base64Image;
  TextEditingController bookname = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController authorr = TextEditingController();
  TextEditingController category = TextEditingController();

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      Uint8List imageBytes = await image.readAsBytes();
      setState(() {
        base64Image = base64Encode(imageBytes);
      });
    }
  }

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
      'name': bookname.text,
      'price': price.text,
      'description': description.text,
      'author': category.text,
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
      backgroundColor: Colors.white,  // Background color set to white
      appBar: AppBar(
        title: Text("Add Book", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,  // App bar color set to black
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField(bookname, "Book Name"),
            _buildTextField(price, "Price"),
            _buildTextField(description, "Description"),
            _buildTextField(authorr, "Author"),
            _buildTextField(category, "Category"),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () => pickImage(ImageSource.gallery),
              child: Text("Pick Image", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () async {
                try {
                  DocumentReference docRef = await db.collection('books').add({
                    'Bookname': bookname.text,
                    'price': price.text,
                    'description': description.text,
                    'author': category.text,
                    'category': category.text,
                    'image': base64Image,
                  });
                  Get.snackbar(
                    "Success",
                    "Book Added Successfully",
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } catch (e) {
                  Get.snackbar(
                    "Error",
                    "Failed to add book: $e",
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: Text("Add Book", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: db.collection('books').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    children:
                        snapshot.data!.docs.map((doc) {
                          return Card(  // Card added to wrap ListTile
                            color: Colors.black,  // Card color set to black
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                doc['Bookname'],
                                style: TextStyle(color: Colors.white),  // Text color set to white
                              ),
                              subtitle: Text(
                                "${doc['price']} - ${doc['description']} - ${doc['category']} - ${doc['author']}",
                                style: TextStyle(color: Colors.white70),  // Subtitle color set to light white
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      bookname.text = doc['Bookname'];
                                      price.text = doc['price'];
                                      description.text = doc['description'];
                                      authorr.text = doc['author'];
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
                            ),
                          );
                        }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),  // Text color set to white
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black,  // Background color of input field set to black
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
