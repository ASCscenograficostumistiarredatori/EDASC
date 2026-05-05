import 'package:hydrated_bloc/hydrated_bloc.dart';

class FirstTimeCubit extends HydratedCubit<bool> {
  FirstTimeCubit() : super(true);

  void setFirstTime(bool value) => emit(value);

  @override
  bool fromJson(Map<String, dynamic> json) {
    return json['value'] as bool? ?? true;
  }

  @override
  Map<String, bool> toJson(bool state) => {'value': state};

  @override
  void onChange(Change<bool> change) {
    print(change.nextState);
    super.onChange(change);
  }
}
