import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:tes_gradle/features/domain/entities/berita.dart';
import 'package:tes_gradle/features/domain/entities/laporan.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';
import 'package:tes_gradle/features/presentation/screens/activity/activity_screen.dart';
import 'package:tes_gradle/features/presentation/screens/activity/deskripsi_status.dart';
import 'package:tes_gradle/features/presentation/screens/admin/admin_pantau_malang.dart';
import 'package:tes_gradle/features/presentation/screens/notification/notification_screen.dart';
import 'package:tes_gradle/features/presentation/screens/panggilan/pop_up_panggilan.dart';
import 'package:tes_gradle/features/presentation/screens/profile/edit_profile_screen.dart';
import 'package:tes_gradle/features/presentation/screens/profile/pop_up_alamat.dart';
import 'package:tes_gradle/features/presentation/screens/profile/profile_screen.dart';
import 'package:tes_gradle/features/presentation/screens/beranda/home_screen.dart';
import 'package:tes_gradle/features/presentation/screens/authentication/login_screen.dart';
import 'package:tes_gradle/features/presentation/screens/authentication/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:tes_gradle/features/presentation/screens/splash/splash_screen.dart';
import 'package:tes_gradle/features/presentation/screens/onboarding/welcome_page_child1.dart';
import 'package:tes_gradle/features/presentation/screens/authentication/forgot_pass_screen.dart';
import 'package:tes_gradle/features/presentation/screens/authentication/reset_password_screen.dart';
import 'package:tes_gradle/features/presentation/screens/navbar/navbar_screen.dart';
import 'package:tes_gradle/features/presentation/screens/beranda/laporek/laporek_bar.dart';
import 'package:tes_gradle/features/presentation/screens/admin/admin_screen.dart';
import 'package:tes_gradle/features/presentation/screens/admin/berita_admin_screen.dart';
import 'package:tes_gradle/features/presentation/screens/admin/laporan_admin_screen.dart';
import 'package:tes_gradle/features/presentation/screens/admin/detail_laporan_admin_screen.dart';
import 'package:tes_gradle/features/presentation/screens/activity/detail_status_screen.dart';
import 'package:provider/provider.dart';
import 'package:tes_gradle/features/presentation/provider/user_provider.dart';
import 'package:tes_gradle/features/presentation/screens/panggilan/panggilan_option.dart';
import 'package:tes_gradle/features/presentation/screens/pantau_malang/pantau_malang_screen.dart'; // Add this line
import 'package:tes_gradle/features/presentation/screens/authentication/ketentuan_kebijakan_screen.dart'; // Ensure this line exists
import 'package:tes_gradle/features/presentation/screens/profile/ganti_password.dart'; // Import GantiPasswordScreen
import 'package:tes_gradle/features/presentation/screens/profile/pop_up_ulasan.dart'; // Import PopUpUlasanScreen
import 'package:tes_gradle/features/presentation/screens/beranda/detail_berita_screen.dart'; // Import DetailBeritaScreen

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (BuildContext context, GoRouterState state) async {
      final user = firebase_auth.FirebaseAuth.instance.currentUser;
      final loggingIn =
          state.subloc == AppRoutes.auth ||
          state.subloc == AppRoutes.register ||
          state.subloc == AppRoutes.forgotPassword ||
          state.subloc == AppRoutes.sendOtpEmail ||
          state.subloc == AppRoutes.verifyOtpEmail ||
          state.subloc == AppRoutes.resetPassword ||
          state.subloc == AppRoutes.ketentuanKebijakan;
      final isSplash = state.subloc == AppRoutes.splash;

      print('Current route: ${state.subloc}');
      if (isSplash) {
        print('Allowing splash screen to navigate');
        return null;
      }
      if (user == null &&
          !loggingIn &&
          state.subloc != AppRoutes.ketentuanKebijakan) {
        print('Redirecting to: ${AppRoutes.auth}');
        return AppRoutes.auth;
      }
      if (user != null && loggingIn) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.fetchUserData();
        if (userProvider.userRole == 'admin') {
          print('Redirecting to: ${AppRoutes.admin}');
          return AppRoutes.admin;
        } else if (state.subloc != AppRoutes.ketentuanKebijakan) {
          print('Redirecting to: ${AppRoutes.navbar}');
          return AppRoutes.navbar;
        }
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
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (BuildContext context, GoRouterState state) {
          print('Navigating to ForgotPassScreen');
          return const ForgotPassScreen();
        },
      ),

      GoRoute(
        path: AppRoutes.resetPassword,
        name: 'resetPassword',
        builder: (BuildContext context, GoRouterState state) {
          final email = state.extra as String;
          print('Navigating to ResetPasswordScreen');
          return ResetPasswordScreen(email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.navbar,
        builder: (context, state) => const NavbarScreen(),
      ),
      GoRoute(
        path: AppRoutes.laporekBar,
        name: 'laporekBar',
        builder: (BuildContext context, GoRouterState state) {
          print('Navigating to LaporekBar');
          return const LaporekBar();
        },
      ),
      GoRoute(
        path: AppRoutes.admin,
        name: 'admin',
        builder: (BuildContext context, GoRouterState state) {
          print('Navigating to AdminScreen');
          return const AdminScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.beritaAdmin,
        name: 'beritaAdmin',
        builder: (BuildContext context, GoRouterState state) {
          print('Navigating to BeritaAdminScreen');
          return const BeritaAdminScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.laporanAdmin,
        name: 'laporanAdmin',
        builder: (BuildContext context, GoRouterState state) {
          print('Navigating to LaporanAdminScreen');
          return const LaporanAdminScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.detailLaporanAdmin,
        name: 'detailLaporanAdmin',
        builder: (BuildContext context, GoRouterState state) {
          final laporan = state.extra as Laporan;
          return DetailLaporanAdminScreen(laporan: laporan);
        },
      ),
      GoRoute(
        path: AppRoutes.detailStatus,
        name: 'detailStatus',
        builder: (BuildContext context, GoRouterState state) {
          final laporan = state.extra as Laporan;
          return DetailStatusScreen(laporan: laporan);
        },
      ),
      GoRoute(
        path: AppRoutes.panggilanOption, // Add this route
        name: 'panggilanOption',
        builder: (BuildContext context, GoRouterState state) {
          print('Navigating to PanggilanOptionScreen');
          return const PanggilanOptionScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.pantauMalang,
        name: 'pantauMalang',
        builder: (BuildContext context, GoRouterState state) {
          return const PantauMalangScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.ketentuanKebijakan,
        name: 'ketentuanKebijakan',
        builder: (BuildContext context, GoRouterState state) {
          print('Navigating to KetentuanKebijakanScreen');
          return const KetentuanKebijakanScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.gantiPassword,
        name: 'gantiPassword',
        builder: (BuildContext context, GoRouterState state) {
          print('Navigating to GantiPasswordScreen');
          return const GantiPasswordScreen();
        },
      ),
      GoRoute(
        path: '/deskripsiStatus',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return DeskripsiStatusScreen(
            imageUrl: extra['imageUrl'],
            date: extra['date'],
            description: extra['description'],
            status: extra['status'],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.popUpUlasan,
        name: 'popUpUlasan',
        builder: (BuildContext context, GoRouterState state) {
          print('Navigating to PopUpUlasanScreen');
          return const PopUpUlasanScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.popUpAlamat,
        builder: (context, state) {
          return const PopUpAlamatScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.popUpPanggilan,
        name: 'popUpPanggilan',
        builder: (BuildContext context, GoRouterState state) {
          final args = state.extra as Map<String, dynamic>;
          return PopUpPanggilan(
            imagePath: args['imagePath'],
            title: args['title'],
            phoneNumber: args['phoneNumber'],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.adminPantauMalang,
        name: 'adminPantauMalang',
        builder: (BuildContext context, GoRouterState state) {
          print('Navigating to AdminPantauMalangScreen');
          return const AdminPantauMalangScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.detailBerita,
        builder: (context, state) {
          final berita = state.extra as Berita;
          return DetailBeritaScreen(berita: berita);
        },
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'editProfile',
        builder: (BuildContext context, GoRouterState state) {
          return const EditProfileScreen();
        },
      ),
    ],
    errorBuilder: (context, state) {
      print('Page not found: ${state.subloc}');
      return Scaffold(body: Center(child: Text('Page not found')));
    },
  );
}
