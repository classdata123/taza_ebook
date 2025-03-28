import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookapp/User/profile_screen.dart';
import 'package:ebookapp/screen/admin-panel/admindashboard.dart';
import 'package:ebookapp/utility/app_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart'; // Lottie for animations

import '../home/home.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, visible) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Get.back(),
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Lottie Animation
                    SizedBox(
                      height: 150,
                      child: Lottie.asset('assets/image/logo.json'),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Please enter your credentials.",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),

                    // Email Field
                    _buildTextField(
                      controller: email,
                      hint: "Email",
                      icon: Icons.email,
                    ),

                    // Password Field
                    _buildTextField(
                      controller: password,
                      hint: "Password",
                      icon: Icons.lock,
                      obscure: true,
                    ),

                    // Forgot Password Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => resetPassword(),
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          if (email.text.isEmpty || password.text.isEmpty) {
                            Get.snackbar(
                              "Error",
                              "Please fill all fields",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          } else {
                            try {
                              UserCredential userCredential = await auth
                                  .signInWithEmailAndPassword(
                                    email: email.text,
                                    password: password.text,
                                  );
                              final QuerySnapshot userdata =
                                  await db
                                      .collection('users')
                                      .where(
                                        'uid',
                                        isEqualTo: userCredential.user!.uid,
                                      )
                                      .get();

                              if (userdata.docs.first['isAdmin'] == true) {
                                Get.to(AdminDashboard());

                                Get.snackbar(
                                  "Success",
                                  "Login Successful!",
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              } else {
                                Get.offAll(() => HomeScreenContent());
                                Get.snackbar(
                                  "Success",
                                  "Login Successful!",
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              }

                              // ✅ Redirect to Home Screen
                            } catch (e) {
                              Get.snackbar(
                                "Error",
                                "Invalid email or password",
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          }
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    // Navigate to Register
                    GestureDetector(
                      onTap: () => Get.to(() => RegisterScreen()),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                          children: [
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[300],
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(icon, color: Colors.black54),
        ),
      ),
    );
  }

  // 🔹 Function to reset password via email
  void resetPassword() async {
    if (email.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your email to reset password",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      await auth.sendPasswordResetEmail(email: email.text.trim());
      Get.snackbar(
        "Success",
        "Password reset email sent!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to send reset email. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
