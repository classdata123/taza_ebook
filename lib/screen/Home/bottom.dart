import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebookapp/screen/Home/home.dart';
import 'package:ebookapp/screen/user-panel/wishlist_screen.dart';
import 'package:ebookapp/screen/user-panel/order_show.dart';
import 'package:ebookapp/screen/user-panel/profile_screen.dart';

class BottomNavBar extends StatelessWidget {
  final RxInt selectedIndex = 0.obs; // Using GetX for reactive state

  final List<Widget> _screens = [
    HomeScreenContent(),
    WishlistScreen(),
    OrderShow(),
    UserProfileScreen(),
  ];

  void _onItemTapped(int index) {
    selectedIndex.value = index;
    Get.offAll(() => _screens[index], transition: Transition.fadeIn); // Replaces current screen
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          currentIndex: selectedIndex.value,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shop),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ));
  }
}
