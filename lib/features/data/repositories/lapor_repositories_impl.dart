import 'package:tes_gradle/features/data/datasources/lapor_data_service.dart';
import 'package:tes_gradle/features/data/datasources/komentar_data_service.dart';
import 'package:tes_gradle/features/data/models/laporan_model.dart';
import 'package:tes_gradle/features/data/models/komentar_model.dart';
import 'package:tes_gradle/features/domain/entities/laporan.dart';
import 'package:tes_gradle/features/domain/entities/komentar.dart';
import 'package:tes_gradle/features/domain/repositories/lapor_repository.dart';

class LaporRepositoryImpl implements LaporRepository {
  final LaporDataService _laporDataService;
  final KomentarDataService _komentarDataService;

  LaporRepositoryImpl(this._laporDataService, this._komentarDataService);

  @override
  Future<Laporan> createLaporan(Laporan laporan) async {
    final laporanModel = LaporanModel(
      id: '',
      kategoriLaporan: laporan.kategoriLaporan,
      judulLaporan: laporan.judulLaporan,
      keteranganLaporan: laporan.keteranganLaporan,
      lokasiKejadian: laporan.lokasiKejadian, // Change to GeoPoint
      foto: laporan.foto,
      timeStamp: laporan.timeStamp,
      status: laporan.status,
      anonymus: laporan.anonymus,
      statusHistory: laporan.statusHistory,
      uid: laporan.uid,
    );
    final createdLaporanModel = await _laporDataService.createLaporan(
      laporanModel,
    );
    return Laporan(
      id: createdLaporanModel.id,
      kategoriLaporan: createdLaporanModel.kategoriLaporan,
      judulLaporan: createdLaporanModel.judulLaporan,
      keteranganLaporan: createdLaporanModel.keteranganLaporan,
      lokasiKejadian: createdLaporanModel.lokasiKejadian, // Change to GeoPoint
      foto: createdLaporanModel.foto,
      timeStamp: createdLaporanModel.timeStamp,
      status: createdLaporanModel.status,
      anonymus: createdLaporanModel.anonymus,
      statusHistory: createdLaporanModel.statusHistory,
      uid: laporan.uid,
    );
  }

  @override
  Future<Laporan?> readLaporan(String id) async {
    final laporanModel = await _laporDataService.readLaporan(id);
    if (laporanModel != null) {
      return Laporan(
        id: laporanModel.id,
        kategoriLaporan: laporanModel.kategoriLaporan,
        judulLaporan: laporanModel.judulLaporan,
        keteranganLaporan: laporanModel.keteranganLaporan,
        lokasiKejadian: laporanModel.lokasiKejadian, // Change to GeoPoint
        foto: laporanModel.foto,
        timeStamp: laporanModel.timeStamp,
        status: laporanModel.status,
        anonymus: laporanModel.anonymus,
        statusHistory: laporanModel.statusHistory,
        uid: laporanModel.uid,
      );
    }
    return null;
  }

  @override
  Future<void> updateLaporan(String id, Laporan laporan) async {
    final laporanModel = LaporanModel(
      id: id,
      kategoriLaporan: laporan.kategoriLaporan,
      judulLaporan: laporan.judulLaporan,
      keteranganLaporan: laporan.keteranganLaporan,
      lokasiKejadian: laporan.lokasiKejadian, // Change to GeoPoint
      foto: laporan.foto,
      timeStamp: laporan.timeStamp,
      status: laporan.status,
      anonymus: laporan.anonymus,
      statusHistory: laporan.statusHistory,
      uid: laporan.uid,
    );
    await _laporDataService.updateLaporan(id, laporanModel);
  }

  @override
  Future<void> deleteLaporan(String id) async {
    await _laporDataService.deleteLaporan(id);
  }

  @override
  Future<List<Laporan>> getUserReports(String userId) async {
    final laporanModels = await _laporDataService.getUserReports(userId);
    return laporanModels.map((laporanModel) {
      return Laporan(
        id: laporanModel.id,
        kategoriLaporan: laporanModel.kategoriLaporan,
        judulLaporan: laporanModel.judulLaporan,
        keteranganLaporan: laporanModel.keteranganLaporan,
        lokasiKejadian: laporanModel.lokasiKejadian, // Change to GeoPoint
        foto: laporanModel.foto,
        timeStamp: laporanModel.timeStamp,
        status: laporanModel.status,
        anonymus: laporanModel.anonymus,
        statusHistory: laporanModel.statusHistory,
        uid: laporanModel.uid,
      );
    }).toList();
  }

  @override
  Future<List<Laporan>> getAllLaporan() async {
    final laporanModels = await _laporDataService.getAllLaporan();
    return laporanModels.map((laporanModel) {
      return Laporan(
        id: laporanModel.id,
        kategoriLaporan: laporanModel.kategoriLaporan,
        judulLaporan: laporanModel.judulLaporan,
        keteranganLaporan: laporanModel.keteranganLaporan,
        lokasiKejadian: laporanModel.lokasiKejadian, // Change to GeoPoint
        foto: laporanModel.foto,
        timeStamp: laporanModel.timeStamp,
        status: laporanModel.status,
        anonymus: laporanModel.anonymus,
        statusHistory: laporanModel.statusHistory,
        uid: laporanModel.uid,
      );
    }).toList();
  }

  @override
  Future<void> createKomentar(Komentar komentar) async {
    final komentarModel = KomentarModel(
      namaPengirim: komentar.namaPengirim,
      fotoProfilPengirim: komentar.fotoProfilPengirim,
      pesan: komentar.pesan,
      timeStamp: komentar.timeStamp,
      laporanId: komentar.laporanId,
    );
    return await _komentarDataService.createKomentar(komentarModel);
  }

  @override
  Future<List<Komentar>> getKomentarByLaporanId(String laporanId) async {
    final komentarModels = await _komentarDataService.getKomentarByLaporanId(
      laporanId,
    );
    return komentarModels.map((komentarModel) {
      return Komentar(
        namaPengirim: komentarModel.namaPengirim,
        fotoProfilPengirim: komentarModel.fotoProfilPengirim,
        pesan: komentarModel.pesan,
        timeStamp: komentarModel.timeStamp,
        laporanId: komentarModel.laporanId,
      );
    }).toList();
  }
}
