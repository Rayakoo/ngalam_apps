import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tes_gradle/features/domain/usecases/create_komentar.dart';
import 'package:tes_gradle/features/domain/usecases/create_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/delete_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/get_all_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/get_komentar_by_laporan_id.dart';
import 'package:tes_gradle/features/domain/usecases/get_user_data.dart';
import 'package:tes_gradle/features/domain/usecases/get_user_reports.dart';
import 'package:tes_gradle/features/domain/usecases/read_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/update_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/status_history_usecases.dart';
import 'package:tes_gradle/features/domain/usecases/update_user.dart';
import 'package:tes_gradle/features/presentation/router/approuter.dart';
import 'package:tes_gradle/features/presentation/style/theme.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'features/presentation/provider/auth_provider.dart';
import 'features/presentation/provider/user_provider.dart';
import 'features/presentation/provider/lapor_provider.dart';
import 'features/presentation/provider/status_history_provider.dart';
import 'features/presentation/screens/onboarding/welcome_page_child1.dart';
import 'features/presentation/screens/beranda/home_screen.dart';
import 'di/injetion_container.dart' as di;
import 'dart:io';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tes_gradle/features/presentation/provider/notification_provider.dart';
import 'package:tes_gradle/features/presentation/provider/cctv_provider.dart';
import 'package:flutter/services.dart';
import 'package:tes_gradle/features/presentation/provider/berita_provider.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}


Future<void> uploadImage(String filePath) async {
  final url = Uri.parse('https://api.cloudinary.com/v1_1/dpbw0ztwl/upload');

  // Buat request upload
  final request = http.MultipartRequest('POST', url)
    ..fields['upload_preset'] = 'a5tgii2s' // Ganti dengan Upload Preset kamu
    ..files.add(
      await http.MultipartFile.fromPath(
        'file',
        filePath,
        contentType: MediaType('image', 'jpeg'), // Pastikan format file benar
      ),
    );

  // Kirim request dan tangani respons
  final response = await request.send();
  if (response.statusCode == 200) {
    final responseData = await response.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);
    final jsonMap = jsonDecode(responseString);
    print('Upload successful: ${jsonMap['secure_url']}'); // URL file berhasil diunggah
  } else {
    print('Upload failed: ${response.statusCode}');
  }
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  // Initialize Cloudinary
  CloudinaryContext.cloudinary = Cloudinary.fromCloudName(
    cloudName: 'dpbw0ztwl',
    
  );

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
  await initializeDateFormatting('id_ID', null);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => UserProvider(
                di.sl<GetUserData>(),
                di.sl<UpdateUser>(), // Pass the UpdateUser use case
                di.sl<FirebaseFirestore>(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => AuthProvider(
                loginUser: di.sl(),
                registerUser: di.sl(),
                forgotPassword: di.sl(),
                accountExists: di.sl(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => LaporProvider(
                di.sl<CreateLaporan>(),
                di.sl<ReadLaporan>(),
                di.sl<UpdateLaporan>(),
                di.sl<DeleteLaporan>(),
                di.sl<GetUserReports>(),
                di.sl<GetAllLaporan>(),
                di.sl<CreateKomentar>(),
                di.sl<GetKomentarByLaporanId>(),
                di.sl<CreateStatusHistory>(), // Add this line
              ),
        ),
        ChangeNotifierProvider(
          create:
              (_) => StatusHistoryProvider(
                di.sl<CreateStatusHistory>(),
                di.sl<ReadStatusHistory>(),
                di.sl<UpdateStatusHistory>(),
                di.sl<DeleteStatusHistory>(),
                di.sl<GetStatusHistoryByLaporanId>(),
              ),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(di.sl(), di.sl()),
        ),
        ChangeNotifierProvider(create: (_) => CCTVProvider(di.sl(), di.sl())),
        ChangeNotifierProvider(
          create:
              (_) => BeritaProvider(
                fetchAllBerita: di.sl(),
                createBerita: di.sl(),
                updateBerita: di.sl(),
                deleteBerita: di.sl(),
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
