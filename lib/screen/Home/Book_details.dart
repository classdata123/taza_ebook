import 'dart:convert';
import 'dart:typed_data';
import 'package:ebookapp/screen/user-panel/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebookapp/screen/home/home.dart';
import 'package:get/get.dart';
import 'package:ebookapp/controller/cart_controller.dart'; // ✅ sahi path



class BookDetailScreen extends StatefulWidget {
  final String title;
  final String author;
  final String category;
  final double rating;
  final String price;
  final String imageUrl;
  final String description;

  const BookDetailScreen({
    super.key,
    required this.title,
    required this.author,
    required this.category,
    required this.rating,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final CartController cartController = Get.find<CartController>(); // ✅ No duplicate

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Get.offAll(() => const HomeScreenContent());
    } else if (index == 2) {
      Get.offAll(() => UserProfileScreen());
    }
  }

  Widget _buildBookImage(String image) {
    if (image.isEmpty) {
      return const Icon(Icons.book, size: 100);
    } else if (image.startsWith("http")) {
      return Image.network(
        image,
        width: 100,
        height: 150,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 100, color: Colors.redAccent),
      );
    } else {
      try {
        Uint8List bytes = base64Decode(image);
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            bytes,
            width: 100,
            height: 150,
            fit: BoxFit.cover,
          ),
        );
      } catch (e) {
        return const Icon(Icons.broken_image, size: 100, color: Colors.redAccent);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              Get.toNamed('/cart');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBookImage(widget.imageUrl),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text("Author: ${widget.author}",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      Text("Category: ${widget.category}",
                          style: const TextStyle(fontSize: 14, color: Colors.grey)),
                      Text("Rating: ⭐ ${widget.rating}/5",
                          style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 10),
                      Text("Price:",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      Text("\$ ${widget.price}",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  cartController.addToCart({
                    'title': widget.title,
                    'author': widget.author,
                    'price': double.tryParse(widget.price) ?? 0.0,
                    'image': widget.imageUrl,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Book added to cart")),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                label: const Text("Add to Cart", style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Description:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.description, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}
