import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;

  void addToCart(Map<String, dynamic> item) {
    cartItems.add(item);
  }

  void clearCart() {
    cartItems.clear();
  }
}
