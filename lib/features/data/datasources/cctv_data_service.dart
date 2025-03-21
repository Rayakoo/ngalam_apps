import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tes_gradle/features/data/models/cctv_model.dart';

class CCTVDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CCTVModel>> getAllCCTVs() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('cctvs').get();
      return querySnapshot.docs.map((doc) {
        return CCTVModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error getting CCTVs: $e');
      throw Exception('Error getting CCTVs: $e');
    }
  }

  Future<void> addCCTV(CCTVModel cctv) async {
    try {
      await _firestore.collection('cctvs').add(cctv.toJson());
      print('CCTV added successfully.');
    } catch (e) {
      print('Error adding CCTV: $e');
      throw Exception('Error adding CCTV: $e');
    }
  }
}
