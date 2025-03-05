
import 'package:tes_gradle/core/usecases.dart';

import 'package:tes_gradle/features/domain/entities/user.dart';
import 'package:tes_gradle/features/domain/repositories/auth_repositories.dart';

class RegisterUser implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUser(this.repository);

  @override
  Future<UserEntity> call(RegisterParams params) async {
    return await repository.register(params.email, params.password, params.name, params.nomer_induk_kependudukan);
  }
}

class RegisterParams {
  final String email;
  final String password;
  final String name;
  final String nomer_induk_kependudukan;

  RegisterParams({required this.email, required this.password, required this.name, required this.nomer_induk_kependudukan});
}