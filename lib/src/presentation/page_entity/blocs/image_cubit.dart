import 'package:flutter_bloc/flutter_bloc.dart';

class ImageCubit extends Cubit<String?> {
  ImageCubit() : super(null);

  void focus(String image) => emit(image);
  void unfocus() => emit(null);
}
