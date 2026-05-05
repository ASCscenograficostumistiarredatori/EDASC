import 'package:asc/src/data/models/entity.dart';
import 'package:asc/src/data/repositories/entity_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EntityCubit extends Cubit<EntityState> {
  EntityCubit(this._repository) : super(const EntityLoading());

  final EntityRepository _repository;

  void load(
    String id,
    Function(String) onError,
  ) {
    _repository.fetchEntity(id).then(
          (res) => res.fold(
            (l) => onError(l.toString()),
            (r) => emit(EntityLoaded(r)),
          ),
        );
  }
}

abstract class EntityState extends Equatable {
  const EntityState();
}

class EntityLoading extends EntityState {
  const EntityLoading();

  @override
  List<Object?> get props => [];
}

class EntityLoaded extends EntityState {
  const EntityLoaded(
    this.entity,
  );

  final EntityModel entity;

  @override
  List<Object?> get props => [entity];
}
