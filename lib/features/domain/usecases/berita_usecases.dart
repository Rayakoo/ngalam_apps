import 'package:tes_gradle/features/domain/entities/berita.dart';
import 'package:tes_gradle/features/domain/repositories/berita_repository.dart';

class FetchAllBerita {
  final BeritaRepository repository;

  FetchAllBerita(this.repository);

  Future<List<Berita>> call() async {
    return await repository.fetchAllBerita();
  }
}

class CreateBerita {
  final BeritaRepository repository;

  CreateBerita(this.repository);

  Future<void> call(Berita berita) async {
    await repository.createBerita(berita);
  }
}

class UpdateBerita {
  final BeritaRepository repository;

  UpdateBerita(this.repository);

  Future<void> call(String id, Berita berita) async {
    await repository.updateBerita(id, berita);
  }
}

class DeleteBerita {
  final BeritaRepository repository;

  DeleteBerita(this.repository);

  Future<void> call(String id) async {
    await repository.deleteBerita(id);
  }
}
