import 'package:flutter/material.dart';
import 'package:tes_gradle/features/domain/entities/laporan.dart';
import 'package:tes_gradle/features/domain/usecases/create_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/read_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/update_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/delete_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/get_user_reports.dart';

class LaporProvider with ChangeNotifier {
  final CreateLaporan _createLaporan;
  final ReadLaporan _readLaporan;
  final UpdateLaporan _updateLaporan;
  final DeleteLaporan _deleteLaporan;
  final GetUserReports _getUserReports;

  LaporProvider(
    this._createLaporan,
    this._readLaporan,
    this._updateLaporan,
    this._deleteLaporan,
    this._getUserReports,
  );

  List<Laporan>? _laporanList;
  Laporan? _laporan;
  bool _isLoading = false;

  List<Laporan>? get laporanList => _laporanList;
  Laporan? get laporan => _laporan;
  bool get isLoading => _isLoading;

  Future<void> fetchLaporan(String id) async {
    _isLoading = true;
    notifyListeners();
    _laporan = await _readLaporan.call(id);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addLaporan(Laporan laporan) async {
    _isLoading = true;
    notifyListeners();
    await _createLaporan.call(laporan);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateLaporan(String id, Laporan laporan) async {
    _isLoading = true;
    notifyListeners();
    await _updateLaporan.call(id, laporan);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteLaporan(String id) async {
    _isLoading = true;
    notifyListeners();
    await _deleteLaporan.call(id);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserReports(String userId) async {
    _isLoading = true;
    notifyListeners();
    _laporanList = await _getUserReports.call(userId);
    _isLoading = false;
    notifyListeners();
  }
}
