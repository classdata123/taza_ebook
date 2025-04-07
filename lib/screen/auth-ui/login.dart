import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookapp/screen/admin-panel/admindashboard.dart';
import 'package:ebookapp/screen/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
  final GoogleSignIn googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, visible) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                      child: Lottie.asset('assets/image/logo.json'),
                    ),
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text("Please enter your credentials."),
                    SizedBox(height: 12),
                    _buildTextField(
                      controller: email,
                      hint: "Email",
                      icon: Icons.email,
                    ),
                    _buildTextField(
                      controller: password,
                      hint: "Password",
                      icon: Icons.lock,
                      obscure: true,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text("Forgot Password?"),
                      ),
                    ),
                    SizedBox(height: 12),
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
                        onPressed: loginWithEmail,
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text("or"),
                    SizedBox(height: 12),
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

  void loginWithEmail() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      final doc =
          await db.collection('users').doc(userCredential.user!.uid).get();
      if (!doc.exists) {
        Get.snackbar(
          "Error",
          "User record not found",
          backgroundColor: Colors.red,
        );
        return;
      }
      bool isAdmin = doc['isAdmin'] ?? false;
      Get.offAll(() => isAdmin ? AdminDashboard() : HomeScreenContent());
      Get.snackbar(
        "Success",
        "Login Successful!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Invalid email or password",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void loginWithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount;
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        final UserCredential userCredential = await FirebaseAuth.instance
            .signInWithPopup(googleProvider);
        final User? user = userCredential.user;
        if (user != null) {
          await db.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'name': user.displayName.toString(),
            'email': user.email.toString(),
            'image': user.photoURL.toString(),
            'isadmin': false,
            'phone': user.phoneNumber.toString(),
          });
          Get.to(HomeScreenContent());
        }
      } else {
        final GoogleSignInAccount? googleSignInAccount =
            await googleSignIn.signIn();
        if (googleSignInAccount != null) {
          final GoogleSignInAuthentication googleSignInAuthentication =
              await googleSignInAccount.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );
          final UserCredential userCredential = await auth.signInWithCredential(
            credential,
          );
          final User? user = userCredential.user;
          if (user != null) {
            await db.collection('Users').doc(user.uid).set({
              'uId': user.uid,
              'username': user.displayName.toString(),
              'email': user.email.toString(),
              'userimage': user.photoURL.toString(),
              'isadmin': false,
            });
            Get.to(HomeScreenContent());
          }
        }
      }
    } catch (e) {
      print(e);
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(icon, color: Colors.black54),
        ),
      ),
    );
  }
}
