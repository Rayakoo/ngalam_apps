import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tes_gradle/features/domain/entities/laporan.dart';

class LaporanModel extends Laporan {
  LaporanModel({
    required String id,
    required String kategoriLaporan,
    required String judulLaporan,
    required String keteranganLaporan,
    required String lokasiKejadian,
    required String foto,
    required DateTime timeStamp,
    required String status,
    required bool anonymus,
    required List<Map<String, dynamic>> statusHistory, // Add this line
  }) : super(
         id: id,
         kategoriLaporan: kategoriLaporan,
         judulLaporan: judulLaporan,
         keteranganLaporan: keteranganLaporan,
         lokasiKejadian: lokasiKejadian,
         foto: foto,
         timeStamp: timeStamp,
         status: status,
         anonymus: anonymus,
         statusHistory: statusHistory, // Add this line
       );

  factory LaporanModel.fromJson(Map<String, dynamic> json, String id) {
    return LaporanModel(
      id: id,
      kategoriLaporan: json['kategoriLaporan'] ?? '',
      judulLaporan: json['judulLaporan'] ?? '',
      keteranganLaporan: json['keteranganLaporan'] ?? '',
      lokasiKejadian: json['lokasiKejadian'] ?? '',
      foto: json['foto'] ?? '',
      timeStamp: (json['timeStamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: json['status'] ?? '',
      anonymus: json['anonymus'] ?? false,
      statusHistory: List<Map<String, dynamic>>.from(
        json['statusHistory'] ?? [],
      ), // Add this line
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kategoriLaporan': kategoriLaporan,
      'judulLaporan': judulLaporan,
      'keteranganLaporan': keteranganLaporan,
      'lokasiKejadian': lokasiKejadian,
      'foto': foto,
      'timeStamp': Timestamp.fromDate(timeStamp),
      'status': status,
      'anonymus': anonymus,
      'statusHistory': statusHistory, // Add this line
    };
  }
}
