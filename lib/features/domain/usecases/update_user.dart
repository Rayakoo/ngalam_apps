import 'package:tes_gradle/features/domain/repositories/user_repository.dart';

class UpdateUser {
  final UserRepository repository;

  UpdateUser(this.repository);

  Future<void> call(String userId, Map<String, dynamic> userData) async {
    await repository.updateUser(userId, userData);
  }
}
