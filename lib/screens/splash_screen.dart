import 'dart:async';
import 'package:flutter/material.dart';
import 'package:resume_fix/utils/routes/routes.dart'; // ✅ Use constant route

class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacementNamed(Routes.homePage); // ✅ safer route reference
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xffECECEC),
      body: Column(
        children: [
          SizedBox(height: 250),
          Image(image: AssetImage("assets/Icon/New Line .gif")),
          SizedBox(height: 20),
          Text(
            "Resume Builder App",
            style: TextStyle(fontSize: 20, letterSpacing: 2, fontWeight: FontWeight.bold),
          ),
          Text(
            "Welcome",
            style: TextStyle(fontSize: 20, letterSpacing: 3, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
