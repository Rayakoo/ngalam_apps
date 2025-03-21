import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:tes_gradle/features/data/datasources/firebase_auth_services.dart';
import 'package:tes_gradle/features/data/datasources/user_data_service.dart';
import 'package:tes_gradle/features/data/datasources/lapor_data_service.dart';
import 'package:tes_gradle/features/data/datasources/komentar_data_service.dart';
import 'package:tes_gradle/features/data/repositories/auth_repositories_impl.dart';
import 'package:tes_gradle/features/data/repositories/user_repositories_impl.dart';
import 'package:tes_gradle/features/data/repositories/lapor_repositories_impl.dart';
import 'package:tes_gradle/features/domain/repositories/auth_repositories.dart';
import 'package:tes_gradle/features/domain/repositories/user_repository.dart';
import 'package:tes_gradle/features/domain/repositories/lapor_repository.dart';
import 'package:tes_gradle/features/domain/usecases/forgot_password.dart';
import 'package:tes_gradle/features/domain/usecases/get_user_data.dart';
import 'package:tes_gradle/features/domain/usecases/update_user.dart';
import 'package:tes_gradle/features/domain/usecases/login_user.dart';
import 'package:tes_gradle/features/domain/usecases/register_user.dart';
import 'package:tes_gradle/features/domain/usecases/account_exists.dart';
import 'package:tes_gradle/features/domain/usecases/create_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/read_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/update_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/delete_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/get_user_reports.dart';
import 'package:tes_gradle/features/domain/usecases/get_all_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/create_komentar.dart';
import 'package:tes_gradle/features/domain/usecases/get_komentar_by_laporan_id.dart';
import 'package:tes_gradle/features/presentation/provider/auth_provider.dart';
import 'package:tes_gradle/features/presentation/provider/user_provider.dart';
import 'package:tes_gradle/features/presentation/provider/lapor_provider.dart';
import 'package:tes_gradle/features/data/datasources/status_history_data_service.dart';
import 'package:tes_gradle/features/data/repositories/status_history_repository_impl.dart';
import 'package:tes_gradle/features/domain/repositories/status_history_repository.dart';
import 'package:tes_gradle/features/domain/usecases/status_history_usecases.dart';
import 'package:tes_gradle/features/presentation/provider/status_history_provider.dart';
import 'package:tes_gradle/features/data/datasources/notification_data_service.dart';
import 'package:tes_gradle/features/data/repositories/notification_repository_impl.dart';
import 'package:tes_gradle/features/domain/repositories/notification_repository.dart';
import 'package:tes_gradle/features/domain/usecases/notification_usecases.dart';
import 'package:tes_gradle/features/presentation/provider/notification_provider.dart';
import 'package:tes_gradle/features/data/datasources/cctv_data_service.dart';
import 'package:tes_gradle/features/data/repositories/cctv_repository_impl.dart';
import 'package:tes_gradle/features/domain/repositories/cctv_repository.dart';
import 'package:tes_gradle/features/domain/usecases/get_all_cctvs.dart';
import 'package:tes_gradle/features/domain/usecases/add_cctv.dart';
import 'package:tes_gradle/features/presentation/provider/cctv_provider.dart';
import 'package:tes_gradle/features/data/datasources/berita_data_service.dart';
import 'package:tes_gradle/features/data/repositories/berita_repository_impl.dart';
import 'package:tes_gradle/features/domain/repositories/berita_repository.dart';
import 'package:tes_gradle/features/domain/usecases/berita_usecases.dart';

final sl = GetIt.instance;

