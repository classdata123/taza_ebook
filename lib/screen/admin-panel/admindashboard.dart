import 'package:ebookapp/component/base_scaffold.dart';
import 'package:ebookapp/screen/admin-panel/userdetail.dart';
import 'package:ebookapp/utility/app_content.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_navigation/get_navigation.dart';

class AdminDashboard extends StatelessWidget {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<int> getTotalCount(String collection) async {
    QuerySnapshot snapshot = await db.collection(collection).get();
    return snapshot.size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appMainbg,
      appBar: AppBar(
        title: Text("Admin Dashboard", style: TextStyle(color: Colors.white)),
        backgroundColor: AppConstant.appMainColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Draw(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildDashboardCard("Total Users", "users", Icons.people, context),
            _buildDashboardCard("Book Catalog", "books", Icons.book, context),
            _buildDashboardCard(
              "Total Sales",
              "sales",
              Icons.shopping_cart,
              context,
            ),
            _buildDashboardCard(
              "Total Authors",
              "authors",
              Icons.person,
              context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    String title,
    String collection,
    IconData icon,
    BuildContext context,
  ) {
    return FutureBuilder<int>(
      future: getTotalCount(collection),
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () {
            if (title == "Total Users") {
              // Navigate to the Admin Users Dashboard
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminUsersDashboard()),
              );
            }
          },
          child: Card(
            color: AppConstant.appMainColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 40),
                  SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    snapshot.connectionState == ConnectionState.waiting
                        ? "Loading..."
                        : snapshot.data.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
