import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:tes_gradle/features/data/datasources/firebase_auth_services.dart';
import 'package:tes_gradle/features/data/datasources/user_data_service.dart';
import 'package:tes_gradle/features/data/datasources/lapor_data_service.dart';
import 'package:tes_gradle/features/data/repositories/auth_repositories_impl.dart';
import 'package:tes_gradle/features/data/repositories/user_repositories_impl.dart';
import 'package:tes_gradle/features/data/repositories/lapor_repositories_impl.dart';
import 'package:tes_gradle/features/domain/repositories/auth_repositories.dart';
import 'package:tes_gradle/features/domain/repositories/user_repository.dart';
import 'package:tes_gradle/features/domain/repositories/lapor_repository.dart';
import 'package:tes_gradle/features/domain/usecases/forgot_password.dart';
import 'package:tes_gradle/features/domain/usecases/get_user_data.dart';
import 'package:tes_gradle/features/domain/usecases/login_user.dart';
import 'package:tes_gradle/features/domain/usecases/register_user.dart';
import 'package:tes_gradle/features/domain/usecases/send_otp.dart';
import 'package:tes_gradle/features/domain/usecases/verify_otp.dart';
import 'package:tes_gradle/features/domain/usecases/account_exists.dart';
import 'package:tes_gradle/features/domain/usecases/create_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/read_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/update_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/delete_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/get_user_reports.dart';
import 'package:tes_gradle/features/presentation/provider/auth_provider.dart';
import 'package:tes_gradle/features/presentation/provider/user_provider.dart';
import 'package:tes_gradle/features/presentation/provider/lapor_provider.dart';

final sl = GetIt.instance;

void setupDependencyInjection() {
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Data Layer
  sl.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
  sl.registerLazySingleton<UserDataService>(() => UserDataService());
  sl.registerLazySingleton<LaporDataService>(() => LaporDataService());

  // Repository Layer
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoriesImpl(sl<UserDataService>(), sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<LaporRepository>(
    () => LaporRepositoryImpl(sl<LaporDataService>()),
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
  sl.registerLazySingleton<CreateLaporan>(() => CreateLaporan(sl()));
  sl.registerLazySingleton<ReadLaporan>(() => ReadLaporan(sl()));
  sl.registerLazySingleton<UpdateLaporan>(() => UpdateLaporan(sl()));
  sl.registerLazySingleton<DeleteLaporan>(() => DeleteLaporan(sl()));
  sl.registerLazySingleton<GetUserReports>(() => GetUserReports(sl()));

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
  sl.registerLazySingleton<LaporProvider>(
    () => LaporProvider(
      sl<CreateLaporan>(),
      sl<ReadLaporan>(),
      sl<UpdateLaporan>(),
      sl<DeleteLaporan>(),
      sl<GetUserReports>(),
    ),
  );
}
