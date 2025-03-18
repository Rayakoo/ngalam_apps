import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tes_gradle/features/domain/entities/user.dart';
import 'package:tes_gradle/features/domain/usecases/forgot_password.dart';
import 'package:tes_gradle/features/domain/usecases/login_user.dart';
import 'package:tes_gradle/features/domain/usecases/register_user.dart';
import 'package:tes_gradle/features/domain/usecases/send_otp.dart';
import 'package:tes_gradle/features/domain/usecases/verify_otp.dart';
import 'package:tes_gradle/features/domain/usecases/account_exists.dart';
import 'package:tes_gradle/features/presentation/router/approutes.dart';
import 'package:tes_gradle/features/presentation/screens/beranda/home_screen.dart';
import 'package:tes_gradle/main.dart';

class AuthProvider with ChangeNotifier {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final ForgotPassword forgotPassword;
  final SendOtp sendOtp;
  final VerifyOtp verifyOtp;
  final AccountExists accountExists;

  String? _nomer_induk_kependudukan;
  String? _name;
  String? _email;
  String? _photoProfile;
  String? _address;
  String? _role;

  AuthProvider({
    required this.loginUser,
    required this.registerUser,
    required this.forgotPassword,
    required this.sendOtp,
    required this.verifyOtp,
    required this.accountExists,
  });

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
      _photoProfile = user.photoProfile;
      _address = user.address;
      _role = user.role;
      context.go(AppRoutes.navbar);
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _setError('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _setError('Wrong password provided.');
      } else {
        _setError('Error: ${e.message}');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage ?? 'An error occurred')),
      );
      rethrow;
    } catch (e) {
      _setError(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage ?? 'An error occurred')),
      );
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

  Future<void> forgotPasswordEmail(String email, BuildContext context) async {
    _setLoading(true);
    _clearError();
    try {
      print('Checking if account exists for email: $email');
      // Check if the email exists in Firebase Authentication
      final exists = await accountExists(AccountExistsParams(email: email));
      print('Account exists: $exists');
      if (!exists) {
        throw Exception('No user found for that email.');
      }

      // Send password reset email
      await forgotPassword(ForgotPasswordParams(email: email));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent! ')),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else {
        throw Exception('Error sending password reset email: ${e.message}');
      }
    } on Exception catch (e) {
      // Tampilkan pesan error jika terjadi kesalahan
      _setError(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage ?? 'An error occurred')),
      );
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendOtpEmail(String email, BuildContext context) async {
    _setLoading(true);
    _clearError();
    try {
      await sendOtp(SendOtpParams(email: email));
      // Jika berhasil, tampilkan pesan sukses
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('OTP sent to email!')));
      context.go(AppRoutes.verifyOtpEmail, extra: email);
    } on Exception catch (e) {
      // Tampilkan pesan error jika terjadi kesalahan
      _setError(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage ?? 'An error occurred')),
      );
    } finally {
      _setLoading(false);
    }
  }

  Future<void> verifyOtpEmail(
    String email,
    String otp,
    BuildContext context,
  ) async {
    _setLoading(true);
    _clearError();
    try {
      await verifyOtp(VerifyOtpParams(email: email, otp: otp));
      // Jika berhasil, tampilkan pesan sukses
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('OTP verified!')));
      context.go(AppRoutes.resetPassword, extra: email);
    } on Exception catch (e) {
      // Tampilkan pesan error jika terjadi kesalahan
      _setError(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage ?? 'An error occurred')),
      );
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
