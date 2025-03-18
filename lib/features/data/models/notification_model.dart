import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tes_gradle/features/domain/entities/notification.dart';

class NotificationModel extends Notification {
  NotificationModel({
    required String id,
    required String judul,
    required String kategori,
    required DateTime waktu,
    required String deskripsi,
    required String userId,
  }) : super(
         id: id,
         judul: judul,
         kategori: kategori,
         waktu: waktu,
         deskripsi: deskripsi,
         userId: userId,
       );

  factory NotificationModel.fromJson(Map<String, dynamic> json, String id) {
    return NotificationModel(
      id: id,
      judul: json['judul'] ?? '',
      kategori: json['kategori'] ?? '',
      waktu: (json['waktu'] as Timestamp).toDate(),
      deskripsi: json['deskripsi'] ?? '',
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'kategori': kategori,
      'waktu': Timestamp.fromDate(waktu),
      'deskripsi': deskripsi,
      'userId': userId,
    };
  }
}
