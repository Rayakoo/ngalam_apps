import 'package:tes_gradle/core/usecases.dart';
import 'package:tes_gradle/features/domain/repositories/auth_repositories.dart';

class AccountExists implements UseCase<bool, AccountExistsParams> {
  final AuthRepository repository;

  AccountExists(this.repository);

  @override
  Future<bool> call(AccountExistsParams params) async {
    if (params.email.isEmpty) {
      throw Exception('Email cannot be empty');
    }
    print('Checking account existence for email: ${params.email}');
    return await repository.accountExists(params.email);
  }
}

class AccountExistsParams {
  final String email;

  const AccountExistsParams({required this.email});
}
