import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

const supabaseUrl = 'https://vgxrvicfihostevcqykq.supabase.co';
const supabaseAnonKey = 'sb_publishable_X5RQt-__Nm2FnupJBteI2g_TeAf9sjA';
const supabaseStorageCompatibilitySplitPattern =
    '.supabase.co/storage/v1/object/public/assets/';
const supabaseStorageCompatibilitySplitReplacement =
    '$supabaseUrl/storage/v1/object/public/assets/';

String normalizeSupabaseStorageUrl(String url) {
  if (url.isEmpty) return url;
  // Senza questo controllo un URL che non sia dello storage Supabase (per
  // esempio un video YouTube) verrebbe comunque riscritto e reso invalido:
  // `split` su un separatore assente restituisce l'intera stringa, che
  // finirebbe concatenata al percorso del bucket.
  if (!url.contains(supabaseStorageCompatibilitySplitPattern)) return url;
  final relativeUrl = url.split(supabaseStorageCompatibilitySplitPattern).last;
  return '$supabaseStorageCompatibilitySplitReplacement$relativeUrl';
}
