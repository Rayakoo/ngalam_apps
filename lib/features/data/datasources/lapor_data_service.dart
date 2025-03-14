import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tes_gradle/features/data/models/laporan_model.dart';

class LaporDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createLaporan(LaporanModel laporan) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final reportData = laporan.toJson();
      reportData['uid'] = userId;
      reportData['timeStamp'] = FieldValue.serverTimestamp();

      final reportRef = await _firestore.collection('laporan').add(reportData);
      final reportId = reportRef.id;

      await _firestore.collection('users').doc(userId).update({
        'reports': FieldValue.arrayUnion([reportId]),
      });
    } catch (e) {
      throw Exception('Error creating laporan: $e');
    }
  }

  Future<LaporanModel?> readLaporan(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('laporan').doc(id).get();
      if (doc.exists) {
        return LaporanModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Error reading laporan: $e');
    }
  }

  Future<void> updateLaporan(String id, LaporanModel laporan) async {
    try {
      await _firestore.collection('laporan').doc(id).update(laporan.toJson());
    } catch (e) {
      throw Exception('Error updating laporan: $e');
    }
  }

  Future<void> deleteLaporan(String id) async {
    try {
      await _firestore.collection('laporan').doc(id).delete();
    } catch (e) {
      throw Exception('Error deleting laporan: $e');
    }
  }

  Future<List<LaporanModel>> getUserReports(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        List<String> reportIds = List<String>.from(
          userDoc.get('reports') ?? [],
        );
        List<LaporanModel> reports = [];
        for (String reportId in reportIds) {
          DocumentSnapshot reportDoc =
              await _firestore.collection('laporan').doc(reportId).get();
          if (reportDoc.exists) {
            reports.add(
              LaporanModel.fromJson(reportDoc.data() as Map<String, dynamic>),
            );
          }
        }
        return reports;
      }
      return [];
    } catch (e) {
      throw Exception('Error getting user reports: $e');
    }
  }
}
