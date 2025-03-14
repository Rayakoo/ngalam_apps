import 'package:tes_gradle/features/data/datasources/lapor_data_service.dart';
import 'package:tes_gradle/features/data/models/laporan_model.dart';
import 'package:tes_gradle/features/domain/entities/laporan.dart';
import 'package:tes_gradle/features/domain/repositories/lapor_repository.dart';

class LaporRepositoryImpl implements LaporRepository {
  final LaporDataService _laporDataService;

  LaporRepositoryImpl(this._laporDataService);

  @override
  Future<void> createLaporan(Laporan laporan) async {
    final laporanModel = LaporanModel(
      kategoriLaporan: laporan.kategoriLaporan,
      judulLaporan: laporan.judulLaporan,
      keteranganLaporan: laporan.keteranganLaporan,
      lokasiKejadian: laporan.lokasiKejadian,
      foto: laporan.foto,
      timeStamp: laporan.timeStamp,
      status: laporan.status,
      anonymus: laporan.anonymus,
    );
    return await _laporDataService.createLaporan(laporanModel);
  }

  @override
  Future<Laporan?> readLaporan(String id) async {
    final laporanModel = await _laporDataService.readLaporan(id);
    if (laporanModel != null) {
      return Laporan(
        kategoriLaporan: laporanModel.kategoriLaporan,
        judulLaporan: laporanModel.judulLaporan,
        keteranganLaporan: laporanModel.keteranganLaporan,
        lokasiKejadian: laporanModel.lokasiKejadian,
        foto: laporanModel.foto,
        timeStamp: laporanModel.timeStamp,
        status: laporanModel.status,
        anonymus: laporanModel.anonymus,
      );
    }
    return null;
  }

  @override
  Future<void> updateLaporan(String id, Laporan laporan) async {
    final laporanModel = LaporanModel(
      kategoriLaporan: laporan.kategoriLaporan,
      judulLaporan: laporan.judulLaporan,
      keteranganLaporan: laporan.keteranganLaporan,
      lokasiKejadian: laporan.lokasiKejadian,
      foto: laporan.foto,
      timeStamp: laporan.timeStamp,
      status: laporan.status,
      anonymus: laporan.anonymus,
    );
    return await _laporDataService.updateLaporan(id, laporanModel);
  }

  @override
  Future<void> deleteLaporan(String id) async {
    return await _laporDataService.deleteLaporan(id);
  }

  @override
  Future<List<Laporan>> getUserReports(String userId) async {
    final laporanModels = await _laporDataService.getUserReports(userId);
    return laporanModels.map((laporanModel) {
      return Laporan(
        kategoriLaporan: laporanModel.kategoriLaporan,
        judulLaporan: laporanModel.judulLaporan,
        keteranganLaporan: laporanModel.keteranganLaporan,
        lokasiKejadian: laporanModel.lokasiKejadian,
        foto: laporanModel.foto,
        timeStamp: laporanModel.timeStamp,
        status: laporanModel.status,
        anonymus: laporanModel.anonymus,
      );
    }).toList();
  }
}
