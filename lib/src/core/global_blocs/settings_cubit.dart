import 'package:asc/src/core/constants.dart';
import 'package:asc/src/core/storage_urls.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsLoading());

  Future<void> init() async {
    try {
      final res = normalizeSupabasePayload(
          await supabase.from('settings').select().limit(1).maybeSingle());
      emit(SettingsLoaded(
        showLogosPage: res?['show_logos_page'] as bool? ?? true,
        introImage: res?['onboarding_image_url'] as String?,
      ));
    } catch (e) {
      emit(SettingsError(error: '$e'.replaceFirst('Exception: ', '')));
    }
  }
}

abstract class SettingsState {
  const SettingsState();
}

class SettingsLoading extends SettingsState {}

class SettingsError extends SettingsState {
  const SettingsError({
    required this.error,
  });
  final String error;
}

class SettingsLoaded extends SettingsState {
  const SettingsLoaded({
    required this.showLogosPage,
    required this.introImage,
  });

  final bool showLogosPage;

  /// URL dell'immagine di onboarding servita da Supabase.
  /// Null quando la colonna non e' valorizzata: in quel caso la UI ricade
  /// sull'asset locale.
  final String? introImage;
}
