import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tes_gradle/features/domain/usecases/get_user_data.dart';
import 'package:tes_gradle/features/presentation/router/approuter.dart';
import 'package:tes_gradle/features/presentation/style/theme.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'features/presentation/provider/auth_provider.dart';
import 'features/presentation/provider/user_provider.dart';
import 'features/presentation/screens/welcome_page.dart';
import 'features/presentation/screens/beranda/home_screen.dart';
import 'di/injetion_container.dart' as di;
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides(); // Disable SSL verification

  try {
    print('Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully.');
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  print('Setting up dependency injection...');
  di.setupDependencyInjection();
  print('Dependency injection setup completed.');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(GetUserData(di.sl()), di.sl()),
        ),
        ChangeNotifierProvider(
          create:
              (_) => AuthProvider(
                loginUser: di.sl(),
                registerUser: di.sl(),
                forgotPassword: di.sl(),
                sendOtp: di.sl(),
                verifyOtp: di.sl(),
                accountExists: di.sl(),
              ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('Building MyApp...');
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Informal Study Jam Eps.2',
      theme: AppThemes.getTheme(),
      routeInformationProvider: AppRouter.router.routeInformationProvider,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routerDelegate: AppRouter.router.routerDelegate,
    );
  }
}
