import 'package:asc/src/data/models/entity.dart';
import 'package:asc/src/data/repositories/entity_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._repository) : super(const HomeLoading());

  final EntityRepository _repository;

  void load(Function() onDone, Function(String) onError) {
    _repository.fetchAll('', 80, 0).then((result) {
      result.fold(
        (l) => onError(l.toString()),
        (r) => {
          emit(HomeLoaded(r)),
          onDone(),
        },
      );
    });
  }

  void search(String searchBy, Function(String) onError) {
    _repository.fetchAll(searchBy, 80, 0).then((result) {
      result.fold(
        (l) => onError(l.toString()),
        (r) => emit(HomeLoaded(r)),
      );
    });
  }
}

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeLoading extends HomeState {
  const HomeLoading();

  @override
  List<Object> get props => [];
}

class HomeLoaded extends HomeState {
  const HomeLoaded(this.entities);

  final List<EntityModel> entities;

  @override
  List<Object> get props => [entities];
}
