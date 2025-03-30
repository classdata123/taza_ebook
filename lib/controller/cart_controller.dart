import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;
  var totalPrice = 0.0.obs; // ✅ Make totalPrice reactive

  void addToCart(Map<String, dynamic> item) {
    cartItems.add(item);
    calculateTotalPrice(); // ✅ Recalculate total
  }

  void removeFromCart(int index) {
    cartItems.removeAt(index);
    calculateTotalPrice(); // ✅ Recalculate total
  }

void updateQuantity(int index, int delta) {
  if (index < 0 || index >= cartItems.length) {
    print("❌ Invalid index: $index");
    return;
  }

  var item = cartItems[index];
  int newQuantity = item['quantity'] + delta;

  print("🔄 Updating quantity for item: ${item['title']} | Old Quantity: ${item['quantity']} | Delta: $delta");

  if (newQuantity <= 0) {
    cartItems.removeAt(index);
    print("🗑️ Item removed from cart.");
  } else {
    cartItems[index] = {
      ...item,
      'quantity': newQuantity
    };
    print("✅ Updated Quantity: ${cartItems[index]['quantity']}");
  }

  cartItems.refresh(); // Force UI update
  calculateTotalPrice();
}


  void calculateTotalPrice() {
    totalPrice.value = cartItems.fold(0.0, (total, item) {
      double price = (item['price'] ?? 0.0) * (item['quantity'] ?? 1);
      return total + price;
    });
  }
}
