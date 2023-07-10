import 'package:flutter/material.dart';

class NotficationsScreen extends StatelessWidget {
  const NotficationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text('Notifications'),
      ),
      body: const Center(
        child: Text('Empty', style: TextStyle(
          fontSize: 20,
          color: Colors.grey
        ),),
      ),
    );
  }
}