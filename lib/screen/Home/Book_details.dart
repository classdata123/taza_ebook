import 'package:flutter/material.dart';

class BookDetailScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl, height: 150, fit: BoxFit.cover)
                  : const Icon(Icons.book, size: 80),
            ),
            const SizedBox(height: 10),
            Text("Author: $author", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("Category: $category", style: const TextStyle(fontSize: 14, color: Colors.grey)),
            Text("Rating: ⭐ $rating", style: const TextStyle(fontSize: 14)),
            Text("Price: \$ $price", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                print("$title added to cart");
              },
              child: const Text("Add to Cart"),
            ),
            const SizedBox(height: 10),
            Text("Description:", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(description),
          ],
        ),
      ),
    );
  }
}
