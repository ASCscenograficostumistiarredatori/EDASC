import 'package:asc/src/core/constants.dart';

/// Host dello storage del progetto Supabase dismesso.
///
/// Storicamente l'app girava sul progetto `zlntcwuxekavvhzqhbxz`. Quando si e'
/// passati al progetto attuale i file sono stati ricopiati nel nuovo bucket,
/// ma le righe gia' presenti nel database contengono ancora URL **assoluti**
/// verso il vecchio host: sono stringhe salvate dentro le colonne (e dentro
/// blob HTML come `settings.credits_page` e `settings.logos_page`), non
/// riferimenti calcolati a runtime.
///
/// Il risultato e' che, pur avendo un solo endpoint configurato, l'app
/// finirebbe per scaricare una parte dei media da un progetto diverso.
const _legacyStorageHost = 'zlntcwuxekavvhzqhbxz.supabase.co';

/// Host dello storage del progetto realmente in uso.
///
/// Derivato da [supabaseUrl] e non scritto a mano: se un domani si cambia di
/// nuovo progetto basta aggiornare `constants.dart` e la migrazione segue.
final _currentStorageHost = Uri.parse(supabaseUrl).host;

/// Riscrive gli URL che puntano allo storage del progetto dismesso facendoli
/// puntare a quello attuale.
///
/// Opera sull'intera stringa, quindi funziona sia su una colonna che contiene
/// un singolo URL sia su un blob HTML che ne contiene molti.
String migrateLegacyStorageUrls(String value) {
  // Se `supabaseUrl` non fosse parsabile l'host risulterebbe vuoto: in quel
  // caso e' piu' sicuro non toccare nulla che produrre URL monchi.
  if (_currentStorageHost.isEmpty) return value;
  return value.replaceAll(_legacyStorageHost, _currentStorageHost);
}

/// Normalizza una risposta Supabase perche' ogni URL al suo interno punti
/// all'unico endpoint in uso.
///
/// Va applicata a **tutte** le risposte prima di passarle ai `fromJson`: e' il
/// punto unico in cui si garantisce che nessuna parte dell'app finisca a
/// leggere media da un progetto diverso da quello configurato.
///
/// La normalizzazione avviene sul posto e viene restituita la stessa istanza:
/// cosi' il tipo a runtime resta quello originale (`List<Map<String, dynamic>>`
/// per una select, `Map<String, dynamic>` per una single) e i chiamanti non
/// hanno bisogno di alcun cast.
T normalizeSupabasePayload<T>(T payload) {
  if (payload is String) {
    return migrateLegacyStorageUrls(payload) as T;
  }
  _normalizeInPlace(payload);
  return payload;
}

/// Attraversa mappe e liste annidate riscrivendo ogni stringa incontrata.
void _normalizeInPlace(dynamic node) {
  if (node is Map) {
    for (final key in node.keys.toList()) {
      final value = node[key];
      if (value is String) {
        node[key] = migrateLegacyStorageUrls(value);
      } else {
        _normalizeInPlace(value);
      }
    }
    return;
  }
  if (node is List) {
    for (var i = 0; i < node.length; i++) {
      final value = node[i];
      if (value is String) {
        node[i] = migrateLegacyStorageUrls(value);
      } else {
        _normalizeInPlace(value);
      }
    }
  }
}
