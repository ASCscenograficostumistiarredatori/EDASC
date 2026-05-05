import 'package:asc/src/data/repositories/entity_repository.dart';
import 'package:asc/src/data/services/entity_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void initializeDependencies() {
  getIt.registerLazySingleton<EntityService>(() => const EntityService());
  getIt
      .registerLazySingleton<EntityRepository>(() => EntityRepository(getIt()));
}
