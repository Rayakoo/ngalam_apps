import 'package:tes_gradle/features/data/datasources/berita_data_service.dart';
import 'package:tes_gradle/features/domain/entities/berita.dart';
import 'package:tes_gradle/features/domain/repositories/berita_repository.dart';

class BeritaRepositoryImpl implements BeritaRepository {
  final BeritaDataService _dataService;

  BeritaRepositoryImpl(this._dataService);

  @override
  Future<List<Berita>> fetchAllBerita() async {
    return await _dataService.fetchAllBerita();
  }

  @override
  Future<void> createBerita(Berita berita) async {
    await _dataService.createBerita(berita);
  }

  @override
  Future<void> updateBerita(String id, Berita berita) async {
    await _dataService.updateBerita(id, berita);
  }

  @override
  Future<void> deleteBerita(String id) async {
    await _dataService.deleteBerita(id);
  }
}
