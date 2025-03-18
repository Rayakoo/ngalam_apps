import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tes_gradle/features/data/models/user_model.dart';

class FirebaseAuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  FirebaseAuthService({firebase_auth.FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance {
    _firebaseAuth.setLanguageCode('en');
  }

  Future<UserModel> register(
    String email,
    String password,
    String name,
    String nomerIndukKependudukan, {
    String photoProfile =
        'https://th.bing.com/th/id/OIP.hGSCbXlcOjL_9mmzerqAbQHaHa?w=182&h=182&c=7&r=0&o=5&dpr=1.3&pid=1.7',
    String address = '-',
    String role = 'user',
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        final userModel = UserModel(
          nomer_induk_kependudukan: nomerIndukKependudukan,
          name: name,
          email: firebaseUser.email ?? '',
          password: password,
          photoProfile: photoProfile,
          address: address,
          role: role,
        );

        // Save user data to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set(userModel.toJson());

        return userModel;
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
        final userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(firebaseUser.uid)
                .get();
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          return UserModel(
            nomer_induk_kependudukan:
                userData['nomer_induk_kependudukan'] ?? 'default_nik',
            name: userData['name'] ?? 'default_name',
            email: firebaseUser.email ?? '',
            password: password,
            photoProfile:
                userData['photoProfile'] ??
                'https://th.bing.com/th/id/OIP.hGSCbXlcOjL_9mmzerqAbQHaHa?w=182&h=182&c=7&r=0&o=5&dpr=1.3&pid=1.7',
            address: userData['address'] ?? '-',
            role: userData['role'] ?? 'user',
          );
        } else {
          throw Exception('User data not found');
        }
      } else {
        throw Exception('User login failed');
      }
    } catch (e) {
      throw Exception('Error logging in user: $e');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Invalid email address.');
      } else {
        throw Exception('Error sending password reset email: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> sendOtp(String email) async {
    try {
      await _firebaseAuth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: firebase_auth.ActionCodeSettings(
          url:
              'https://your-app.page.link/finishSignUp', // Replace with your actual Dynamic Link domain and path
          handleCodeInApp: true,
          iOSBundleId: 'com.example.ios',
          androidPackageName: 'com.example.android',
          androidInstallApp: true,
          androidMinimumVersion: '12',
        ),
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Invalid email address.');
      } else {
        throw Exception('Error sending OTP: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    try {
      final signInMethods = await _firebaseAuth.fetchSignInMethodsForEmail(
        email,
      );
      if (signInMethods.contains('emailLink')) {
        await _firebaseAuth.signInWithEmailLink(email: email, emailLink: otp);
      } else {
        throw Exception('Invalid OTP');
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception('Error verifying OTP: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> accountExists(String email) async {
    try {
      print('Checking account existence for email: $email');
      final signInMethods = await _firebaseAuth.fetchSignInMethodsForEmail(
        email,
      );
      print('Sign-in methods: $signInMethods');
      return signInMethods.isNotEmpty;
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('Error checking account existence: ${e.message}');
      throw Exception('Error checking account existence: ${e.message}');
    } catch (e) {
      print('An unexpected error occurred: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
