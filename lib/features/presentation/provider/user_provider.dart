import 'package:flutter/material.dart';
import 'package:tes_gradle/features/data/datasources/user_data_service.dart';
import 'package:tes_gradle/features/data/repositories/user_repositories_impl.dart';
import 'package:tes_gradle/features/domain/usecases/get_user_data.dart';
import 'package:tes_gradle/features/domain/usecases/update_user.dart'; // Import UpdateUser use case
import 'package:tes_gradle/features/domain/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  final GetUserData _getUserData;
  final UpdateUser _updateUser; // Add UpdateUser use case
  final UserRepository _userRepository;

  UserProvider(
    this._getUserData,
    this._updateUser, // Add UpdateUser to constructor
    FirebaseFirestore firestore,
  ) : _userRepository = UserRepositoriesImpl(UserDataService());

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchUserData() async {
    _isLoading = true;
    notifyListeners();
    print('Fetching user data...'); // Debug print statement

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userData = await _getUserData.call(user.uid);
      print('Fetched user data: $_userData'); // Debug print statement
      if (_userData != null) {
        _userData!['id'] = user.uid; // Ensure the id field is set
        print('User ID set to: ${_userData!['id']}'); // Debug print statement
      }
    } else {
      print('No user logged in.');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUser(String id, Map<String, dynamic> userData) async {
    _isLoading = true;
    notifyListeners();
    print(
      'Updating user with ID: $id and data: $userData',
    ); // Debug print statement

    await _updateUser.call(id, userData);
    print('User data updated'); // Debug print statement

    _isLoading = false;
    notifyListeners();
  }

  String get userRole => _userData?['role'] ?? 'user';
}
