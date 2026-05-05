import 'dart:io';

import 'package:asc/src/core/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  setUp(() => HttpOverrides.global = null);
  //SharedPreferences.setMockInitialValues({});
  test('print artists', () async {
    final supabase = SupabaseClient(
      supabaseUrl,
      supabaseAnonKey,
    );
    final res = await supabase.from('artists').select();
    print(res);
  });
}
