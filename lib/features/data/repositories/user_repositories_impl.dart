import 'package:tes_gradle/features/data/datasources/user_data_service.dart';
import 'package:tes_gradle/features/domain/repositories/user_repository.dart';

class UserRepositoriesImpl implements UserRepository {
  final UserDataService _userDataService;

  UserRepositoriesImpl(this._userDataService);

  @override
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    return await _userDataService.getUserData(userId);
  }

  @override
  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    await _userDataService.updateUser(userId, userData);
  }
}
