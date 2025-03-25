import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  int _selectedIndex = 0; // Active tab index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Store"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("New Arrivals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildBookList(),

            const SizedBox(height: 20),
            const Text("Bestsellers", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildBookList(),

            const SizedBox(height: 20),
            const Text("Top Books", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildBookGrid(),
          ],
        ),
      ),

      // 🔥 Bottom Navigation Bar with Cart Tab
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"), // 🛒 Cart Tab
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // 🔥 Fetch and Display Books in ListView
  Widget _buildBookList() {
    return SizedBox(
      height: 180,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('books').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var books = snapshot.data!.docs;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              var book = books[index];
              String title = book['Bookname'] ?? book['name'] ?? 'No Title';
              String price = book['price'] ?? '0';
              String imageUrl = book['image'] ?? '';

              return Container(
                width: 120,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imageUrl.isNotEmpty
                        ? Image.network(imageUrl, height: 80, fit: BoxFit.cover)
                        : const Icon(Icons.book, size: 50),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Text("\$ $price", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // 🔥 Fetch and Display Books in GridView
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
            String title = book['Bookname'] ?? book['name'] ?? 'No Title';
            String price = book['price'] ?? '0';
            String imageUrl = book['image'] ?? '';

            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  imageUrl.isNotEmpty
                      ? Image.network(imageUrl, height: 80, fit: BoxFit.cover)
                      : const Icon(Icons.book, size: 50),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Text("\$ $price", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
