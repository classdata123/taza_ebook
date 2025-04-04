import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookapp/component/global_app_bar.dart';
import 'package:ebookapp/screen/Home/bottom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddToCartPage extends StatefulWidget {
  const AddToCartPage({Key? key}) : super(key: key);

  @override
  State<AddToCartPage> createState() => _AddToCartPageState();
}

class _AddToCartPageState extends State<AddToCartPage> {
  late Future<List<Map<String, dynamic>>> _cartProducts;
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cartProducts = _getCartProducts();
  }

  Future<List<Map<String, dynamic>>> _getCartProducts() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    var cartSnapshot =
        await FirebaseFirestore.instance
            .collection('cart')
            .where('userId', isEqualTo: user.uid)
            .get();

    List<Map<String, dynamic>> cartProducts = [];
    for (var cartItem in cartSnapshot.docs) {
      var productId = cartItem['productId'];

      var productSnapshot =
          await FirebaseFirestore.instance
              .collection('product')
              .doc(productId)
              .get();

      if (productSnapshot.exists) {
        var productData = productSnapshot.data();
        cartProducts.add({
          'cartId': cartItem.id,
          'productId': productId,
          'name': productData?['name'],
          'price': productData?['price'],
          'image': productData?['image'],
          'description': productData?['description'],
        });
      }
    }
    return cartProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: GlobalAppBar(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _cartProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items in the cart.'));
          }

          var cartProducts = snapshot.data!;
          double totalPrice = cartProducts.fold(0, (total, product) {
            return total +
                int.parse((product['price'] ?? '0').replaceAll(',', ''));
          });

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartProducts.length,
                  itemBuilder: (context, index) {
                    var product = cartProducts[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        margin: EdgeInsets.only(bottom: 15),
                        elevation: 8,
                        child: ListTile(
                          leading:
                              product['image'] != null
                                  ? Image.memory(
                                    base64Decode(product['image'] ?? ''),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                  : const Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                          title: Text(
                            product['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            '\$${product['price']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.remove_shopping_cart,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: \$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                        child: Text(
                          "Place Order",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
          bottomNavigationBar: bottom(),
    );
  }
}
