import 'package:tes_gradle/features/data/datasources/status_history_data_service.dart';
import 'package:tes_gradle/features/data/models/status_history_model.dart';
import 'package:tes_gradle/features/domain/entities/status_history.dart';
import 'package:tes_gradle/features/domain/repositories/status_history_repository.dart';

class StatusHistoryRepositoryImpl implements StatusHistoryRepository {
  final StatusHistoryDataService _statusHistoryDataService;

  StatusHistoryRepositoryImpl(this._statusHistoryDataService);

  @override
  Future<StatusHistory> createStatusHistory(StatusHistory statusHistory) async {
    final statusHistoryModel = StatusHistoryModel(
      id: '',
      laporanId: statusHistory.laporanId,
      status: statusHistory.status,
      description: statusHistory.description,
      imageUrl: statusHistory.imageUrl,
      timeStamp: statusHistory.timeStamp,
    );
    final createdStatusHistoryModel = await _statusHistoryDataService
        .createStatusHistory(statusHistoryModel);
    return StatusHistory(
      id: createdStatusHistoryModel.id,
      laporanId: createdStatusHistoryModel.laporanId,
      status: createdStatusHistoryModel.status,
      description: createdStatusHistoryModel.description,
      imageUrl: createdStatusHistoryModel.imageUrl,
      timeStamp: createdStatusHistoryModel.timeStamp,
    );
  }

  @override
  Future<StatusHistory?> readStatusHistory(String id) async {
    final statusHistoryModel = await _statusHistoryDataService
        .readStatusHistory(id);
    if (statusHistoryModel != null) {
      return StatusHistory(
        id: statusHistoryModel.id,
        laporanId: statusHistoryModel.laporanId,
        status: statusHistoryModel.status,
        description: statusHistoryModel.description,
        imageUrl: statusHistoryModel.imageUrl,
        timeStamp: statusHistoryModel.timeStamp,
      );
    }
    return null;
  }

  @override
  Future<void> updateStatusHistory(
    String id,
    StatusHistory statusHistory,
  ) async {
    final statusHistoryModel = StatusHistoryModel(
      id: id,
      laporanId: statusHistory.laporanId,
      status: statusHistory.status,
      description: statusHistory.description,
      imageUrl: statusHistory.imageUrl,
      timeStamp: statusHistory.timeStamp,
    );
    return await _statusHistoryDataService.updateStatusHistory(
      id,
      statusHistoryModel,
    );
  }

  @override
  Future<void> deleteStatusHistory(String id) async {
    return await _statusHistoryDataService.deleteStatusHistory(id);
  }

  @override
  Future<List<StatusHistory>> getStatusHistoryByLaporanId(
    String laporanId,
  ) async {
    final statusHistoryModels = await _statusHistoryDataService
        .getStatusHistoryByLaporanId(laporanId);
    return statusHistoryModels.map((statusHistoryModel) {
      return StatusHistory(
        id: statusHistoryModel.id,
        laporanId: statusHistoryModel.laporanId,
        status: statusHistoryModel.status,
        description: statusHistoryModel.description,
        imageUrl: statusHistoryModel.imageUrl,
        timeStamp: statusHistoryModel.timeStamp,
      );
    }).toList();
  }
}
