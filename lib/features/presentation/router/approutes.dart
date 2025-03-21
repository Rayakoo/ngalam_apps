import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tes_gradle/features/presentation/screens/activity/activity_screen.dart';
import 'package:tes_gradle/features/presentation/screens/notification/notification_screen.dart';
import 'package:tes_gradle/features/presentation/screens/profile/profile_screen.dart';
import 'package:tes_gradle/features/presentation/screens/beranda/home_screen.dart';
import 'package:tes_gradle/features/presentation/screens/authentication/login_screen.dart';
import 'package:tes_gradle/features/presentation/screens/navbar/navbar_screen.dart';
import 'package:tes_gradle/features/presentation/screens/panggilan/panggilan_option.dart';
import 'package:tes_gradle/features/presentation/screens/pantau_malang/pantau_malang_screen.dart';
import 'package:tes_gradle/features/presentation/screens/onboarding/welcome_page_child1.dart';
import 'package:tes_gradle/features/presentation/screens/profile/ganti_password.dart'; // Import GantiPasswordScreen
import 'package:tes_gradle/features/presentation/screens/profile/pop_up_ulasan.dart'; // Import PopUpUlasanScreen
import 'package:tes_gradle/features/presentation/screens/beranda/detail_berita_screen.dart'; // Import DetailBeritaScreen

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
  static const String admin = '/admin';
  static const String beritaAdmin = '/berita-admin';
  static const String laporanAdmin = '/laporan-admin';
  static const String detailLaporanAdmin = '/detail-laporan-admin';
  static const String detailStatus = '/detail-status';
  static const String panggilanOption = '/panggilan-option';
  static const String pantauMalang = '/pantau-malang';
  static const String welcomeChild1 = '/welcome-child1';
  static const String ketentuanKebijakan = '/ketentuan-kebijakan';
  static const String gantiPassword = '/ganti-password';
  static const String popUpUlasan = '/pop-up-ulasan';
  static const String popUpAlamat = '/pop-up-alamat';
  static const String deskripsiStatus = '/deskripsiStatus';
  static const String popUpPanggilan = '/pop-up-panggilan';
  static const String adminPantauMalang = '/admin-pantau-malang';
  static const String detailBerita = '/detail-berita';
  static const String editProfile = '/edit-profile';
}
