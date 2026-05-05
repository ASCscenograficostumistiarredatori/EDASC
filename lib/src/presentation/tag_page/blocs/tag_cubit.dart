import 'package:asc/src/data/models/entity.dart';
import 'package:asc/src/data/repositories/entity_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TagCubit extends Cubit<TagState> {
  TagCubit(this._entityRepository) : super(TagLoading());

  final EntityRepository _entityRepository;

  void load(String id, Function(String) onError) {
    _entityRepository.byTag(id).then((res) =>
        res.fold((l) => onError(l.toString()), (r) => emit(TagLoaded(r))));
  }
}

abstract class TagState extends Equatable {
  const TagState();
}

class TagLoading extends TagState {
  @override
  List<Object> get props => [];
}

class TagLoaded extends TagState {
  final List<EntityModel> entities;

  const TagLoaded(this.entities);

  @override
  List<Object> get props => [entities];
}
