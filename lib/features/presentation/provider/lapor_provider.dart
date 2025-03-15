import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this line
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this line
import 'package:tes_gradle/features/domain/entities/laporan.dart';
import 'package:tes_gradle/features/domain/entities/komentar.dart';
import 'package:tes_gradle/features/domain/usecases/create_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/read_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/update_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/delete_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/get_user_reports.dart';
import 'package:tes_gradle/features/domain/usecases/get_all_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/create_komentar.dart';
import 'package:tes_gradle/features/domain/usecases/get_komentar_by_laporan_id.dart';

class LaporProvider with ChangeNotifier {
  final CreateLaporan _createLaporan;
  final ReadLaporan _readLaporan;
  final UpdateLaporan _updateLaporan;
  final DeleteLaporan _deleteLaporan;
  final GetUserReports _getUserReports;
  final GetAllLaporan _getAllLaporan;
  final CreateKomentar _createKomentar;
  final GetKomentarByLaporanId _getKomentarByLaporanId;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Add this line

  LaporProvider(
    this._createLaporan,
    this._readLaporan,
    this._updateLaporan,
    this._deleteLaporan,
    this._getUserReports,
    this._getAllLaporan,
    this._createKomentar,
    this._getKomentarByLaporanId,
  );

  List<Laporan>? _laporanList;
  List<Laporan>? _filteredLaporanList;
  Laporan? _laporan;
  bool _isLoading = false;
  List<Komentar>? _komentarList;

  List<Laporan>? get laporanList => _laporanList;
  List<Laporan>? get filteredLaporanList => _filteredLaporanList;
  set filteredLaporanList(List<Laporan>? value) {
    _filteredLaporanList = value;
    notifyListeners();
  }

  Laporan? get laporan => _laporan;
  bool get isLoading => _isLoading;
  List<Komentar>? get komentarList => _komentarList;

  Future<void> fetchLaporan(String id) async {
    _setLoading(true);
    try {
      _laporan = await _readLaporan.call(id);
    } catch (e) {
      print('Error fetching laporan: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addLaporan(Laporan laporan) async {
    _setLoading(true);
    try {
      final createdLaporan = await _createLaporan.call(laporan);
      _laporanList ??= []; // Initialize _laporanList if it's null
      _laporanList?.add(createdLaporan); // Add the created laporan to the list
      notifyListeners();
    } catch (e) {
      print('Error adding laporan: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateLaporan(String id, Laporan laporan) async {
    _setLoading(true);
    try {
      await _updateLaporan.call(id, laporan);
    } catch (e) {
      print('Error updating laporan: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateLaporanStatus(String id, String newStatus) async {
    _setLoading(true);
    try {
      final laporan = await _readLaporan.call(id);
      if (laporan != null) {
        final updatedLaporan = Laporan(
          id: laporan.id,
          kategoriLaporan: laporan.kategoriLaporan,
          judulLaporan: laporan.judulLaporan,
          keteranganLaporan: laporan.keteranganLaporan,
          lokasiKejadian: laporan.lokasiKejadian,
          foto: laporan.foto,
          timeStamp: laporan.timeStamp,
          status: newStatus,
          anonymus: laporan.anonymus,
          statusHistory: [
            ...laporan.statusHistory,
            {'status': newStatus, 'date': DateTime.now()},
          ],
        );
        await _updateLaporan.call(id, updatedLaporan);
        notifyListeners();
      }
    } catch (e) {
      print('Error updating laporan status: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteLaporan(String id) async {
    _setLoading(true);
    try {
      await _deleteLaporan.call(id);
    } catch (e) {
      print('Error deleting laporan: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchUserReports(String userId) async {
    _setLoading(true);
    try {
      _laporanList = await _getUserReports.call(userId);
    } catch (e) {
      print('Error fetching user reports: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchAllLaporan() async {
    _setLoading(true);
    try {
      _laporanList = await _getAllLaporan.call();
    } catch (e) {
      print('Error fetching all laporan: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addKomentar(Komentar komentar) async {
    _setLoading(true);
    try {
      final userId = _auth.currentUser?.uid; // Add this line
      if (userId == null) {
        throw Exception('User not logged in'); // Add this line
      }

      // Get user data from Firestore
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get(); // Add this line
      if (!userDoc.exists) {
        throw Exception('User data not found'); // Add this line
      }
      final userName = userDoc.data()?['name'] ?? 'Anonymous'; // Add this line

      final updatedKomentar = Komentar(
        namaPengirim: userName, // Use user name instead of UID
        fotoProfilPengirim: komentar.fotoProfilPengirim,
        pesan: komentar.pesan,
        timeStamp: komentar.timeStamp,
        laporanId: komentar.laporanId,
      );

      await _createKomentar.call(updatedKomentar);
    } catch (e) {
      print('Error adding komentar: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchKomentarByLaporanId(String laporanId) async {
    _setLoading(true);
    try {
      _komentarList = await _getKomentarByLaporanId.call(laporanId);
    } catch (e) {
      print('Error fetching komentar: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
