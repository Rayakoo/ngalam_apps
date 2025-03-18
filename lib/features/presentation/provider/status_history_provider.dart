import 'package:flutter/material.dart';
import 'package:tes_gradle/features/domain/entities/status_history.dart';
import 'package:tes_gradle/features/domain/usecases/status_history_usecases.dart';

class StatusHistoryProvider with ChangeNotifier {
  final CreateStatusHistory _createStatusHistory;
  final ReadStatusHistory _readStatusHistory;
  final UpdateStatusHistory _updateStatusHistory;
  final DeleteStatusHistory _deleteStatusHistory;
  final GetStatusHistoryByLaporanId _getStatusHistoryByLaporanId;

  StatusHistoryProvider(
    this._createStatusHistory,
    this._readStatusHistory,
    this._updateStatusHistory,
    this._deleteStatusHistory,
    this._getStatusHistoryByLaporanId,
  );

  List<StatusHistory>? _statusHistoryList;
  StatusHistory? _statusHistory;
  bool _isLoading = false;

  List<StatusHistory>? get statusHistoryList => _statusHistoryList;
  StatusHistory? get statusHistory => _statusHistory;
  bool get isLoading => _isLoading;

  Future<void> fetchStatusHistoryByLaporanId(String laporanId) async {
    _setLoading(true);
    try {
      _statusHistoryList = await _getStatusHistoryByLaporanId.call(laporanId);
    } catch (e) {
      print('Error fetching status history: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<StatusHistory> addStatusHistory(StatusHistory statusHistory) async {
    _setLoading(true);
    try {
      final createdStatusHistory = await _createStatusHistory.call(
        StatusHistoryParams(statusHistory),
      );
      _statusHistoryList ??= [];
      _statusHistoryList?.add(createdStatusHistory);
      notifyListeners();
      return createdStatusHistory; // Return the created StatusHistory
    } catch (e) {
      print('Error adding status history: $e');
      throw e; // Rethrow the error to handle it in the caller
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateStatusHistory(
    String id,
    StatusHistory statusHistory,
  ) async {
    _setLoading(true);
    try {
      await _updateStatusHistory.call(StatusHistoryParams(statusHistory));
    } catch (e) {
      print('Error updating status history: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteStatusHistory(String id) async {
    _setLoading(true);
    try {
      await _deleteStatusHistory.call(id);
    } catch (e) {
      print('Error deleting status history: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
