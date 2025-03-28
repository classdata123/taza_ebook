import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreenContent(), // Dynamic Home Content
    const CategoriesScreen(),  // Dynamic Categories
    const UserProfileScreen(), // User Profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),
    );
  }
}

// 🔹 HomeScreenContent Fetches Books & Categories from Firebase
class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  Future<List<Map<String, dynamic>>> fetchBooks() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('books').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<List<String>> fetchCategories() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('categories').get();
    return snapshot.docs.map((doc) => doc['name'].toString()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Store"),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // 🔹 Fetch Categories Dynamically
            FutureBuilder<List<String>>(
              future: fetchCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading categories"));
                }
                List<String> categories = snapshot.data ?? [];
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
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
            const Text("New Arrivals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // 🔹 Fetch Books from Firestore
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchBooks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading books"));
                }
                List<Map<String, dynamic>> books = snapshot.data ?? [];
                return SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            books[index]['image'] != null
                                ? Image.network(
                                    books[index]['image'], // Firebase image URL
                                    width: 100,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.book, size: 100, color: Colors.black54),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                books[index]['Bookname'] ?? "No Title",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// 🔹 Categories Screen (Can be made dynamic later)
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: const Center(child: Text("Categories List")),
    );
  }
}

// 🔹 User Profile Screen Placeholder
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: const Center(child: Text("User Profile Details")),
    );
  }
}
