import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tes_gradle/features/data/models/status_history_model.dart';

class StatusHistoryDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<StatusHistoryModel> createStatusHistory(
    StatusHistoryModel statusHistory,
  ) async {
    try {
      final statusHistoryData = statusHistory.toJson();
      final statusHistoryRef = await _firestore
          .collection('statusHistory')
          .add(statusHistoryData);
      final statusHistoryId = statusHistoryRef.id;

      return StatusHistoryModel.fromJson(statusHistoryData, statusHistoryId);
    } catch (e) {
      print('Error creating status history: $e');
      throw Exception('Error creating status history: $e');
    }
  }

  Future<StatusHistoryModel?> readStatusHistory(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('statusHistory').doc(id).get();
      if (doc.exists) {
        return StatusHistoryModel.fromJson(
          doc.data() as Map<String, dynamic>,
          id,
        );
      }
      return null;
    } catch (e) {
      print('Error reading status history: $e');
      throw Exception('Error reading status history: $e');
    }
  }

  Future<void> updateStatusHistory(
    String id,
    StatusHistoryModel statusHistory,
  ) async {
    try {
      await _firestore
          .collection('statusHistory')
          .doc(id)
          .update(statusHistory.toJson());
      print('Status history updated successfully.');
    } catch (e) {
      print('Error updating status history: $e');
      throw Exception('Error updating status history: $e');
    }
  }

  Future<void> deleteStatusHistory(String id) async {
    try {
      await _firestore.collection('statusHistory').doc(id).delete();
      print('Status history deleted successfully.');
    } catch (e) {
      print('Error deleting status history: $e');
      throw Exception('Error deleting status history: $e');
    }
  }

  Future<List<StatusHistoryModel>> getStatusHistoryByLaporanId(
    String laporanId,
  ) async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore
              .collection('statusHistory')
              .where('laporanId', isEqualTo: laporanId)
              .get();
      return querySnapshot.docs
          .map(
            (doc) => StatusHistoryModel.fromJson(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    } catch (e) {
      print('Error getting status history by laporanId: $e');
      throw Exception('Error getting status history by laporanId: $e');
    }
  }
}
