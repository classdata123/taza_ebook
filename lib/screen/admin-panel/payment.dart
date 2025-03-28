import 'package:ebookapp/utility/app_content.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> updatePaymentStatus(String docId, String status) async {
    await db.collection('payments').doc(docId).update({'status': status});
    Get.snackbar("Success", "Payment Status Updated", backgroundColor: Colors.green, colorText: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppConstant.appMainbg,
      appBar: AppBar(
        title: Text("Payments", style: TextStyle(color: Colors.white)),
        backgroundColor: AppConstant.appMainColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: StreamBuilder(
          stream: db.collection('payments').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    title: Text("Order ID: ${doc['orderId']}", style: TextStyle(color: Colors.white)),
                    subtitle: Text(
                      "users: ${doc['userName']}\nAmount: \$${doc['amount']}\nStatus: ${doc['status']}",
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) => updatePaymentStatus(doc.id, value),
                      itemBuilder: (context) => [
                        PopupMenuItem(value: "Pending", child: Text("Pending")),
                        PopupMenuItem(value: "Completed", child: Text("Completed")),
                        PopupMenuItem(value: "Failed", child: Text("Failed")),
                      ],
                      icon: Icon(Icons.more_vert, color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}