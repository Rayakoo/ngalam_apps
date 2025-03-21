import 'package:tes_gradle/features/data/datasources/cctv_data_service.dart';
import 'package:tes_gradle/features/data/models/cctv_model.dart';
import 'package:tes_gradle/features/domain/entities/cctv.dart';
import 'package:tes_gradle/features/domain/repositories/cctv_repository.dart';

class CCTVRepositoryImpl implements CCTVRepository {
  final CCTVDataService _cctvDataService;

  CCTVRepositoryImpl(this._cctvDataService);

  @override
  Future<List<CCTV>> getAllCCTVs() async {
    final cctvModels = await _cctvDataService.getAllCCTVs();
    return cctvModels.map((cctvModel) {
      return CCTV(
        markerId: cctvModel.markerId,
        position: cctvModel.position,
        infoWindow: cctvModel.infoWindow,
        linkCCTV: cctvModel.linkCCTV,
      );
    }).toList();
  }

  @override
  Future<void> addCCTV(CCTV cctv) async {
    final cctvModel = CCTVModel(
      markerId: cctv.markerId,
      position: cctv.position,
      infoWindow: cctv.infoWindow,
      linkCCTV: cctv.linkCCTV,
    );
    await _cctvDataService.addCCTV(cctvModel);
  }
}
