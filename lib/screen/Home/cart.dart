import 'package:ebookapp/controller/cart_controller.dart';
import 'package:ebookapp/screen/user-panel/order_show.dart'; // 👈 Import your order screen
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final CartController cartController = Get.find();

  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void showCheckoutForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enter Delivery Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Phone Number"),
            ),
            TextField(
              controller: addressController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: "Address"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final phone = phoneController.text.trim();
              final address = addressController.text.trim();

              if (phone.isEmpty || address.isEmpty) {
                Get.snackbar(
                  "Missing Info",
                  "Please fill in all fields",
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }

              final orderId = DateTime.now().millisecondsSinceEpoch.toString();
              final trackingId = const Uuid().v4();

              await cartController.placeOrder(
                address: address,
                phone: phone,
                orderId: orderId,
                trackingId: trackingId,
              );

              Get.back(); // Close the dialog

              Get.snackbar(
                "Success",
                "Order placed successfully!",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );

              // 🔁 Redirect to Order Screen
              Future.delayed(const Duration(milliseconds: 500), () {
                Get.off(() => const OrdersScreen()); // Replaces current screen
              });
            },
            child: const Text("Place Order"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const Center(child: Text("Your cart is empty."));
        }
        return ListView.builder(
          itemCount: cartController.cartItems.length,
          itemBuilder: (context, index) {
            final item = cartController.cartItems[index];
            double price = 0.0;

            // Ensure price is a valid number
            if (item['price'] is String) {
              price = double.tryParse(item['price']) ?? 0.0;
            } else if (item['price'] is num) {
              price = item['price'].toDouble();
            }

            return Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: ListTile(
                leading: const Icon(Icons.book, color: Colors.black),
                title: Text(
                  item['title'] ?? "Unknown Title",
                  style: const TextStyle(color: Colors.black),
                ),
                subtitle: Text("\$${price.toStringAsFixed(2)}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => cartController.updateQuantity(index, -1),
                    ),
                    Text('${item['quantity']}'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => cartController.updateQuantity(index, 1),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Obx(() {
        if (cartController.cartItems.isEmpty) return const SizedBox.shrink();
        
        // Calculate total price based on valid numbers
        double totalPrice = 0.0;
        for (var item in cartController.cartItems) {
          double price = 0.0;
          if (item['price'] is String) {
            price = double.tryParse(item['price']) ?? 0.0;
          } else if (item['price'] is num) {
            price = item['price'].toDouble();
          }
          totalPrice += price * item['quantity'];
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$${totalPrice.toStringAsFixed(2)}", // Ensure total price is correct
                    style: const TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => showCheckoutForm(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text("Proceed to Checkout"),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
