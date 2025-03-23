import 'package:flutter/material.dart';
import 'package:ebookapp/utility/app_content.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String? title;

  const GlobalAppBar({
    Key? key,
    required this.scaffoldKey,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppConstant.appMainColor,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
      title: title != null ? Text(title!, style: TextStyle(color: Colors.white)) : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
