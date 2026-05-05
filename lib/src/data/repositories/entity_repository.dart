import 'package:asc/src/data/services/entity_service.dart';
import 'package:either_dart/either.dart';
import 'package:asc/src/data/models/entity.dart';

class EntityRepository {
  const EntityRepository(this.service);

  final EntityService service;

  Future<Either<Exception, EntityModel>> fetchEntity(String id) async {
    try {
      final entity = await service.fetchEntity(id);
      return Right(entity);
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<Either<Exception, List<EntityModel>>> byTag(String id) async {
    try {
      final entities = await service.byTag(id);
      return Right(entities);
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }

  Future<Either<Exception, List<EntityModel>>> fetchAll(
      String searchBy, int limit, int page) async {
    try {
      final entities = await service.fetchAll(searchBy, limit, page);
      return Right(entities);
    } catch (e) {
      return Left(e is Exception ? e : Exception(e.toString()));
    }
  }
}
