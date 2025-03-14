import 'package:tes_gradle/features/domain/repositories/user_repository.dart';

class GetUserData {
  final UserRepository repository;

  GetUserData(this.repository);

  Future<Map<String, dynamic>?> call() async {
    return await repository.getUserData();
  }
}
