import 'package:tes_gradle/features/data/datasources/user_data_service.dart';
import 'package:tes_gradle/features/domain/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepositoriesImpl implements UserRepository {
  final UserDataService _userDataService;
  final FirebaseFirestore _firestore;

  UserRepositoriesImpl(this._userDataService, this._firestore);

  @override
  Future<Map<String, dynamic>?> getUserData() async {
    return await _userDataService.getUserData();
  }
}
