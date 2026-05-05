// ignore_for_file: avoid_print

import 'dart:io';

import 'package:asc/src/core/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  setUp(() => HttpOverrides.global = null);
  test('Supabase many-to-many', () async {
    final supabase = SupabaseClient(
      supabaseUrl,
      supabaseAnonKey,
    );
    final artists = await supabase
        .from('tags')
        .select('''artists(*, professions(*), tags(*))''')
        .eq('id', 'f7d9eafc-4e53-4af3-9e0a-dcbf0cd04cd3')
        .single();
    print(artists);
  });
}
