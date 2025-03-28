import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ebookapp/utility/app_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (FirebaseAuth.instance.currentUser != null) {
        Get.offNamed("/home");
      } else {
        Get.offNamed("/register");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appMainbg,
      body: Center(
        // Pure Column ko center karne ke liye
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Jo elements hain sirf unko center karega
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Main Splash Animation (Book Animation)
            Lottie.asset(
              'assets/image/mainsplash.json',
              width: 300,
              height: 300,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 15), // Space between animations
            // Small Loading Animation
            Lottie.asset(
              'assets/image/loading.json',
              width: 200, // Smaller size
              height: 200,
            ),
            const SizedBox(height: 20), // Space before text
            Text(
              AppConstant.appMainName,
              style: TextStyle(
                color: AppConstant.textcolor,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
