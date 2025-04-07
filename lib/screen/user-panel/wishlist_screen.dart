import 'package:ebookapp/screen/Home/bottom.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ebookapp/controller/cart_controller.dart';
import 'dart:convert';
import 'dart:typed_data';

class WishlistScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    String uid = _auth.currentUser?.uid ?? "";

    return Scaffold(
      appBar: AppBar(title: const Text("My Wishlist")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('users').doc(uid).collection('wishlist').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Your wishlist is empty."));
          }

          final wishlist = snapshot.data!.docs;

          return ListView.builder(
            itemCount: wishlist.length,
            itemBuilder: (context, index) {
              final item = wishlist[index].data() as Map<String, dynamic>;
              final docId = wishlist[index].id;

              print("✅ Image URL: ${item['image']}"); // Debugging image URL

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBookImage(item['image'] ?? ''),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] ?? 'Unknown Title',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "by ${item['author'] ?? 'Unknown'}",
                              style: const TextStyle(color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "\$${item['price'] ?? '0.00'}",
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_cart),
                            onPressed: () {
                              cartController.addToCart({
                                'title': item['title'],
                                'author': item['author'],
                                'price': double.tryParse(item['price'].toString()) ?? 0.0,
                                'image': item['image'],
                              });

                              Get.snackbar("Success", "Added to cart",
                                  backgroundColor: Colors.green, colorText: Colors.white);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _db.collection('users').doc(uid).collection('wishlist').doc(docId).delete();

                              Get.snackbar("Removed", "Book removed from wishlist",
                                  backgroundColor: Colors.red, colorText: Colors.white);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  /// 🖼 **Updated Image Widget**
  Widget _buildBookImage(String? image) {
    if (image == null || image.isEmpty) {
      return const Icon(Icons.book, size: 50);
    }

    if (image.startsWith("http")) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          image,
          width: 60,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print("❌ Image load failed: $image");
            return const Icon(Icons.broken_image, size: 50, color: Colors.redAccent);
          },
        ),
      );
    }

    try {
      Uint8List bytes = base64Decode(image);
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(bytes, width: 60, height: 80, fit: BoxFit.cover),
      );
    } catch (e) {
      print("❌ Image decoding error: $e");
      return const Icon(Icons.broken_image, size: 50, color: Colors.redAccent);
    }
  }
}
