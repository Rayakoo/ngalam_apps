import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:tes_gradle/features/data/models/user_model.dart';

class FirebaseAuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  FirebaseAuthService({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  Future<UserModel> register(String nomerIndukKependudukan, String name, String email, String password) async {
    // Pengecekan untuk memastikan nomerIndukKependudukan tidak kosong
    if (nomerIndukKependudukan.isEmpty) {
      throw Exception('NIK tidak boleh kosong');
    }

    // Mengatur name default sesuai dengan nama email jika name tidak diisi
    if (name.isEmpty) {
      name = email.split('@')[0];
    }

    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        return UserModel(
          nomer_induk_kependudukan: nomerIndukKependudukan,
          name: name,
          email: firebaseUser.email ?? '',
          password: password,
        );
      } else {
        throw Exception('User registration failed');
      }
    } catch (e) {
      throw Exception('Error registering user: $e');
    }
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        return UserModel(
          nomer_induk_kependudukan: 'default_nik', // atau nilai yang sesuai
          name: 'default_name', // atau nilai yang sesuai
          email: firebaseUser.email ?? '',
          password: password,
        );
      } else {
        throw Exception('User login failed');
      }
    } catch (e) {
      throw Exception('Error logging in user: $e');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}