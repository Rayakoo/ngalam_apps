import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tes_gradle/features/data/models/komentar_model.dart';

class KomentarDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createKomentar(KomentarModel komentar) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Get user data from Firestore
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) {
        throw Exception('User data not found');
      }
      final userName = userDoc.data()?['name'] ?? 'Anonymous';

      final komentarData = komentar.toJson();
      komentarData['namaPengirim'] = userName; // Use user name instead of UID

      final komentarRef = await _firestore
          .collection('komentar')
          .add(komentarData);
      final komentarId = komentarRef.id;

      await _firestore.collection('laporan').doc(komentar.laporanId).update({
        'komentar': FieldValue.arrayUnion([komentarId]),
      });
      print('Komentar created successfully.');
    } catch (e) {
      print('Error creating komentar: $e');
      throw Exception('Error creating komentar: $e');
    }
  }

  Future<List<KomentarModel>> getKomentarByLaporanId(String laporanId) async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore
              .collection('komentar')
              .where('laporanId', isEqualTo: laporanId)
              .get();
      return querySnapshot.docs
          .map(
            (doc) => KomentarModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      print('Error getting komentar: $e');
      throw Exception('Error getting komentar: $e');
    }
  }
}
