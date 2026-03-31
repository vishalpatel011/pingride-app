import 'package:flutter/material.dart';

class DummyHomeScreen extends StatelessWidget {
  const DummyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          "Login Successful 🚀",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}