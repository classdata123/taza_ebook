import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookapp/screen/admin-panel/admindashboard.dart';
import 'package:ebookapp/screen/home/home.dart';
import 'package:ebookapp/utility/app_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  children: [
                    SizedBox(height: 150, child: Lottie.asset('assets/image/logo.json')),
                    Text("Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text("Please enter your credentials."),
                    SizedBox(height: 12),
                    _buildTextField(controller: email, hint: "Email", icon: Icons.email),
                    _buildTextField(controller: password, hint: "Password", icon: Icons.lock, obscure: true),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(onPressed: resetPassword, child: Text("Forgot Password?")),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                        onPressed: loginWithEmail,
                        child: Text("Login", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text("or"),
                    SizedBox(height: 12),
                    // ✅ Google Sign-In Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.login),
                        label: Text("Sign in with Google"),
                        onPressed: loginWithGoogle,
                      ),
                    ),
                    SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => Get.to(() => RegisterScreen()),
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.black54),
                          children: [TextSpan(text: "Sign Up", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))],
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

  void loginWithEmail() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email.text, password: password.text);
      final doc = await db.collection('users').doc(userCredential.user!.uid).get();
      if (!doc.exists) {
        Get.snackbar("Error", "User record not found", backgroundColor: Colors.red);
        return;
      }

      bool isAdmin = doc['isAdmin'] ?? false;
      Get.offAll(() => isAdmin ? AdminDashboard() : HomeScreenContent());
      Get.snackbar("Success", "Login Successful!", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Invalid email or password", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user;

      final docRef = db.collection('users').doc(user!.uid);
      final userDoc = await docRef.get();

      if (!userDoc.exists) {
        // Add user to DB
        await docRef.set({
          'uid': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'image': user.photoURL ?? '',
          'isAdmin': false,
          'phone': '',
        });
      }

      Get.offAll(() => HomeScreenContent());
      Get.snackbar("Success", "Logged in with Google", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Google login failed", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void resetPassword() async {
    if (email.text.isEmpty) {
      Get.snackbar("Error", "Enter your email first", backgroundColor: Colors.red);
      return;
    }
    try {
      await auth.sendPasswordResetEmail(email: email.text.trim());
      Get.snackbar("Success", "Password reset email sent", backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar("Error", "Failed to send reset email", backgroundColor: Colors.red);
    }
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          prefixIcon: Icon(icon, color: Colors.black54),
        ),
      ),
    );
  }
}
