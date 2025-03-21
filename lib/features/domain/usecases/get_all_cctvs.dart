import 'package:tes_gradle/core/usecases.dart';
import 'package:tes_gradle/features/domain/entities/cctv.dart';
import 'package:tes_gradle/features/domain/repositories/cctv_repository.dart';

class GetAllCCTVs implements UseCase<List<CCTV>, NoParams> {
  final CCTVRepository repository;

  GetAllCCTVs(this.repository);

  @override
  Future<List<CCTV>> call(NoParams params) async {
    return await repository.getAllCCTVs();
  }
}
