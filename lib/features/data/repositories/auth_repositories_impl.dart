import 'package:tes_gradle/features/data/datasources/firebase_auth_services.dart';
import 'package:tes_gradle/features/domain/entities/user.dart';
import 'package:tes_gradle/features/domain/repositories/auth_repositories.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService firebaseAuthService;

  AuthRepositoryImpl(this.firebaseAuthService);

  @override
  Future<UserEntity> login(String email, String password) async {
    final user = await firebaseAuthService.login(email, password);
    return UserEntity(
      password: user.password,
      email: user.email,
      name: user.name,
      nomer_induk_kependudukan: user.nomer_induk_kependudukan,
      photoProfile: user.photoProfile,
      address: user.address,
    );
  }

  @override
  Future<UserEntity> register(
    String email,
    String password,
    String name,
    String nomer_induk_kependudukan, {
    String photoProfile =
        'https://th.bing.com/th/id/OIP.hGSCbXlcOjL_9mmzerqAbQHaHa?w=182&h=182&c=7&r=0&o=5&dpr=1.3&pid=1.7',
    String address = '-',
  }) async {
    final user = await firebaseAuthService.register(
      email,
      password,
      name,
      nomer_induk_kependudukan,
      photoProfile: photoProfile,
      address: address,
    );
    return UserEntity(
      password: user.password,
      email: user.email,
      name: user.name,
      nomer_induk_kependudukan: user.nomer_induk_kependudukan,
      photoProfile: user.photoProfile,
      address: user.address,
    );
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await firebaseAuthService.sendPasswordResetEmail(email);
  }

  @override
  Future<void> sendOtp(String email) async {
    await firebaseAuthService.sendOtp(email);
  }

  @override
  Future<void> verifyOtp(String email, String otp) async {
    await firebaseAuthService.verifyOtp(email, otp);
  }

  @override
  Future<bool> accountExists(String email) async {
    print('Repository: Checking account existence for email: $email');
    final exists = await firebaseAuthService.accountExists(email);
    print('Repository: Account exists: $exists');
    return exists;
  }
}
