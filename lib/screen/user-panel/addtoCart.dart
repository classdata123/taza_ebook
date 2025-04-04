import 'package:ebookapp/controller/cart_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final CartController cartController = Get.find();

  // 🔢 Tracking ID generator
  String generateTrackingId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(
      10,
      (index) => chars[rand.nextInt(chars.length)],
    ).join();
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
          return const Center(
            child: Text(
              "Your cart is empty.",
              style: TextStyle(color: Colors.black),
            ),
          );
        }
        return ListView.builder(
          itemCount: cartController.cartItems.length,
          itemBuilder: (context, index) {
            final item = cartController.cartItems[index];
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: ListTile(
                leading: const Icon(Icons.book, color: Colors.black),
                title: Text(
                  item['title'],
                  style: const TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  "\$${item['price'].toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.black),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.black),
                      onPressed: () => cartController.updateQuantity(index, -1),
                    ),
                    Text(
                      '${item['quantity']}',
                      style: const TextStyle(color: Colors.black),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.black),
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
        if (cartController.cartItems.isEmpty) {
          return const SizedBox.shrink();
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "\$${cartController.totalPrice.value.toStringAsFixed(2)}",
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final TextEditingController addressController =
                            TextEditingController();
                        final TextEditingController phoneController =
                            TextEditingController();
                        String orderId =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        String trackingId = generateTrackingId();

                        return AlertDialog(
                          title: const Text("Enter your details"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: addressController,
                                decoration: const InputDecoration(
                                  labelText: "Address",
                                ),
                              ),
                              TextField(
                                controller: phoneController,
                                decoration: const InputDecoration(
                                  labelText: "Phone Number",
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (addressController.text.isEmpty ||
                                    phoneController.text.isEmpty) {
                                  Get.snackbar(
                                    "Error",
                                    "Please fill all fields",
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }

                                await cartController.placeOrder(
                                  address: addressController.text,
                                  phone: phoneController.text,
                                  orderId: orderId,
                                  trackingId: trackingId,
                                );

                                Get.back(); // Close dialog
                                Get.snackbar(
                                  "Success",
                                  "Order placed! Tracking ID: $trackingId",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              },
                              child: const Text("Submit"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text("Proceed to Checkout"),
                ),
              ),
            ],
<<<<<<< HEAD
          );
        },
      ),
          bottomNavigationBar: BottomNavBar(),
=======
          ),
        );
      }),
>>>>>>> 0026ab193e6e635821ed101317943f3adab8bdb5
    );
  }
}
