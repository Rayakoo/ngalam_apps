import 'package:tes_gradle/core/usecases.dart';
import 'package:tes_gradle/features/domain/repositories/auth_repositories.dart';

class VerifyOtp implements UseCase<void, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtp(this.repository);

  @override
  Future<void> call(VerifyOtpParams params) async {
    if (params.email.isEmpty || params.otp.isEmpty) {
      throw Exception('Email and OTP cannot be empty');
    }
    await repository.verifyOtp(params.email, params.otp);
  }
}

class VerifyOtpParams {
  final String email;
  final String otp;

  const VerifyOtpParams({required this.email, required this.otp});
}
