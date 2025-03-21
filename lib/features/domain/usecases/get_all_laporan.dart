import 'package:tes_gradle/features/domain/entities/laporan.dart';
import 'package:tes_gradle/features/domain/repositories/lapor_repository.dart';

class GetAllLaporan {
  final LaporRepository repository;

  GetAllLaporan(this.repository);

  Future<List<Laporan>> call() async {
    return await repository.getAllLaporan();
  }
}
