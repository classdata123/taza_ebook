import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;
  var totalPrice = 0.0.obs;

  void addToCart(Map<String, dynamic> item) {
    int index = cartItems.indexWhere(
      (cartItem) => cartItem['id'] == item['id'],
    );
    if (index != -1) {
      updateQuantity(index, 1);
    } else {
      item['quantity'] = 1;
      cartItems.add(item);
    }
    calculateTotalPrice();
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);
      calculateTotalPrice();
    }
  }

  void updateQuantity(int index, int delta) {
    if (index < 0 || index >= cartItems.length) {
      print("❌ Invalid index: $index");
      return;
    }

    var item = cartItems[index];
    int newQuantity = item['quantity'] + delta;

    if (newQuantity <= 0) {
      cartItems.removeAt(index);
    } else {
      cartItems[index] = {...item, 'quantity': newQuantity};
    }

    cartItems.refresh();
    calculateTotalPrice();
  }

  void calculateTotalPrice() {
    totalPrice.value = cartItems.fold(0.0, (total, item) {
      double price = (item['price'] ?? 0.0) * (item['quantity'] ?? 1);
      return total + price;
    });
  }

  Future<void> placeOrder({
    required String address,
    required String phone,
    required String orderId,
    required String trackingId,
  }) async {
    if (cartItems.isEmpty) return;

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
        'orderId': orderId,
        'trackingId': trackingId,
        'userId': user.uid,
        'products':
            cartItems
                .map(
                  (item) => {
                    'productId': item['id'],
                    'title': item['title'],
                    'price': item['price'],
                    'quantity': item['quantity'],
                  },
                )
                .toList(),
        'totalPrice': totalPrice.value,
        'address': address,
        'phone': phone,
        'status': 'pending',
        'orderDate': Timestamp.now(),
      });

      cartItems.clear();
      totalPrice.value = 0.0;
      print("✅ Order placed with tracking ID: $trackingId");
    } catch (e) {
      print("❌ Error placing order: $e");
    }
  }
}
