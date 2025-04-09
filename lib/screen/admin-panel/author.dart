import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthorPage extends StatefulWidget {
  @override
  _AuthorPageState createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        title: Text("Author Details", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: "Search by Author or Category",
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: db.collection('books').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var books =
                      snapshot.data!.docs.where((doc) {
                        return doc['author'].toLowerCase().contains(
                              searchQuery,
                            ) ||
                            doc['category'].toLowerCase().contains(searchQuery);
                      }).toList();

                  return ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      var book = books[index];
                      return Card(
                        color: Colors.black, // Card black
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                            book['Bookname'],
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            "${book['author']} - ${book['category']}",
                            style: TextStyle(color: Colors.white70),
                          ),
                          onTap: () {
                            _showBookDetails(context, book);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookDetails(BuildContext context, QueryDocumentSnapshot book) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black, // Dialog background black
          title: Text("Book Details", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Book Name: ${book['Bookname']}",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "Author: ${book['author']}",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "Category: ${book['category']}",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "Description: ${book['description']}",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}
