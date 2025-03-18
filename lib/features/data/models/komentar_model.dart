import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tes_gradle/features/domain/entities/komentar.dart';

class KomentarModel extends Komentar {
  KomentarModel({
    required String namaPengirim,
    required String fotoProfilPengirim,
    required String pesan,
    required DateTime timeStamp,
    required String laporanId, 
  }) : super(
         namaPengirim: namaPengirim,
         fotoProfilPengirim: fotoProfilPengirim,
         pesan: pesan,
         timeStamp: timeStamp,
         laporanId: laporanId, 
       );

  factory KomentarModel.fromJson(Map<String, dynamic> json) {
    return KomentarModel(
      namaPengirim: json['namaPengirim'] ?? '',
      fotoProfilPengirim: json['fotoProfilPengirim'] ?? '',
      pesan: json['pesan'] ?? '',
      timeStamp: (json['timeStamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      laporanId: json['laporanId'] ?? '', 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'namaPengirim': namaPengirim,
      'fotoProfilPengirim': fotoProfilPengirim,
      'pesan': pesan,
      'timeStamp': Timestamp.fromDate(timeStamp),
      'laporanId': laporanId, 
    };
  }
}
