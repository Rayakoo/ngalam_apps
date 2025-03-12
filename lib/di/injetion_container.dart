import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:tes_gradle/features/data/datasources/firebase_auth_services.dart';
import 'package:tes_gradle/features/data/repositories/auth_repositories_impl.dart';
import 'package:tes_gradle/features/domain/repositories/auth_repositories.dart';
import 'package:tes_gradle/features/domain/usecases/forgot_password.dart';
import 'package:tes_gradle/features/domain/usecases/login_user.dart';
import 'package:tes_gradle/features/domain/usecases/register_user.dart';
import 'package:tes_gradle/features/domain/usecases/send_otp.dart';
import 'package:tes_gradle/features/domain/usecases/verify_otp.dart';
import 'package:tes_gradle/features/domain/usecases/account_exists.dart';
import 'package:tes_gradle/features/presentation/provider/auth_provider.dart';

final sl = GetIt.instance;

void setupDependencyInjection() {
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Data Layer
  sl.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());

  // Repository Layer
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Use Cases
  sl.registerLazySingleton<LoginUser>(() => LoginUser(sl()));
  sl.registerLazySingleton<RegisterUser>(() => RegisterUser(sl()));
  sl.registerLazySingleton<ForgotPassword>(() => ForgotPassword(sl()));
  sl.registerLazySingleton<SendOtp>(() => SendOtp(sl()));
  sl.registerLazySingleton<VerifyOtp>(() => VerifyOtp(sl()));
  sl.registerLazySingleton<AccountExists>(() => AccountExists(sl()));

  // Providers
  sl.registerLazySingleton<AuthProvider>(
    () => AuthProvider(
      loginUser: sl(),
      registerUser: sl(),
      forgotPassword: sl(),
      sendOtp: sl(),
      verifyOtp: sl(),
      accountExists: sl(),
      
    ),
  );
}
