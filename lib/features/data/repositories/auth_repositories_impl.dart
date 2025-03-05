
import 'package:tes_gradle/features/data/datasources/firebase_auth_services.dart';

import 'package:tes_gradle/features/domain/entities/user.dart';
import 'package:tes_gradle/features/domain/repositories/auth_repositories.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService firebaseAuthService;

  AuthRepositoryImpl(this.firebaseAuthService);

  @override
  Future<UserEntity> login(String email, String password) async {
    final user = await firebaseAuthService.login(email, password);
    return UserEntity(password: user.password, email: user.email, name: user.name, nomer_induk_kependudukan: user.nomer_induk_kependudukan);
  }

  @override
  Future<UserEntity> register(String email, String password, String name, String nomer_induk_kependudukan) async {
    final user = await firebaseAuthService.register(email, password, name, nomer_induk_kependudukan);
    return UserEntity(password: user.password, email: user.email, name: user.name, nomer_induk_kependudukan: user.nomer_induk_kependudukan);
  }
}