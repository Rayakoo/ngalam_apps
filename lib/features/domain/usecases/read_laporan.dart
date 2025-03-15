import 'package:tes_gradle/features/domain/entities/laporan.dart';
import 'package:tes_gradle/features/domain/repositories/lapor_repository.dart';

class ReadLaporan {
  final LaporRepository repository;

  ReadLaporan(this.repository);

  Future<Laporan?> call(String id) async {
    return await repository.readLaporan(id);
  }
}
