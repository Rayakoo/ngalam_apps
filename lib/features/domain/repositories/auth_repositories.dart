
import 'package:tes_gradle/features/domain/entities/user.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String email, String password, String name, String nomer_induk_kependudukan);
}