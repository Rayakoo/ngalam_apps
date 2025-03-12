import 'package:tes_gradle/core/usecases.dart';
import 'package:tes_gradle/features/domain/repositories/auth_repositories.dart';

class SendOtp implements UseCase<void, SendOtpParams> {
  final AuthRepository repository;

  SendOtp(this.repository);

  @override
  Future<void> call(SendOtpParams params) async {
    if (params.email.isEmpty) {
      throw Exception('Email cannot be empty');
    }
    await repository.sendOtp(params.email);
  }
}

class SendOtpParams {
  final String email;

  const SendOtpParams({required this.email});
}
