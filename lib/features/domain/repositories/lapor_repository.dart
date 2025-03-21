import 'package:tes_gradle/features/domain/entities/laporan.dart';
import 'package:tes_gradle/features/domain/entities/komentar.dart';

abstract class LaporRepository {
  Future<Laporan> createLaporan(
    Laporan laporan,
  ); // Change return type to Laporan
  Future<Laporan?> readLaporan(String id);
  Future<void> updateLaporan(String id, Laporan laporan);
  Future<void> deleteLaporan(String id);
  Future<List<Laporan>> getUserReports(String userId);
  Future<List<Laporan>> getAllLaporan();
  Future<void> createKomentar(Komentar komentar);
  Future<List<Komentar>> getKomentarByLaporanId(String laporanId);
}
