import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tes_gradle/features/domain/entities/status_history.dart';

class StatusHistoryModel extends StatusHistory {
  StatusHistoryModel({
    required String id,
    required String laporanId,
    required String status,
    required String description,
    required String imageUrl,
    required DateTime timeStamp,
  }) : super(
         id: id,
         laporanId: laporanId,
         status: status,
         description: description,
         imageUrl: imageUrl,
         timeStamp: timeStamp,
       );

  factory StatusHistoryModel.fromJson(Map<String, dynamic> json, String id) {
    return StatusHistoryModel(
      id: id,
      laporanId: json['laporanId'] ?? '',
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      timeStamp: (json['timeStamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'laporanId': laporanId,
      'status': status,
      'description': description,
      'imageUrl': imageUrl,
      'timeStamp': Timestamp.fromDate(timeStamp),
    };
  }
}
