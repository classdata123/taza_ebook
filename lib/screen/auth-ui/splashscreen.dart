import 'dart:async';
import 'package:ebookapp/screen/auth-ui/register.dart'; // Correct import
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
    Timer(Duration(seconds: 3), () {
      Get.offNamed("/register"); // Route ke through navigate kro
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appMainbg,
      appBar: AppBar(backgroundColor: AppConstant.appMainbg, elevation: 0),
      body: Column(
        children: [
          Expanded(
            child: Center(child: Lottie.asset('assets/image/splash.json')),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              AppConstant.appMainName,
              style: TextStyle(
                color: AppConstant.textcolor,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
