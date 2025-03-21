import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tes_gradle/features/data/models/laporan_model.dart';

class LaporDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<LaporanModel> createLaporan(LaporanModel laporan) async {
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
      print('Laporan created successfully.');

      return LaporanModel.fromJson(
        reportData,
        reportId,
      ); // Return LaporanModel with ID
    } catch (e) {
      print('Error creating laporan: $e');
      throw Exception('Error creating laporan: $e');
    }
  }

  Future<LaporanModel?> readLaporan(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('laporan').doc(id).get();
      if (doc.exists) {
        return LaporanModel.fromJson(
          doc.data() as Map<String, dynamic>,
          id,
        ); // Add id here
      }
      return null;
    } catch (e) {
      print('Error reading laporan: $e');
      throw Exception('Error reading laporan: $e');
    }
  }

  Future<void> updateLaporan(String id, LaporanModel laporan) async {
    try {
      // Ensure no new status entry is added here
      final updatedData = laporan.toJson();
      updatedData['status'] = laporan.status;

      print('Updating laporan with ID: $id');
      print('Updated status: ${laporan.status}');
      print('Updated status history: ${laporan.statusHistory}');

      await _firestore.collection('laporan').doc(id).update(updatedData);
      print('Laporan updated successfully.');
    } catch (e) {
      print('Error updating laporan: $e');
      throw Exception('Error updating laporan: $e');
    }
  }

  Future<void> deleteLaporan(String id) async {
    try {
      await _firestore.collection('laporan').doc(id).delete();
      print('Laporan deleted successfully.');
    } catch (e) {
      print('Error deleting laporan: $e');
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
              LaporanModel.fromJson(
                reportDoc.data() as Map<String, dynamic>,
                reportId,
              ), // Add reportId here
            );
          }
        }
        print('User reports fetched successfully.');
        return reports;
      }
      return [];
    } catch (e) {
      print('Error getting user reports: $e');
      throw Exception('Error getting user reports: $e');
    }
  }

  Future<List<LaporanModel>> getAllLaporan() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore
              .collection('laporan')
              .orderBy('timeStamp', descending: true)
              .get();
      print('All laporan fetched successfully.');
      return querySnapshot.docs
          .map(
            (doc) => LaporanModel.fromJson(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ), // Add doc.id here
          )
          .toList();
    } catch (e) {
      print('Error getting all laporan: $e');
      throw Exception('Error getting all laporan: $e');
    }
  }
}
