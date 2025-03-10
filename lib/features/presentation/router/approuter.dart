import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';
import 'package:tes_gradle/features/presentation/screens/activity/activity_screen.dart';
import 'package:tes_gradle/features/presentation/screens/notification/notification_screen.dart';
import 'package:tes_gradle/features/presentation/screens/profile/profile_screen.dart';
import '../screens/beranda/home_screen.dart';
import '../screens/login_screen.dart';
import 'package:tes_gradle/features/presentation/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:tes_gradle/features/presentation/screens/splash/splash_screen.dart';
import 'package:tes_gradle/features/presentation/screens/welcome_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash, // Set the initial route to splash
    redirect: (BuildContext context, GoRouterState state) {
      final user = firebase_auth.FirebaseAuth.instance.currentUser;
      final loggingIn =
          state.subloc == AppRoutes.auth || state.subloc == AppRoutes.register;
      final isSplash = state.subloc == AppRoutes.splash;

      // Debug print statements to see the current route and the redirected route
      print('Current route: ${state.subloc}');
      if (isSplash) {
        print('Allowing splash screen to navigate');
        return null; // Allow splash screen to navigate
      }
      if (user == null && !loggingIn) {
        print('Redirecting to: ${AppRoutes.auth}');
        return AppRoutes.auth;
      }
      if (user != null && loggingIn) {
        print('Redirecting to: ${AppRoutes.homepage}');
        return AppRoutes.homepage;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          print('Navigating to WelcomePage');
          return const WelcomePage();
        },
      ),
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (BuildContext context, GoRouterState state) {
          print('Navigating to WelcomePage');
          return const WelcomePage();
        },
      ),
      GoRoute(
        path: AppRoutes.activity,
        name: 'activity',
        builder: (BuildContext context, GoRouterState state) {
          print('Navigating to ActivityScreen');
          return const ActivityScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.notification,
        name: 'notification',
        builder: (BuildContext context, GoRouterState state) {
          print('Navigating to NotificationScreen');
          return const NotificationScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (BuildContext context, GoRouterState state) {
          print('Navigating to ProfileScreen');
          return const ProfileScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.homepage,
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          print('Navigating to HomeScreen');
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        builder: (BuildContext context, GoRouterState state) {
          print('Navigating to LoginScreen');
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (BuildContext context, GoRouterState state) {
          print('Navigating to RegisterScreen');
          return const RegisterScreen();
        },
      ),
    ],
    errorBuilder: (context, state) {
      print('Page not found: ${state.subloc}');
      return Scaffold(body: Center(child: Text('Page not found')));
    },
  );
}
