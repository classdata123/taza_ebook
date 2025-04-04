import 'package:ebookapp/screen/user-panel/order_show.dart';
import 'package:ebookapp/screen/user-panel/profile_screen.dart';
import 'package:ebookapp/screen/user-panel/trackorder.dart';
import 'package:ebookapp/screen/user-panel/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'book_details.dart';
import 'bottom.dart';

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  int _selectedIndex = 0; // Track active tab

  final List<Widget> _screens = [
    HomeTab(),
    WishlistScreen(),
    TrackOrderScreen(),
    UserProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigation using Get.to
    Get.to(_screens[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Store"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Get.toNamed('/cart'); // Make sure this route exists
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped, // Handle tab switch
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home', // Label added
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist', // Label added
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Orders', // Label added
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile', // Label added
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  Future<List<String>> fetchCategories() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('category').get();
      return snapshot.docs.map((doc) => doc['name'].toString()).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Categories",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<String>>(
            future: fetchCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || snapshot.data == null) {
                return const Center(child: Text("Error loading categories"));
              }

              List<String> categories = snapshot.data!;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      categories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Chip(label: Text(category)),
                        );
                      }).toList(),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text(
            "New Arrivals",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildBookGrid(),
        ],
      ),
    );
  }

  Widget _buildBookGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('books').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var books = snapshot.data!.docs;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            var book = books[index];
            return _buildBookItem(book, context);
          },
        );
      },
    );
  }

  Widget _buildBookItem(QueryDocumentSnapshot book, BuildContext context) {
    String title = book['Bookname'] ?? 'No Title';
    String author = book['author'] ?? 'Unknown';
    String category = book['category'] ?? 'N/A';
    double rating = double.tryParse(book['rating'].toString()) ?? 0.0;
    String price = book['price'] ?? '0';
    String image = book['image'] ?? '';
    String description = book['description'] ?? 'No description available.';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => BookDetailScreen(
                  title: title,
                  author: author,
                  category: category,
                  rating: rating,
                  price: price,
                  imageUrl: image,
                  description: description,
                ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBookImage(image),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              "\$ $price",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookImage(String image) {
    if (image.isEmpty) {
      return const Icon(Icons.book, size: 50);
    } else if (image.startsWith("http")) {
      return Image.network(
        image,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.broken_image,
            size: 50,
            color: Colors.redAccent,
          );
        },
      );
    } else {
      try {
        Uint8List bytes = base64Decode(image);
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.memory(bytes, height: 80, fit: BoxFit.cover),
        );
      } catch (e) {
        return const Icon(
          Icons.broken_image,
          size: 50,
          color: Colors.redAccent,
        );
      }
    }
  }
}
