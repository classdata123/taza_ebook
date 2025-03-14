import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookapp/main.dart';
import 'package:ebookapp/screen/auth-ui/register.dart';
import 'package:ebookapp/utility/app_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, visible) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppConstant.appMainbg,
            title: Text("Login"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
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

                // Login Button
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
                      if (email.text.isEmpty || password.text.isEmpty) {
                        Get.snackbar(
                          "Error",
                          "Please fill all fields",
                          backgroundColor: Colors.red,
                          colorText: AppConstant.textcolor,
                        );
                      } else {
                        try {
                          UserCredential userCredential = await auth.signInWithEmailAndPassword(
                            email: email.text.trim(),
                            password: password.text.trim(),
                          );

                          // Show success message
                          Get.snackbar(
                            "Success",
                            "Login Successful!",
                            backgroundColor: Colors.green,
                            colorText: AppConstant.textcolor,
                          );

                          // Redirect to Main Page (fix applied)
                          Get.offAll(() => MyApp());
                        } on FirebaseAuthException catch (e) {
                          String errorMessage = "Login failed!";
                          if (e.code == 'user-not-found') {
                            errorMessage = "No user found with this email.";
                          } else if (e.code == 'wrong-password') {
                            errorMessage = "Incorrect password!";
                          } else if (e.code == 'invalid-email') {
                            errorMessage = "Invalid email format!";
                          }
                          Get.snackbar(
                            "Error",
                            errorMessage,
                            backgroundColor: Colors.red,
                            colorText: AppConstant.textcolor,
                          );
                        } catch (e) {
                          Get.snackbar(
                            "Error",
                            "Unexpected error: ${e.toString()}",
                            backgroundColor: Colors.red,
                            colorText: AppConstant.textcolor,
                          );
                        }
                      }
                    },
                    icon: Icon(Icons.login, color: AppConstant.textcolor),
                    label: Text(
                      'Login',
                      style: TextStyle(color: AppConstant.textcolor),
                    ),
                  ),
                ),

                // Navigate to Register
                Container(
                  alignment: Alignment.bottomLeft,
                  child: TextButton(
                    onPressed: () {
                      Get.to(() => RegisterScreen());
                    },
                    child: Text("Don't have an account? Register"),
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