import 'package:tes_gradle/features/domain/entities/komentar.dart';
import 'package:tes_gradle/features/domain/repositories/lapor_repository.dart';

class CreateKomentar {
  final LaporRepository repository;

  CreateKomentar(this.repository);

  Future<void> call(Komentar komentar) async {
    return await repository.createKomentar(komentar);
  }
}
