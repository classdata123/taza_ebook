import 'package:ebookapp/utility/app_content.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BookSuggestionsPage extends StatefulWidget {
  @override
  _BookSuggestionsPageState createState() => _BookSuggestionsPageState();
}

class _BookSuggestionsPageState extends State<BookSuggestionsPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> updateSuggestionStatus(String docId, String status) async {
    await db.collection('book_suggestions').doc(docId).update({'status': status});
    Get.snackbar("Success", "Suggestion Updated Successfully", backgroundColor: Colors.green, colorText: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Suggestions", style: TextStyle(color: Colors.white)),
        backgroundColor: AppConstant.appMainColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: AppConstant.appMainbg,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
          stream: db.collection('book_suggestions').snapshots(),
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
                    title: Text(doc['book_name'], style: TextStyle(color: Colors.white)),
                    subtitle: Text("Suggested by: ${doc['user_name']} \nStatus: ${doc['status']}", style: TextStyle(color: Colors.white70)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () => updateSuggestionStatus(doc.id, "Accepted"),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () => updateSuggestionStatus(doc.id, "Rejected"),
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