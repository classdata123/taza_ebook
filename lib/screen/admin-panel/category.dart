import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookapp/screen/admin-panel/drawer.dart';
import 'package:ebookapp/utility/app_content.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // Import GetX

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final db = FirebaseFirestore.instance;
  String? updated;
         String? base64Image;
  TextEditingController bookname = TextEditingController();
 Future<void> pickimage(ImageSource source) async {
     final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      // Handle web platform
      if (kIsWeb) {
        Uint8List webImage = await image.readAsBytes();
     

     
        String base64String = base64Encode(webImage);
        setState(() {
          base64Image = base64String; // Store the base64 string
        });

        // Show success message for web
        // Get.snackbar("Success", 'Image picked',
        //   backgroundColor: const Color.fromARGB(255, 8, 0, 8),
        //   colorText: Appconstant.textcolor,
        //   snackPosition: SnackPosition.BOTTOM
        // );

      } else {
        // Handle mobile platform
        File mobileImage = File(image.path);
        print("Mobile Image Picked: ${mobileImage.path}");

        // Convert the mobile image to base64
        final bytes = await mobileImage.readAsBytes();
        String base64String = base64Encode(bytes);

        setState(() {
          base64Image = base64String; // Store the base64 string
        });

        // Show success message for mobile
        // Get.snackbar("Success", 'Image picked',
        //   backgroundColor: const Color.fromARGB(255, 7, 0, 8),
        //   colorText: Appconstant.textcolor,
        //   snackPosition: SnackPosition.BOTTOM
        // );
      }
    } else {
      print("No image picked.");
    }}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppConstant.appMainColor),
      drawer: Draw(),
      body: Center(
        child: Column(
          children: [
            TextField(controller: bookname),
               Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () => pickimage(ImageSource.gallery),
                child: Text('Pick Image'),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (bookname.text.isNotEmpty) {
                  if (updated == null) {
                    try {
                      await db.collection('category').add({
                        'bokname': bookname.text, 
                        'img_pick':base64Image// Fixed typo
                      });
                      setState(() {});
                      Get.snackbar(
                        'Success',
                        'Inserted successfully!',
                        backgroundColor: AppConstant.appMainColor,
                        colorText: Colors.white,
                      );
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Insertion failed!',
                        backgroundColor: AppConstant.appMainColor,
                        colorText: const Color.fromARGB(255, 232, 99, 89),
                      );
                    }
                  }
                }
              },
              child: Text("Add Book"),
            ),
            Expanded(
              child: StreamBuilder(
                stream: db.collection('category').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    var document = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: document.length,
                      itemBuilder: (context, index) {
                        var data = document[index].data();
                        return Column(
                          children: [
                            ListTile(
                              textColor: AppConstant.snacktext,
                              tileColor: AppConstant.appMainColor,
                              title: Text(data['bokname']), // Fixed key
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      try {
                                        await db
                                            .collection('category')
                                            .doc(document[index].id)
                                            .delete();
                                        setState(() {});
                                        Get.snackbar(
                                          'Success',
                                          'Deleted successfully!',
                                          backgroundColor:
                                              AppConstant.appMainColor,
                                          colorText: Colors.white,
                                        );
                                      } catch (e) {
                                        Get.snackbar(
                                          'Error',
                                          'Error: $e', // Fixed string interpolation
                                          backgroundColor:
                                              AppConstant.appMainColor,
                                          colorText: Colors.white,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
