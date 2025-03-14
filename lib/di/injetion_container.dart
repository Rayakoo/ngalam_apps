import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:tes_gradle/features/data/datasources/firebase_auth_services.dart';
import 'package:tes_gradle/features/data/datasources/user_data_service.dart';
import 'package:tes_gradle/features/data/repositories/auth_repositories_impl.dart';
import 'package:tes_gradle/features/data/repositories/user_repositories_impl.dart';
import 'package:tes_gradle/features/domain/repositories/auth_repositories.dart';
import 'package:tes_gradle/features/domain/repositories/user_repository.dart';
import 'package:tes_gradle/features/domain/usecases/forgot_password.dart';
import 'package:tes_gradle/features/domain/usecases/get_user_data.dart';
import 'package:tes_gradle/features/domain/usecases/login_user.dart';
import 'package:tes_gradle/features/domain/usecases/register_user.dart';
import 'package:tes_gradle/features/domain/usecases/send_otp.dart';
import 'package:tes_gradle/features/domain/usecases/verify_otp.dart';
import 'package:tes_gradle/features/domain/usecases/account_exists.dart';
import 'package:tes_gradle/features/presentation/provider/auth_provider.dart';
import 'package:tes_gradle/features/presentation/provider/user_provider.dart';

final sl = GetIt.instance;

void setupDependencyInjection() {
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Data Layer
  sl.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
  sl.registerLazySingleton<UserDataService>(() => UserDataService());

  // Repository Layer
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoriesImpl(sl<UserDataService>(), sl<FirebaseFirestore>()),
  );

  // Use Cases
  sl.registerLazySingleton<LoginUser>(() => LoginUser(sl()));
  sl.registerLazySingleton<RegisterUser>(() => RegisterUser(sl()));
  sl.registerLazySingleton<ForgotPassword>(() => ForgotPassword(sl()));
  sl.registerLazySingleton<SendOtp>(() => SendOtp(sl()));
  sl.registerLazySingleton<VerifyOtp>(() => VerifyOtp(sl()));
  sl.registerLazySingleton<AccountExists>(() => AccountExists(sl()));
  sl.registerLazySingleton<GetUserData>(
    () => GetUserData(sl<UserRepository>()),
  );

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
  sl.registerLazySingleton<UserProvider>(
    () => UserProvider(sl<GetUserData>(), sl<FirebaseFirestore>()),
  );
}
