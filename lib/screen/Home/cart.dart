import 'package:ebookapp/controller/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Access CartController using GetX
  final CartController cartController = Get.find();

  // Calculate total price
double getTotalPrice() {
  return cartController.cartItems.fold(
    0.0,
    (total, item) {
      double price = item['price'] ?? 0.0; // Default to 0.0 if price is null
      int quantity = item['quantity'] ?? 0; // Default to 0 if quantity is null
      return total + (price * quantity);
    },
  );
}

  void updateQuantity(int index, int delta) {
    setState(() {
      cartController.cartItems[index]['quantity'] += delta;
      if (cartController.cartItems[index]['quantity'] <= 0) {
        cartController.cartItems.removeAt(index);
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
      appBar: AppBar(title: const Text("Your Cart")),
      body: Obx(
        () =>
            cartController.cartItems.isEmpty
                ? const Center(child: Text("Your cart is empty."))
                : ListView.builder(
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartController.cartItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
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
      ),
      bottomNavigationBar: Obx(
        () =>
            cartController.cartItems.isEmpty
                ? SizedBox.shrink() // or Container()
                : Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "\$${getTotalPrice().toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: proceedToCheckout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          child: const Text("Proceed to Checkout"),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
