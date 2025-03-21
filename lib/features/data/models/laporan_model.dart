import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tes_gradle/features/domain/entities/laporan.dart';

class LaporanModel extends Laporan {
  LaporanModel({
    required String id,
    required String kategoriLaporan,
    required String judulLaporan,
    required String keteranganLaporan,
    required GeoPoint lokasiKejadian, // Change to GeoPoint
    required String foto,
    required DateTime timeStamp,
    required String status,
    required bool anonymus,
    required String uid,
    required List<Map<String, dynamic>> statusHistory,
  }) : super(
         id: id,
         kategoriLaporan: kategoriLaporan,
         judulLaporan: judulLaporan,
         keteranganLaporan: keteranganLaporan,
         lokasiKejadian: lokasiKejadian, // Change to GeoPoint
         foto: foto,
         timeStamp: timeStamp,
         status: status,
         anonymus: anonymus,
         uid: uid,
         statusHistory: statusHistory,
       );

  factory LaporanModel.fromJson(Map<String, dynamic> json, String id) {
    return LaporanModel(
      id: id,
      kategoriLaporan: json['kategoriLaporan'] ?? '',
      judulLaporan: json['judulLaporan'] ?? '',
      keteranganLaporan: json['keteranganLaporan'] ?? '',
      lokasiKejadian:
          json['lokasiKejadian'] ?? GeoPoint(0, 0), // Change to GeoPoint
      foto: json['foto'] ?? '',
      timeStamp: (json['timeStamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: json['status'] ?? '',
      anonymus: json['anonymus'] ?? false,
      uid: json['uid'] ?? '',
      statusHistory: List<Map<String, dynamic>>.from(
        json['statusHistory'] ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kategoriLaporan': kategoriLaporan,
      'judulLaporan': judulLaporan,
      'keteranganLaporan': keteranganLaporan,
      'lokasiKejadian': lokasiKejadian, // Change to GeoPoint
      'foto': foto,
      'timeStamp': Timestamp.fromDate(timeStamp),
      'status': status,
      'anonymus': anonymus,
      'uid': uid,
      'statusHistory': statusHistory,
    };
  }
}
