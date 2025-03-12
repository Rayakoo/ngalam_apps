import 'package:tes_gradle/core/usecases.dart';
import 'package:tes_gradle/features/domain/repositories/auth_repositories.dart';

class ForgotPassword implements UseCase<void, ForgotPasswordParams> {
  final AuthRepository repository;

  ForgotPassword(this.repository);

  @override
  Future<void> call(ForgotPasswordParams params) async {
    if (params.email.isEmpty) {
      throw Exception('Email cannot be empty');
    }
    await repository.sendPasswordResetEmail(params.email);
  }
}

class ForgotPasswordParams {
  final String email;

  const ForgotPasswordParams({required this.email});
}
