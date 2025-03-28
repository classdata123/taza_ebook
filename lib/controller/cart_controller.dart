import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;

  void addToCart(Map<String, dynamic> item) {
    print("$item items");
    cartItems.add(item);
  }

  void clearCart() {
    cartItems.clear();
  }
}

