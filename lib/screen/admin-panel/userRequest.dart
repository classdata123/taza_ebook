import 'package:ebookapp/utility/app_content.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';


class UserRequestsPage extends StatelessWidget {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> updateRequestStatus(String docId, String status) async {
    await db.collection('requests').doc(docId).update({'status': status});
    Get.snackbar("Success", "Request updated to $status", backgroundColor: Colors.green, colorText: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appMainbg,
      appBar: AppBar(
        title: Text("User Requests", style: TextStyle(color: Colors.white)),
        backgroundColor: AppConstant.appMainColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
          stream: db.collection('requests').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return Card(
                  color: Colors.grey[900],
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(doc['userName'], style: TextStyle(color: Colors.white)),
                    subtitle: Text("Book: ${doc['bookName']}\nPrice: ${doc['price']}\nStatus: ${doc['status']}", style: TextStyle(color: Colors.white70)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () => updateRequestStatus(doc.id, "Approved"),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () => updateRequestStatus(doc.id, "Rejected"),
                        ),
                      ],
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