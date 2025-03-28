import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Dummy cart data — replace with Firebase or local state
  List<Map<String, dynamic>> cartItems = [
    {
      'title': 'Flutter for Beginners',
      'price': 15.99,
      'quantity': 1,
    },
    {
      'title': 'Clean Code',
      'price': 20.50,
      'quantity': 2,
    },
  ];

  // Calculate total price
  double getTotalPrice() {
    return cartItems.fold(
      0.0,
      (total, item) => total + (item['price'] * item['quantity']),
    );
  }

  void updateQuantity(int index, int delta) {
    setState(() {
      cartItems[index]['quantity'] += delta;
      if (cartItems[index]['quantity'] <= 0) {
        cartItems.removeAt(index);
      }
    });
  }

  void proceedToCheckout() {
    Get.snackbar(
      "Success",
      "Proceeding to checkout...",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    // You can redirect to a checkout screen or place order
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("Your cart is empty."))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.book),
                    title: Text(item['title']),
                    subtitle: Text("\$${item['price'].toStringAsFixed(2)}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => updateQuantity(index, -1),
                        ),
                        Text('${item['quantity']}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => updateQuantity(index, 1),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total:",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text("\$${getTotalPrice().toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: proceedToCheckout,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                      child: const Text("Proceed to Checkout"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
