import 'package:tes_gradle/features/domain/entities/berita.dart';

class BeritaModel extends Berita {
  BeritaModel({
    required String id,
    required String gambar,
    required String judul,
    required String isi,
  }) : super(id: id, gambar: gambar, judul: judul, isi: isi);

  factory BeritaModel.fromJson(Map<String, dynamic> json, String id) {
    return BeritaModel(
      id: id,
      gambar: json['gambar'],
      judul: json['judul'],
      isi: json['isi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'gambar': gambar, 'judul': judul, 'isi': isi};
  }
}
