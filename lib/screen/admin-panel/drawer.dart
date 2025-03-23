import 'package:ebookapp/utility/app_content.dart';
import 'package:flutter/material.dart';

class Draw extends StatefulWidget {
  const Draw({super.key});

  @override
  State<Draw> createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
      ),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text('Admin'),
              subtitle: Text('ABC@GMAIL.COM'),
              leading: CircleAvatar(
                backgroundColor: AppConstant.appMainbg,
                child: Text('A'),
              ),
            ),
          ),
          Divider(
            indent: 10.0,
            endIndent: 10.0,
            thickness: 3.5,
            color: const Color.fromARGB(31, 2, 2, 2),
          ),

          // admin panel list
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text('Product'),
              leading: Icon(Icons.production_quantity_limits),
              trailing: Icon(Icons.arrow_forward),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text('Users'),
              leading: Icon(Icons.verified_user),
              trailing: Icon(Icons.arrow_forward),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text('Home'),
              leading: Icon(Icons.home),
              trailing: Icon(Icons.arrow_forward),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text('Request'),
              leading: Icon(Icons.request_page),
              trailing: Icon(Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
  }
}
