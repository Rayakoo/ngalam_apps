import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tes_gradle/features/presentation/router/approuter.dart';
import 'package:tes_gradle/features/presentation/style/theme.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'features/presentation/provider/auth_provider.dart';
import 'features/presentation/screens/welcome_page.dart';
import 'di/injetion_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  di.setupDependencyInjection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Informal Study Jam Eps.2',
        theme: AppThemes.getTheme(),
        routeInformationProvider: AppRouter.router.routeInformationProvider,
        routeInformationParser: AppRouter.router.routeInformationParser,
        routerDelegate: AppRouter.router.routerDelegate,
      ),
    );
  }
}
