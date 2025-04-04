import 'package:ebookapp/screen/Home/home.dart';
import 'package:ebookapp/screen/Home/search_filter.dart';
import 'package:ebookapp/screen/user-panel/order_show.dart';
import 'package:ebookapp/screen/user-panel/profile_screen.dart';
import 'package:ebookapp/screen/user-panel/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class bottom extends StatefulWidget {
  const bottom({super.key});

  @override
  State<bottom> createState() => _BottomState();
}

class _BottomState extends State<bottom> {
   int _selectedIndex = 0; // Track active tab

  final List<Widget> _screens = [
    HomeScreenContent(),
    WishlistScreen(),
    UserProfileScreen(),
    OrderShow(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigation using Get.to
    Get.to(_screens[index]);
  }
  @override
  Widget build(BuildContext context) {
    return  BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped, // Handle tab switch
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home', // Label added
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Wishlist', // Label added
        ),
          BottomNavigationBarItem(
          icon: Icon(Icons.shop),
          label: 'Orders', // Label added
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile', // Label added
        ),     
      ],
    );
  }
}