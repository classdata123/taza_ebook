import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;
  var totalPrice = 0.0.obs; // ✅ Reactive total price

  // 🛒 Add item to cart
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

  // ❌ Remove item from cart
  void removeFromCart(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);
      calculateTotalPrice();
    }
  }

  // 🔄 Update item quantity
  void updateQuantity(int index, int delta) {
    if (index < 0 || index >= cartItems.length) {
      print("❌ Invalid index: $index");
      return;
    }

    var item = cartItems[index];
    int newQuantity = item['quantity'] + delta;

    print(
      "🔄 Updating quantity: ${item['title']} | Old: ${item['quantity']} | Delta: $delta",
    );

    if (newQuantity <= 0) {
      cartItems.removeAt(index);
      print("🗑️ Item removed from cart.");
    } else {
      cartItems[index] = {...item, 'quantity': newQuantity};
      print("✅ Updated Quantity: ${cartItems[index]['quantity']}");
    }

    cartItems.refresh(); // ✅ UI refresh
    calculateTotalPrice();
  }

  // 💰 Calculate total price
  void calculateTotalPrice() {
    totalPrice.value = cartItems.fold(0.0, (total, item) {
      double price = (item['price'] ?? 0.0) * (item['quantity'] ?? 1);
      return total + price;
    });
  }

  // 🛍 Place order & save to Firestore
  Future<void> placeOrder() async {
    if (cartItems.isEmpty) return;

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('orders').add({
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
        'status': 'pending', // ✅ Initial status
        'orderDate': Timestamp.now(),
      });

      cartItems.clear(); // ✅ Empty cart after order
      totalPrice.value = 0.0;
      print("✅ Order placed successfully");
    } catch (e) {
      print("❌ Error placing order: $e");
    }
  }
}
