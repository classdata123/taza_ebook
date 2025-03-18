import 'package:ebookapp/screen/auth-ui/splashscreen.dart';
import 'package:ebookapp/screen/auth-ui/register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      home: SplashScreen(),
      getPages: [
        GetPage(name: "/register", page: () => RegisterScreen()),
        GetPage(name: "/splash", page: () => SplashScreen()), // Added for better navigation
      ],
    );
  }
}
