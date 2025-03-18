import 'package:flutter/material.dart';
import 'package:tes_gradle/features/data/datasources/user_data_service.dart';
import 'package:tes_gradle/features/data/repositories/user_repositories_impl.dart';
import 'package:tes_gradle/features/domain/usecases/get_user_data.dart';
import 'package:tes_gradle/features/domain/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  final GetUserData _getUserData;
  final UserRepository _userRepository;

  UserProvider(this._getUserData, FirebaseFirestore firestore)
    : _userRepository = UserRepositoriesImpl(UserDataService(), firestore);

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchUserData() async {
    _isLoading = true;
    notifyListeners();
    print('Fetching user data...'); // Debug print statement

    _userData = await _getUserData.call();
    print('Fetched user data: $_userData'); // Debug print statement

    _isLoading = false;
    notifyListeners();
  }

  String get userRole => _userData?['role'] ?? 'user'; // Add this line
}
