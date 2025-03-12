import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookapp/utility/app_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'login.dart'; // Login screen ka import

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
          appBar: AppBar(backgroundColor: AppConstant.appMainbg, title: Text("Register")),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Animation
                // Container(
                //   color: AppConstant.appMainbg,
                //   child: Lottie.asset('assets/image/splash.json'),
                // ),

                // Email Field
                Container(
                  width: Get.width,
                  margin: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: email,
                    cursorColor: AppConstant.appMainColor,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),

                // Password Field
                Container(
                  width: Get.width,
                  margin: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: password,
                    cursorColor: AppConstant.appMainColor,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: Icon(Icons.visibility_off),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),

                // Name Field
                Container(
                  width: Get.width,
                  margin: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: name,
                    cursorColor: AppConstant.appMainColor,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),

                // Phone Field
                Container(
                  width: Get.width,
                  margin: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: phone,
                    cursorColor: AppConstant.appMainColor,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Phone',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),

                // Forget Password
                Container(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Get.snackbar("Reset Password", "Feature coming soon!");
                    },
                    child: Text("Forgot Password?"),
                  ),
                ),

                // Register Button
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: AppConstant.appMainbg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: Get.width / 3.2,
                  height: Get.height / 12,
                  child: TextButton.icon(
                    onPressed: () async {
                      if (name.text.isEmpty || phone.text.isEmpty || email.text.isEmpty || password.text.isEmpty) {
                        Get.snackbar(
                          "Error",
                          "Please fill all fields",
                          backgroundColor: Colors.red,
                          colorText: AppConstant.textcolor,
                        );
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
                          Get.snackbar(
                            "Success",
                            "User Registered Successfully!",
                            backgroundColor: Colors.green,
                            colorText: AppConstant.textcolor,
                          );
                          Get.to(() => LoginScreen());
                        } catch (e) {
                          Get.snackbar(
                            "Error",
                            "Error: $e",
                            backgroundColor: Colors.red,
                            colorText: AppConstant.textcolor,
                          );
                        }
                      }
                    },
                    icon: Icon(Icons.person_add, color: AppConstant.textcolor),
                    label: Text(
                      'Register',
                      style: TextStyle(color: AppConstant.textcolor),
                    ),
                  ),
                ),

                // Navigate to Login
                Container(
                  alignment: Alignment.bottomLeft,
                  child: TextButton(
                    onPressed: () {
                      Get.to(() => LoginScreen());
                    },
                    child: Text("Already have an account? Login"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
