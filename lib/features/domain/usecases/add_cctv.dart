import 'package:tes_gradle/core/usecases.dart';
import 'package:tes_gradle/features/domain/entities/cctv.dart';
import 'package:tes_gradle/features/domain/repositories/cctv_repository.dart';

class AddCCTV implements UseCase<void, CCTV> {
  final CCTVRepository repository;

  AddCCTV(this.repository);

  @override
  Future<void> call(CCTV cctv) async {
    return await repository.addCCTV(cctv);
  }
}
