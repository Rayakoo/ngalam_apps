import 'package:tes_gradle/features/domain/entities/laporan.dart';
import 'package:tes_gradle/features/domain/repositories/lapor_repository.dart';

class CreateLaporan {
  final LaporRepository repository;

  CreateLaporan(this.repository);

  Future<void> call(Laporan laporan) async {
    return await repository.createLaporan(laporan);
  }
}
