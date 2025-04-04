import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  Stream<List<Map<String, dynamic>>> fetchOrders() {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("❌ User not logged in.");
      return Stream.value([]);
    }

    print("📡 Fetching orders for user: ${user.uid}");

    return FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          print("📦 Orders Fetched: ${snapshot.docs.length}");
          return snapshot.docs.map((doc) {
            print("✅ Order Data: ${doc.data()}");
            return doc.data();
          }).toList();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          if (snapshot.hasError) {
            print("❌ Error fetching orders: ${snapshot.error}");
            return Center(
              child: Text(
                "Error loading orders",
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            print("⚠ No Orders Found");
            return const Center(
              child: Text(
                "No Orders Found",
                style: TextStyle(color: Colors.black),
              ),
            );
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    "Order #${index + 1}",
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    "Total: \$${order['totalPrice']}",
                    style: const TextStyle(color: Colors.black),
                  ),
                  trailing: Text(
                    order['status'],
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
