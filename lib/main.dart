import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tes_gradle/features/presentation/screens/home_screen.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'features/presentation/screens/login_screen.dart';
import 'features/presentation/screens/register_screen.dart';
import 'features/presentation/provider/auth_provider.dart';
import 'features/presentation/screens/welcome_page.dart';
import 'di/injetion_container.dart' as di;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

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
              (_) => AuthProvider(loginUser: di.sl(), registerUser: di.sl()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Informal Study Jam Eps.2',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return StreamBuilder<firebase_auth.User?>(
              stream: firebase_auth.FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return const Scaffold(
                    body: Center(child: Text('Something went wrong!')),
                  );
                }
                final user = snapshot.data;
                if (user != null) {
                  return const HomeScreen();
                } else {
                  return const WelcomePage();
                }
              },
            );
          },
        ),
        routes: {'/register': (context) => const RegisterScreen()},
      ),
    );
  }
}
