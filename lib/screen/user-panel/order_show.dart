import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ebookapp/screen/Home/bottom.dart'; // Assuming BottomNavBar is in this file

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  Stream<QuerySnapshot> fetchOrders() {
    return FirebaseFirestore.instance.collection('orders').snapshots();
  }

  Future<void> updateStatus(String docId, String newStatus) async {
    await FirebaseFirestore.instance.collection('orders').doc(docId).update({
      'status': newStatus,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Orders"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);  // Back to previous screen
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error loading orders",
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Orders Found",
                style: TextStyle(color: Colors.black),
              ),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>;

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "📦 Order ID: ${data['orderId'] ?? 'N/A'}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text("🔗 Tracking ID: ${data['trackingId']}"),
                      Text("📞 Phone: ${data['phone']}"),
                      Text("🏠 Address: ${data['address']}"),
                      const SizedBox(height: 6),
                      const Text(
                        "🛒 Items:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...List<Widget>.from(
                        (data['products'] as List).map((item) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(item['title'] ?? '')),
                              Text("x${item['quantity']}"),
                              Text("\$${item['price'].toStringAsFixed(2)}"),
                            ],
                          );
                        }),
                      ),
                      const Divider(height: 20),
                      Text("💰 Total: \$${data['totalPrice']}"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("📍 Status:"),
                          DropdownButton<String>(
                            value: data['status'],
                            items: [
                              'pending',
                              'processing',
                              'shipped',
                              'delivered',
                            ]
                                .map(
                                  (status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                updateStatus(order.id, value);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(), // Your bottom navigation bar
    );
  }
}
