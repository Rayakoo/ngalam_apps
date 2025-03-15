import 'package:tes_gradle/features/domain/repositories/lapor_repository.dart';

class DeleteLaporan {
  final LaporRepository repository;

  DeleteLaporan(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteLaporan(id);
  }
}
