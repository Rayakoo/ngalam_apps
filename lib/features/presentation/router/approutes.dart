import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tes_gradle/features/presentation/screens/activity/activity_screen.dart';
import 'package:tes_gradle/features/presentation/screens/notification/notification_screen.dart';
import 'package:tes_gradle/features/presentation/screens/profile/profile_screen.dart';
import 'package:tes_gradle/features/presentation/screens/beranda/home_screen.dart';
import 'package:tes_gradle/features/presentation/screens/authentication/login_screen.dart';
import 'package:tes_gradle/features/presentation/screens/navbar/navbar_screen.dart';

class AppRoutes {
  static const String splash = '/welcome';
  static const String activity = '/activity';
  static const String homepage = '/homepage';
  static const String notification = '/notification';
  static const String profile = '/profile';
  static const String auth = '/auth';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String sendOtpEmail = '/send-otp-email';
  static const String verifyOtpEmail = '/verify-otp-email';
  static const String resetPassword = '/reset-password';
  static const String navbar = '/navbar';
  static const String laporekBar = '/laporek-bar';
}
