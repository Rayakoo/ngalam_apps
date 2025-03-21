import 'package:flutter/material.dart';
import 'package:tes_gradle/features/domain/entities/cctv.dart';
import 'package:tes_gradle/features/domain/usecases/get_all_cctvs.dart';
import 'package:tes_gradle/features/domain/usecases/add_cctv.dart';
import 'package:tes_gradle/core/usecases.dart';

class CCTVProvider with ChangeNotifier {
  final GetAllCCTVs _getAllCCTVs;
  final AddCCTV _addCCTV;

  CCTVProvider(this._getAllCCTVs, this._addCCTV);

  List<CCTV>? _cctvList;
  bool _isLoading = false;

  List<CCTV>? get cctvList => _cctvList;
  bool get isLoading => _isLoading;

  Future<void> fetchAllCCTVs() async {
    _setLoading(true);
    try {
      _cctvList = await _getAllCCTVs.call(NoParams());
    } catch (e) {
      print('Error fetching CCTVs: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addCCTV(CCTV cctv) async {
    _setLoading(true);
    try {
      await _addCCTV.call(cctv);
      _cctvList ??= [];
      _cctvList?.add(cctv);
      notifyListeners();
    } catch (e) {
      print('Error adding CCTV: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }
}
