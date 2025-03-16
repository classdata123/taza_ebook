import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookapp/utility/app_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Register",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Please fill your details to signup.",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),

                    // Name Field
                    _buildTextField(controller: name, hint: "Username", icon: Icons.person),
                    
                    // Email Field
                    _buildTextField(controller: email, hint: "Email", icon: Icons.email),

                    // Password Field
                    _buildTextField(controller: password, hint: "Password", icon: Icons.lock, obscure: true),

                    // Confirm Password Field
                    _buildTextField(controller: phone, hint: "Confirm Password", icon: Icons.lock, obscure: true),

                    SizedBox(height: 20),

                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () async {
                          if (name.text.isEmpty || phone.text.isEmpty || email.text.isEmpty || password.text.isEmpty) {
                            Get.snackbar("Error", "Please fill all fields", backgroundColor: Colors.red, colorText: Colors.white);
                          } else {
                            try {
                              UserCredential userCredential = await auth.createUserWithEmailAndPassword(
                                email: email.text,
                                password: password.text,
                              );
                              await db.collection('users').doc(userCredential.user!.uid).set({
                                'uid': userCredential.user!.uid,
                                'name': name.text,
                                'email': email.text,
                                'image': 'null',
                                'isAdmin': false,
                                'phone': phone.text,
                              });
                              Get.snackbar("Success", "User Registered Successfully!", backgroundColor: Colors.green, colorText: Colors.white);
                              Get.to(() => LoginScreen());
                            } catch (e) {
                              Get.snackbar("Error", "Error: $e", backgroundColor: Colors.red, colorText: Colors.white);
                            }
                          }
                        },
                        child: Text("Register", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Navigate to Login
                    GestureDetector(
                      onTap: () => Get.to(() => LoginScreen()),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "Already a member? ",
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                          children: [
                            TextSpan(
                              text: "SignIn",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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

  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon, bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[300],
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          prefixIcon: Icon(icon, color: Colors.black54),
        ),
      ),
    );
  }
}
