// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:pingolearn/constants.dart';
import 'package:pingolearn/controller.dart';
import 'package:pingolearn/screens/home_screen.dart';
import 'package:pingolearn/screens/signup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final controller = Get.put(NewsController());

  Future<void> _checkSignIn() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    Future.delayed(
      Duration.zero,
      () async {
        if (user != null) {
          await controller.setupRemoteConfig();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => SignUpScreen(),
            ),
          );
        }
      },
    );
  }

  @override
  void initState() {
    _checkSignIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: customText(
          'MyNews',
          25,
          FontWeight.bold,
          color: Colors.blue[700],
        ),
      ),
    );
  }
}
