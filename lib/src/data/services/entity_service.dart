import 'package:asc/src/core/constants.dart';
import 'package:asc/src/data/models/entity.dart';

class EntityService {
  const EntityService();

  Future<EntityModel> fetchEntity(String id) async {
    final res = await supabase
        .from('artists')
        .select(
            '*, professions(*), magazines(*), bibliography(*), cinematic_works(*), exhibitions(*), interviews(*), scene_photos(*), sketches(*), tags(*), theatre_performances(*), videointerviews(*), map_pin(*), custom_folders(*)')
        .eq('url_id', id)
        .single();
    return EntityModel.fromJson(res);
  }

  Future<List<EntityModel>> byTag(String id) async {
    final res = await supabase
        .from('tags')
        .select('artists(*, professions(*), tags(*))')
        .eq('id', id)
        .single();
    return EntityModel.fromJsonList(res['artists']);
  }

  Future<List<EntityModel>> fetchAll(
      String searchBy, int limit, int page) async {
    if (searchBy.isEmpty) {
      final res = await supabase.from('artists').select('*, professions(*)');
      return EntityModel.fromJsonList(res);
    }
    final res = await supabase.from('artists').select('*, professions(*)').or(
        'first_name.ilike.%$searchBy%, last_name.ilike.%$searchBy%, url_id.ilike.%${searchBy.replaceAll(' ', '-')}%');
    return EntityModel.fromJsonList(res);
  }
}