void setupDependencyInjection() {
  // Firebase
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Data Layer
  sl.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());
  sl.registerLazySingleton<UserDataService>(() => UserDataService());
  sl.registerLazySingleton<LaporDataService>(() => LaporDataService());
  sl.registerLazySingleton<KomentarDataService>(() => KomentarDataService());
  sl.registerLazySingleton<StatusHistoryDataService>(
    () => StatusHistoryDataService(),
  );
  sl.registerLazySingleton<NotificationDataService>(
    () => NotificationDataService(),
  );
  sl.registerLazySingleton<CCTVDataService>(() => CCTVDataService());
  sl.registerLazySingleton<BeritaDataService>(
    () => BeritaDataService(FirebaseFirestore.instance),
  );

  // Repository Layer
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoriesImpl(sl<UserDataService>()),
  );
  sl.registerLazySingleton<LaporRepository>(
    () =>
        LaporRepositoryImpl(sl<LaporDataService>(), sl<KomentarDataService>()),
  );
  sl.registerLazySingleton<StatusHistoryRepository>(
    () => StatusHistoryRepositoryImpl(sl<StatusHistoryDataService>()),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<CCTVRepository>(() => CCTVRepositoryImpl(sl()));
  sl.registerLazySingleton<BeritaRepository>(() => BeritaRepositoryImpl(sl()));

  // Use Cases
  sl.registerLazySingleton<LoginUser>(() => LoginUser(sl()));
  sl.registerLazySingleton<RegisterUser>(() => RegisterUser(sl()));
  sl.registerLazySingleton<ForgotPassword>(() => ForgotPassword(sl()));
  sl.registerLazySingleton<AccountExists>(() => AccountExists(sl()));
  sl.registerLazySingleton<GetUserData>(
    () => GetUserData(sl<UserRepository>()),
  );
  sl.registerLazySingleton<UpdateUser>(
    () => UpdateUser(sl<UserRepository>()),
  ); // Register UpdateUser use case
  sl.registerLazySingleton<CreateLaporan>(() => CreateLaporan(sl()));
  sl.registerLazySingleton<ReadLaporan>(() => ReadLaporan(sl()));
  sl.registerLazySingleton<UpdateLaporan>(() => UpdateLaporan(sl()));
  sl.registerLazySingleton<DeleteLaporan>(() => DeleteLaporan(sl()));
  sl.registerLazySingleton<GetUserReports>(() => GetUserReports(sl()));
  sl.registerLazySingleton<GetAllLaporan>(() => GetAllLaporan(sl()));
  sl.registerLazySingleton<CreateKomentar>(() => CreateKomentar(sl()));
  sl.registerLazySingleton<GetKomentarByLaporanId>(
    () => GetKomentarByLaporanId(sl()),
  );
  sl.registerLazySingleton<CreateStatusHistory>(
    () => CreateStatusHistory(sl()),
  );
  sl.registerLazySingleton<ReadStatusHistory>(() => ReadStatusHistory(sl()));
  sl.registerLazySingleton<UpdateStatusHistory>(
    () => UpdateStatusHistory(sl()),
  );
  sl.registerLazySingleton<DeleteStatusHistory>(
    () => DeleteStatusHistory(sl()),
  );
  sl.registerLazySingleton<GetStatusHistoryByLaporanId>(
    () => GetStatusHistoryByLaporanId(sl()),
  );
  sl.registerLazySingleton<CreateNotification>(() => CreateNotification(sl()));
  sl.registerLazySingleton<GetNotificationsByUserId>(
    () => GetNotificationsByUserId(sl()),
  );
  sl.registerLazySingleton<GetAllCCTVs>(() => GetAllCCTVs(sl()));
  sl.registerLazySingleton<AddCCTV>(() => AddCCTV(sl()));
  sl.registerLazySingleton<FetchAllBerita>(() => FetchAllBerita(sl()));
  sl.registerLazySingleton<CreateBerita>(() => CreateBerita(sl()));
  sl.registerLazySingleton<UpdateBerita>(() => UpdateBerita(sl()));
  sl.registerLazySingleton<DeleteBerita>(() => DeleteBerita(sl()));

  // Providers
  sl.registerLazySingleton<AuthProvider>(
    () => AuthProvider(
      loginUser: sl(),
      registerUser: sl(),
      forgotPassword: sl(),
      accountExists: sl(),
    ),
  );
  sl.registerLazySingleton<UserProvider>(
    () => UserProvider(
      sl<GetUserData>(),
      sl<UpdateUser>(), // Pass the UpdateUser use case
      sl<FirebaseFirestore>(),
    ),
  );
  sl.registerLazySingleton<LaporProvider>(
    () => LaporProvider(
      sl<CreateLaporan>(),
      sl<ReadLaporan>(),
      sl<UpdateLaporan>(),
      sl<DeleteLaporan>(),
      sl<GetUserReports>(),
      sl<GetAllLaporan>(),
      sl<CreateKomentar>(),
      sl<GetKomentarByLaporanId>(),
      sl<CreateStatusHistory>(),
    ),
  );
  sl.registerLazySingleton<StatusHistoryProvider>(
    () => StatusHistoryProvider(
      sl<CreateStatusHistory>(),
      sl<ReadStatusHistory>(),
      sl<UpdateStatusHistory>(),
      sl<DeleteStatusHistory>(),
      sl<GetStatusHistoryByLaporanId>(),
    ),
  );
  sl.registerFactory(() => NotificationProvider(sl(), sl()));
  sl.registerFactory(() => CCTVProvider(sl(), sl()));
}
