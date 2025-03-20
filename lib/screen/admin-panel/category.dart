import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookapp/screen/admin-panel/drawer.dart';
import 'package:ebookapp/utility/app_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final db = FirebaseFirestore.instance;
  String? updated;
  TextEditingController bookname = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppConstant.appMainColor),
      drawer: Draw(),
      body: Center(
        child: Column(
          children: [
            TextField(controller: bookname),
            ElevatedButton(
              onPressed: () async {
                if (bookname.text.isNotEmpty) {
                  if (updated == null) {
                    try {
                      await db.collection('category').add({
                        'bookname': bookname.text, // Fixed typo
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
                              title: Text(data['bookname']), // Fixed key
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
