import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookapp/utility/app_content.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  final TextEditingController _trackingController = TextEditingController();
  DocumentSnapshot? _orderData;
  bool _isLoading = false;
  String? _error;

  Future<void> fetchOrder() async {
    setState(() {
      _isLoading = true;
      _orderData = null;
      _error = null;
    });

    try {
      final query =
          await FirebaseFirestore.instance
              .collection('orders')
              .where('trackingId', isEqualTo: _trackingController.text.trim())
              .limit(1)
              .get();

      if (query.docs.isNotEmpty) {
        setState(() {
          _orderData = query.docs.first;
        });
      } else {
        setState(() {
          _error = "No order found with this Tracking ID.";
        });
      }
    } catch (e) {
      setState(() {
        _error = "Error fetching order: $e";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget buildOrderInfo() {
    if (_orderData == null) return const SizedBox();

    final data = _orderData!.data() as Map<String, dynamic>;
    final orderDate = (data['orderDate'] as Timestamp).toDate();
    final formattedDate = DateFormat('dd MMM yyyy – hh:mm a').format(orderDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          "📦 Order ID: ${data['orderId']}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text("🕒 Date: $formattedDate"),
        Text("📍 Status: ${data['status']}"),
        const Divider(height: 30),
        const Text("🛒 Items:", style: TextStyle(fontWeight: FontWeight.bold)),
        ...List<Widget>.from(
          (data['products'] as List).map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(item['title'] ?? '')),
                  Text("x${item['quantity']}"),
                  Text("\$${item['price'].toStringAsFixed(2)}"),
                ],
              ),
            );
          }),
        ),
        const Divider(height: 30),
        Text(
          "💵 Total: \$${data['totalPrice'].toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text("📞 Phone: ${data['phone']}"),
        Text("🏠 Address: ${data['address']}"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track Your Order"),
        backgroundColor: AppConstant.appMainColor,
        foregroundColor: AppConstant.appMainbg,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "Enter your Tracking ID",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _trackingController,
              decoration: InputDecoration(
                hintText: "Tracking ID",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: fetchOrder,
                ),
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              )
            else
              buildOrderInfo(),
          ],
        ),
      ),
    );
  }
}
