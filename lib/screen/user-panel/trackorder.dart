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
  List<DocumentSnapshot>? _ordersData;  // To hold all orders
  DocumentSnapshot? _orderData;  // To hold specific order
  bool _isLoading = false;
  String? _error;

  final List<String> _statusSteps = [
    'pending',
    'processing',
    'shipped',
    'delivered',
  ];

  // Fetch a specific order by tracking ID
  Future<void> fetchOrder() async {
    setState(() {
      _isLoading = true;
      _orderData = null;
      _error = null;
    });

    try {
      final query = await FirebaseFirestore.instance
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

  // Fetch all orders
  Future<void> fetchAllOrders() async {
    setState(() {
      _isLoading = true;
      _ordersData = null;
      _error = null;
    });

    try {
      final query = await FirebaseFirestore.instance
          .collection('orders')
          .get();

      if (query.docs.isNotEmpty) {
        setState(() {
          _ordersData = query.docs;
        });
      } else {
        setState(() {
          _error = "No orders found.";
        });
      }
    } catch (e) {
      setState(() {
        _error = "Error fetching orders: $e";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Get status index for step representation
  int getStatusIndex(String status) {
    return _statusSteps.indexOf(status);
  }

  // Widget to display tracking steps
  Widget buildTrackingSteps(String currentStatus) {
    int currentIndex = getStatusIndex(currentStatus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_statusSteps.length, (index) {
        bool isDone = index <= currentIndex;
        return Row(
          children: [
            Icon(
              isDone ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isDone ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              _statusSteps[index].toUpperCase(),
              style: TextStyle(
                color: isDone ? Colors.green : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      }),
    );
  }

  // Widget to display order details
  Widget buildOrderInfo(DocumentSnapshot orderData) {
    final data = orderData.data() as Map<String, dynamic>;
    final orderDate = (data['orderDate'] as Timestamp).toDate();
    final formattedDate = DateFormat('dd MMM yyyy – hh:mm a').format(orderDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          "📦 Order ID: ${data['orderId']}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text("🕒 Date: $formattedDate"),
        const SizedBox(height: 10),
        Text(
          "📍 Current Status: ${data['status']}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        buildTrackingSteps(data['status']),
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

  // Widget to display all orders
  Widget buildAllOrders() {
    if (_ordersData == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_ordersData!.length, (index) {
        return buildOrderInfo(_ordersData![index]);
      }),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchAllOrders,  // Button to fetch all orders
              child: const Text("Fetch All Orders"),
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
              // Display either specific order or all orders
              _orderData != null ? buildOrderInfo(_orderData!) : buildAllOrders(),
          ],
        ),
      ),
    );
  }
}
