import 'package:tes_gradle/core/usecases.dart';

import 'package:tes_gradle/features/domain/entities/user.dart';
import 'package:tes_gradle/features/domain/repositories/auth_repositories.dart';

class LoginUser implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUser(this.repository);

  @override
  Future<UserEntity> call(LoginParams params) async {
    if (params.email.isEmpty || params.password.isEmpty) {
      throw Exception('Email and Password cannot be empty');
    }
    return repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}
