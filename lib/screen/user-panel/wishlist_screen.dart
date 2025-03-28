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

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: _buildBookImage(item['image'] ?? ''), // Using updated function
                  title: Text(item['title'] ?? 'Unknown Title'),
                  subtitle: Text("by ${item['author'] ?? 'Unknown'}\n\$${item['price'] ?? '0.00'}"),
                  isThreeLine: true,
                  trailing: Column(
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
                          _db
                              .collection('users')
                              .doc(uid)
                              .collection('wishlist')
                              .doc(docId)
                              .delete();

                          Get.snackbar("Removed", "Book removed from wishlist",
                              backgroundColor: Colors.red, colorText: Colors.white);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Function to handle image loading
  Widget _buildBookImage(String image) {
    print("Loading Image: $image"); // Debugging Print

    if (image.isEmpty) {
      return const Icon(Icons.book, size: 50);
    } else if (image.startsWith("http")) {
      return Image.network(
        image,
        height: 80,
        width: 50,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print("Image failed to load: $image"); // Debugging Print
          return const Icon(Icons.broken_image, size: 50, color: Colors.redAccent);
        },
      );
    } else {
      try {
        Uint8List bytes = base64Decode(image);
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.memory(bytes, height: 80, width: 50, fit: BoxFit.cover),
        );
      } catch (e) {
        print("Base64 decoding error: $e"); // Debugging Print
        return const Icon(Icons.broken_image, size: 50, color: Colors.redAccent);
      }
    }
  }
}
