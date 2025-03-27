



import 'package:ebookapp/utility/app_content.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: AdminRequestPage()));
}

class AdminRequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appMainbg,
      appBar: AppBar(
        title: Text("Admin Requests", style: TextStyle(color: Colors.white)),
        backgroundColor: AppConstant.appMainColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildCard("User Requests", Icons.person, Colors.blue),
            _buildCard("Payments", Icons.payment, Colors.green),
            _buildCard("Order Status", Icons.shopping_cart, Colors.orange),
            _buildCard("Book Suggestions", Icons.book, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, Color color) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to respective pages
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            SizedBox(height: 10),
            Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
