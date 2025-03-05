import 'package:flutter/material.dart';
import 'package:tes_gradle/features/domain/entities/user.dart';
import 'package:tes_gradle/features/domain/usecases/login_user.dart';
import 'package:tes_gradle/features/domain/usecases/register_user.dart';
import 'package:tes_gradle/main.dart';

class AuthProvider with ChangeNotifier {
  final LoginUser loginUser;
  final RegisterUser registerUser;

  String? _nomer_induk_kependudukan;
  String? _name;
  String? _email;

  AuthProvider({required this.loginUser, required this.registerUser});

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<UserEntity> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    _setLoading(true);
    _clearError();
    try {
      final user = await loginUser(
        LoginParams(email: email, password: password),
      );
      _nomer_induk_kependudukan = user.nomer_induk_kependudukan;
      _name = user.name;
      _email = user.email;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyHomePage()),
      );
      return user;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register(
    String nomerIndukKependudukan,
    String name,
    String email,
    String password,
  ) async {
    _setLoading(true);
    _clearError();
    try {
      await registerUser(
        RegisterParams(
          nomer_induk_kependudukan: nomerIndukKependudukan,
          name: name,
          email: email,
          password: password,
        ),
      );
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
