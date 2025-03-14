import 'package:tes_gradle/features/domain/entities/laporan.dart';

class LaporanModel extends Laporan {
  LaporanModel({
    required String kategoriLaporan,
    required String judulLaporan,
    required String keteranganLaporan,
    required String lokasiKejadian,
    required String foto,
    required DateTime timeStamp,
    required String status,
    required bool anonymus,
  }) : super(
         kategoriLaporan: kategoriLaporan,
         judulLaporan: judulLaporan,
         keteranganLaporan: keteranganLaporan,
         lokasiKejadian: lokasiKejadian,
         foto: foto,
         timeStamp: timeStamp,
         status: status,
         anonymus: anonymus,
       );

  factory LaporanModel.fromJson(Map<String, dynamic> json) {
    return LaporanModel(
      kategoriLaporan: json['kategoriLaporan'],
      judulLaporan: json['judulLaporan'],
      keteranganLaporan: json['keteranganLaporan'],
      lokasiKejadian: json['lokasiKejadian'],
      foto: json['foto'],
      timeStamp: DateTime.parse(json['timeStamp']),
      status: json['status'],
      anonymus: json['anonymus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kategoriLaporan': kategoriLaporan,
      'judulLaporan': judulLaporan,
      'keteranganLaporan': keteranganLaporan,
      'lokasiKejadian': lokasiKejadian,
      'foto': foto,
      'timeStamp': timeStamp.toIso8601String(),
      'status': status,
      'anonymus': anonymus,
    };
  }
}
