import 'package:ebookapp/utility/app_content.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderStatusPage extends StatefulWidget {
  @override
  _OrderStatusPageState createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void updateOrderStatus(String orderId, String newStatus) async {
    await _firestore.collection('orders').doc(orderId).update({'status': newStatus});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order status updated to $newStatus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Status', style: TextStyle(color: Colors.white)),
        backgroundColor: AppConstant.appMainColor,
      ),
      backgroundColor: AppConstant.appMainbg,
      body: StreamBuilder(
        stream: _firestore.collection('orders').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: EdgeInsets.all(10),
            children: snapshot.data!.docs.map((doc) {
              var order = doc.data() as Map<String, dynamic>;
              return Card(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User: ${order['userName']}', style: TextStyle(color: Colors.white)),
                      Text('Book: ${order['bookName']}', style: TextStyle(color: Colors.white)),
                      Text('Price: \$${order['price']}', style: TextStyle(color: Colors.white)),
                      Text('Status: ${order['status']}', style: TextStyle(color: Colors.blueAccent)),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: ['Pending', 'Shipped', 'Delivered', 'Canceled'].map((status) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                            onPressed: () => updateOrderStatus(doc.id, status),
                            child: Text(status, style: TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}