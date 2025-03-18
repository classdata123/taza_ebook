import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Happy Reading 📚"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement Search
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to Cart Screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Best Deals",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _buildBestDeals(),
                ),
              ),
              const SizedBox(height: 10),
              _buildBookSection("Top Books", _buildBookList()),
              _buildBookSection("Latest Books", _buildBookList()),
              _buildBookSection("Upcoming Books", _buildBookList()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }

  // Best Deals - Horizontal Cards
  List<Widget> _buildBestDeals() {
    return List.generate(5, (index) {
      return Card(
        child: SizedBox(
          width: 120,
          child: Column(
            children: [
              Image.network("https://via.placeholder.com/100", height: 80),
              const Text("Book Title", style: TextStyle(fontWeight: FontWeight.bold)),
              const Text("\$25.00", style: TextStyle(color: Colors.green)),
            ],
          ),
        ),
      );
    });
  }

  // Book List Section
  Widget _buildBookSection(String title, List<Widget> books) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Column(children: books),
        const SizedBox(height: 10),
      ],
    );
  }

  // Books - Vertical Cards
  List<Widget> _buildBookList() {
    return List.generate(3, (index) {
      return Card(
        child: ListTile(
          leading: Image.network("https://via.placeholder.com/50"),
          title: const Text("Book Name"),
          subtitle: const Text("\$20.00"),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              // Navigate to Book Details Screen
            },
          ),
        ),
      );
    });
  }
}
