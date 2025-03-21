import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tes_gradle/features/domain/entities/laporan.dart';
import 'package:tes_gradle/features/domain/entities/komentar.dart';
import 'package:tes_gradle/features/domain/entities/status_history.dart';
import 'package:tes_gradle/features/domain/usecases/create_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/read_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/update_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/delete_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/get_user_reports.dart';
import 'package:tes_gradle/features/domain/usecases/get_all_laporan.dart';
import 'package:tes_gradle/features/domain/usecases/create_komentar.dart';
import 'package:tes_gradle/features/domain/usecases/get_komentar_by_laporan_id.dart';
import 'package:tes_gradle/features/domain/usecases/status_history_usecases.dart';

class LaporProvider with ChangeNotifier {
  final CreateLaporan _createLaporan;
  final ReadLaporan _readLaporan;
  final UpdateLaporan _updateLaporan;
  final DeleteLaporan _deleteLaporan;
  final GetUserReports _getUserReports;
  final GetAllLaporan _getAllLaporan;
  final CreateKomentar _createKomentar;
  final GetKomentarByLaporanId _getKomentarByLaporanId;
  final CreateStatusHistory _createStatusHistory;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LaporProvider(
    this._createLaporan,
    this._readLaporan,
    this._updateLaporan,
    this._deleteLaporan,
    this._getUserReports,
    this._getAllLaporan,
    this._createKomentar,
    this._getKomentarByLaporanId,
    this._createStatusHistory,
  );

  List<Laporan>? _laporanList;
  List<Laporan>? _filteredLaporanList;
  Laporan? _laporan;
  bool _isLoading = false;
  List<Komentar>? _komentarList;
  List<Laporan>? _userReports;

  List<Laporan>? get laporanList => _laporanList;
  List<Laporan>? get filteredLaporanList => _filteredLaporanList;
  set filteredLaporanList(List<Laporan>? value) {
    _filteredLaporanList = value;
    notifyListeners();
  }

  Laporan? get laporan => _laporan;
  bool get isLoading => _isLoading;
  List<Komentar>? get komentarList => _komentarList;
  List<Laporan>? get userReports => _userReports;

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
      final statusHistory = StatusHistory(
        id: '',
        laporanId: laporan.id,
        status: 'Menunggu',
        description: 'Laporan dibuat',
        imageUrl: laporan.foto,
        timeStamp: DateTime.now(),
      );
      final createdStatusHistory = await _createStatusHistory.call(
        StatusHistoryParams(statusHistory),
      );

      laporan.statusHistory.add({
        'status': createdStatusHistory.status,
        'description': createdStatusHistory.description,
        'imageUrl': createdStatusHistory.imageUrl,
        'date': createdStatusHistory.timeStamp,
      });

      final createdLaporan = await _createLaporan.call(laporan);
      _laporanList ??= [];
      _laporanList?.add(createdLaporan);
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
      print('Calling updateLaporan use case with ID: $id');
      print('Laporan status: ${laporan.status}');
      print('Laporan status history: ${laporan.statusHistory}');
      await _updateLaporan.call(id, laporan);
      final index = _laporanList?.indexWhere((l) => l.id == id);
      if (index != null && index != -1) {
        _laporanList?[index] = laporan;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating laporan: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateLaporanStatus(
    String id,
    String newStatus,
    String text,
    String imageUrl,
  ) async {
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
          uid: laporan.uid,
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
    try {
      print('Fetching reports for user ID: $userId'); // Debug log
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('laporan')
              .where('uid', isEqualTo: userId) // Filter by userId
              .get();

      print(
        'Query returned ${querySnapshot.docs.length} documents',
      ); // Debug log

      _userReports =
          querySnapshot.docs.map((doc) => Laporan.fromFirestore(doc)).toList();

      print('User reports fetched: $_userReports'); // Debug log
      notifyListeners();
    } catch (e) {
      print('Error fetching user reports: $e');
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
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();
      if (!userDoc.exists) {
        throw Exception('User data not found');
      }
      final userName = userDoc.data()?['name'] ?? 'Anonymous';

      final updatedKomentar = Komentar(
        namaPengirim: userName,
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
