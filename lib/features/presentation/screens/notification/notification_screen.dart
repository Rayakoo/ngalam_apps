import 'package:flutter/material.dart';
import 'package:tes_gradle/features/presentation/style/color.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Page"),
        backgroundColor:
            AppColors.cce1f0, // Set the AppBar color to secondary color
      ),
      body: Container(child: Center(child: Text('notification'))),
    );
  }
}
