import 'package:flutter/material.dart';
import 'package:tes_gradle/features/domain/entities/berita.dart';
import 'package:tes_gradle/features/domain/usecases/berita_usecases.dart';

class BeritaProvider with ChangeNotifier {
  final FetchAllBerita fetchAllBerita;
  final CreateBerita createBerita;
  final UpdateBerita updateBerita;
  final DeleteBerita deleteBerita;

  BeritaProvider({
    required this.fetchAllBerita,
    required this.createBerita,
    required this.updateBerita,
    required this.deleteBerita,
  });

  List<Berita>? _beritaList;
  bool _isLoading = false;
  String? _errorMessage;

  List<Berita>? get beritaList => _beritaList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchBerita() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      print('Fetching berita...'); // Debug log
      _beritaList = await fetchAllBerita();
      print('Fetched berita: $_beritaList'); // Debug log
    } catch (e) {
      _errorMessage = 'Gagal memuat berita: $e';
      print('Error fetching berita: $e'); // Debug log
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBerita(Berita berita) async {
    await createBerita(berita);
    await fetchBerita();
  }

  Future<void> editBerita(String id, Berita berita) async {
    await updateBerita(id, berita);
    await fetchBerita();
  }

  Future<void> removeBerita(String id) async {
    await deleteBerita(id);
    await fetchBerita();
  }
}
