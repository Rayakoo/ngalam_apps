import 'package:tes_gradle/features/domain/entities/cctv.dart';

abstract class CCTVRepository {
  Future<List<CCTV>> getAllCCTVs();
  Future<void> addCCTV(CCTV cctv);
}
