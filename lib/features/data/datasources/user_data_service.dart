import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tes_gradle/features/domain/entities/user.dart';

class UserDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        print(
          'Getting user data for UID: ${user.uid}',
        ); // Debug print statement
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          print('User data found: ${userDoc.data()}'); // Debug print statement
          return userDoc.data() as Map<String, dynamic>;
        } else {
          print(
            'No user data found for UID: ${user.uid}',
          ); // Debug print statement
        }
      } else {
        print('No current user logged in'); // Debug print statement
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }
}
