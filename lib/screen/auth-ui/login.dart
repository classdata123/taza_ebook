import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookapp/main.dart';
import 'package:ebookapp/screen/auth-ui/register.dart';
import 'package:ebookapp/utility/app_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(child: Text('This is the login screen')),
    );
  }
}
