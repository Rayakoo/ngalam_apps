import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Splash Screen'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.go(AppRoutes.auth);
                },
                child: const Text('Go to Login Screen'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  context.go(AppRoutes.homepage);
                },
                child: const Text('Go to Home Screen'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  context.go(AppRoutes.activity);
                },
                child: const Text('Go to Activity Screen'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  context.go(AppRoutes.notification);
                },
                child: const Text('Go to Notification Screen'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  context.go(AppRoutes.profile);
                },
                child: const Text('Go to Profile Screen'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  context.go(AppRoutes.register);
                },
                child: const Text('Go to Register Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
