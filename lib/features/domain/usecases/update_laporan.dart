import 'package:tes_gradle/features/domain/entities/laporan.dart';
import 'package:tes_gradle/features/domain/repositories/lapor_repository.dart';

class UpdateLaporan {
  final LaporRepository repository;

  UpdateLaporan(this.repository);

  Future<void> call(String id, Laporan laporan) async {
    return await repository.updateLaporan(id, laporan);
  }
}
