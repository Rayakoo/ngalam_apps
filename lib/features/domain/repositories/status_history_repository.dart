import 'package:tes_gradle/features/domain/entities/status_history.dart';

abstract class StatusHistoryRepository {
  Future<StatusHistory> createStatusHistory(StatusHistory statusHistory);
  Future<StatusHistory?> readStatusHistory(String id);
  Future<void> updateStatusHistory(String id, StatusHistory statusHistory);
  Future<void> deleteStatusHistory(String id);
  Future<List<StatusHistory>> getStatusHistoryByLaporanId(String laporanId);
}
