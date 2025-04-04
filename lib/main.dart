import 'package:ebookapp/controller/cart_controller.dart';
import 'package:ebookapp/screen/auth-ui/splashscreen.dart';
import 'package:ebookapp/screen/auth-ui/register.dart';
import 'package:ebookapp/screen/auth-ui/login.dart';
import 'package:ebookapp/screen/home/home.dart';
import 'package:ebookapp/screen/home/cart.dart'; // ✅ Cart Screen
import 'package:ebookapp/screen/user-panel/trackorder.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ Register cart controller globally
  Get.put(CartController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "E-Book App",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(),
      getPages: [
        GetPage(name: "/register", page: () => const RegisterScreen()),
        GetPage(name: "/login", page: () => const LoginScreen()),
        GetPage(name: "/home", page: () => const HomeScreenContent()),
        GetPage(name: "/cart", page: () => CartScreen()), // ✅ Cart route added
      ],
    );
  }
}
