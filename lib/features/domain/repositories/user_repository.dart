abstract class UserRepository {
  Future<Map<String, dynamic>?> getUserData(String userId);
  Future<void> updateUser(String userId, Map<String, dynamic> userData);
}
