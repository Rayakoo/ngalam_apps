import 'package:tes_gradle/features/domain/entities/laporan.dart';
import 'package:tes_gradle/features/domain/repositories/lapor_repository.dart';

class GetUserReports {
  final LaporRepository repository;

  GetUserReports(this.repository);

  Future<List<Laporan>> call(String userId) async {
    return await repository.getUserReports(userId);
  }
}
