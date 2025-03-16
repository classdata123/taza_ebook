import 'package:ebookapp/utility/app_content.dart';
import 'package:flutter/material.dart';

class draw extends StatefulWidget {
  const draw({super.key});

  @override
  State<draw> createState() => _drawState();
}

class _drawState extends State<draw> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(80),
          bottomRight: Radius.circular(80),
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
                child: Text('a'),
              ),
            ),
          ),
          Divider(
            indent: 10.0,
            endIndent: 10.0,
            thickness: 2.5,
            color: Colors.black12,
          ),
        ],
      ),
    );
  }
}
