import 'package:ebookapp/screen/Home/bottom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  List<String> allBooks = [
    "Flutter for Beginners",
    "Dart Essentials",
    "Advanced Flutter",
    "Clean Code",
    "The Pragmatic Programmer",
    "Design Patterns",
    "Refactoring"
  ];
  List<String> filteredBooks = [];

  @override
  void initState() {
    super.initState();
    filteredBooks = allBooks;
  }

  void filterSearch(String query) {
    setState(() {
      filteredBooks = allBooks
          .where((book) => book.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Store"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: searchController,
              onChanged: filterSearch,
              decoration: InputDecoration(
                hintText: "Search Books...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            
            // Book List
            Expanded(
              child: ListView.builder(
                itemCount: filteredBooks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredBooks[index]),
                    leading: const Icon(Icons.book),
                    onTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
           bottomNavigationBar: bottom(),
    );
  }
}
