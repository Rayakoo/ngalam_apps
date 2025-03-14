import 'package:tes_gradle/features/domain/entities/laporan.dart';

abstract class LaporRepository {
  Future<void> createLaporan(Laporan laporan);
  Future<Laporan?> readLaporan(String id);
  Future<void> updateLaporan(String id, Laporan laporan);
  Future<void> deleteLaporan(String id);
  Future<List<Laporan>> getUserReports(String userId);
}
