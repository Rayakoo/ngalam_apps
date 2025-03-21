import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tes_gradle/features/domain/entities/berita.dart';

class BeritaDataService {
  final FirebaseFirestore _firestore;

  BeritaDataService(this._firestore);

  Future<List<Berita>> fetchAllBerita() async {
    try {
      final snapshot = await _firestore.collection('berita').get();
      print('Fetched Berita Documents: ${snapshot.docs.length}'); // Debug log
      return snapshot.docs.map((doc) {
        final data = doc.data();
        print('Berita Data: $data'); // Debug log
        return Berita(
          id: doc.id,
          gambar: data['gambar'],
          judul: data['judul'],
          isi: data['isi'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching berita: $e'); // Debug log
      rethrow;
    }
  }

  Future<void> createBerita(Berita berita) async {
    await _firestore.collection('berita').add({
      'gambar': berita.gambar,
      'judul': berita.judul,
      'isi': berita.isi,
    });
  }

  Future<void> updateBerita(String id, Berita berita) async {
    await _firestore.collection('berita').doc(id).update({
      'gambar': berita.gambar,
      'judul': berita.judul,
      'isi': berita.isi,
    });
  }

  Future<void> deleteBerita(String id) async {
    await _firestore.collection('berita').doc(id).delete();
  }
}
