import 'package:tes_gradle/features/domain/entities/berita.dart';

abstract class BeritaRepository {
  Future<List<Berita>> fetchAllBerita();
  Future<void> createBerita(Berita berita);
  Future<void> updateBerita(String id, Berita berita);
  Future<void> deleteBerita(String id);
}
