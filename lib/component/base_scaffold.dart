import 'package:ebookapp/component/global_app_bar.dart';
import 'package:ebookapp/screen/admin-panel/Product.dart';
import 'package:ebookapp/utility/app_content.dart';
import 'package:flutter/material.dart';

class BaseScaffold extends StatefulWidget {
  final Widget body;
  final String? title;

  const BaseScaffold({
    Key? key,
    required this.body,
    this.title,
  }) : super(key: key);

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: GlobalAppBar(
        scaffoldKey: _scaffoldKey,
        title: widget.title,
      ),
      drawer: Draw(),
      body: widget.body,
    );
  }
}


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
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text('Home'),
              leading: Icon(Icons.home),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Add navigation logic here
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text('Product'),
              leading: Icon(Icons.production_quantity_limits),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Add navigation logic here
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            ProductScreen(), // Replace with your actual Product screen widget
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text('Users'),
              leading: Icon(Icons.verified_user),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Add navigation logic here
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.center,
              title: Text('Request'),
              leading: Icon(Icons.request_page),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Add navigation logic here
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
