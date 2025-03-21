import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tes_gradle/features/domain/entities/user.dart';
import 'package:tes_gradle/features/data/models/user_model.dart';

class UserDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc.data();
      }
    } catch (e) {
      print('Error getting user data: $e');
    }
    return null;
  }

  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').doc(userId).update(userData);
      print('User data updated successfully.');
    } catch (e) {
      print('Error updating user data: $e');
    }
  }
}
