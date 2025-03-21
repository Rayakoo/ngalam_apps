import 'package:tes_gradle/features/domain/entities/komentar.dart';
import 'package:tes_gradle/features/domain/repositories/lapor_repository.dart';

class GetKomentarByLaporanId {
  final LaporRepository repository;

  GetKomentarByLaporanId(this.repository);

  Future<List<Komentar>> call(String laporanId) async {
    return await repository.getKomentarByLaporanId(laporanId);
  }
}
