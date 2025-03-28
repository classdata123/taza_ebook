import 'dart:convert';
import 'package:ebookapp/User/profile_screen.dart';
import 'package:ebookapp/screen/Home/home.dart';
import 'package:ebookapp/screen/Home/search_filter.dart';
import 'package:flutter/material.dart';


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
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  int _selectedIndex = 0; // Current index of Bottom Navigation

  // Function to handle navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to respective screen
    if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreenContent()));
    } 
    // else if (index == 1) {
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => CartScreen()));
    // } 
    else if (index == 2) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => UserProfileScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Classics', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {},
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: widget.imageUrl.isNotEmpty
                      ? Image.memory(
                          base64Decode(widget.imageUrl),
                          width: 100,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.broken_image,
                          size: 100, color: Colors.redAccent),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("Author: ${widget.author}",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      Text("Category: ${widget.category}",
                          style: const TextStyle(fontSize: 14, color: Colors.grey)),
                      Text("Rating: ⭐ ${widget.rating}/5",
                          style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 8),
                      Text("Pricing: ", style: const TextStyle(fontSize: 16)),
                      Text("\$ ${widget.price}",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {}, // Add to Cart Functionality baad me add karni hai
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text("Add to Cart", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Description:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(widget.description, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
