import 'package:tes_gradle/core/usecases.dart';
import 'package:tes_gradle/features/domain/entities/status_history.dart';
import 'package:tes_gradle/features/domain/repositories/status_history_repository.dart';

class CreateStatusHistory
    implements UseCase<StatusHistory, StatusHistoryParams> {
  final StatusHistoryRepository repository;

  CreateStatusHistory(this.repository);

  @override
  Future<StatusHistory> call(StatusHistoryParams params) async {
    return await repository.createStatusHistory(params.statusHistory);
  }
}

class ReadStatusHistory implements UseCase<StatusHistory?, String> {
  final StatusHistoryRepository repository;

  ReadStatusHistory(this.repository);

  @override
  Future<StatusHistory?> call(String id) async {
    return await repository.readStatusHistory(id);
  }
}

class UpdateStatusHistory implements UseCase<void, StatusHistoryParams> {
  final StatusHistoryRepository repository;

  UpdateStatusHistory(this.repository);

  @override
  Future<void> call(StatusHistoryParams params) async {
    return await repository.updateStatusHistory(
      params.statusHistory.id,
      params.statusHistory,
    );
  }
}

class DeleteStatusHistory implements UseCase<void, String> {
  final StatusHistoryRepository repository;

  DeleteStatusHistory(this.repository);

  @override
  Future<void> call(String id) async {
    return await repository.deleteStatusHistory(id);
  }
}

class GetStatusHistoryByLaporanId
    implements UseCase<List<StatusHistory>, String> {
  final StatusHistoryRepository repository;

  GetStatusHistoryByLaporanId(this.repository);

  @override
  Future<List<StatusHistory>> call(String laporanId) async {
    return await repository.getStatusHistoryByLaporanId(laporanId);
  }
}

class StatusHistoryParams {
  final StatusHistory statusHistory;

  StatusHistoryParams(this.statusHistory);
}
