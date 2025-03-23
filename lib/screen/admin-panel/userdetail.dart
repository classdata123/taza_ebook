import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUsersDashboard extends StatefulWidget {
  @override
  _AdminUsersDashboardState createState() => _AdminUsersDashboardState();
}

class _AdminUsersDashboardState extends State<AdminUsersDashboard> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Users Dashboard", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                hintText: "Search Users",
                hintStyle: TextStyle(color: Colors.white54),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: db.collection('users').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var users =
                      snapshot.data!.docs.where((doc) {
                        return doc['name'].toLowerCase().contains(
                              searchQuery,
                            ) ||
                            doc['email'].toLowerCase().contains(searchQuery);
                      }).toList();

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      var user = users[index];
                      return Card(
                        color: Colors.grey[900],
                        child: ListTile(
                          title: Text(
                            user['name'],
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            user['email'],
                            style: TextStyle(color: Colors.white70),
                          ),
                          trailing: Text(
                            "Joined: ${user['registration_date']}",
                            style: TextStyle(color: Colors.white54),
                          ),
                          onTap: () {
                            _showUserDetails(context, user);
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

  void _showUserDetails(BuildContext context, QueryDocumentSnapshot user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text("User Details", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name: ${user['name']}",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "Email: ${user['email']}",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "Phone: ${user['phone']}",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "Joined: ${user['registration_date']}",
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
