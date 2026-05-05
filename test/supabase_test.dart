// ignore_for_file: avoid_print

import 'dart:io';

import 'package:asc/src/core/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  setUp(() => HttpOverrides.global = null);
  test('Supabase many-to-many', () async {
    final supabase = SupabaseClient(
      supabaseUrl,
      supabaseAnonKey,
    );
    final artists = await supabase
        .from('artists')
        .select('''*, 
        professions(*), 
        magazines(*), 
        bibliography(*), 
        cinematic_works(*), 
        exhibitions(*), 
        interviews(*), 
        scene_photos(*), 
        sketches(*), 
        tags(*), 
        theatre_performances(*), 
        videointerviews(*)''')
        .eq('id', 'debb25a8-e06a-408f-8154-beec963cef07')
        .single();
    print(artists);
    expect(artists.containsKey('professions'), true);
    expect(artists.containsKey('magazines'), true);
    expect(artists.containsKey('bibliography'), true);
    expect(artists.containsKey('cinematic_works'), true);
    expect(artists.containsKey('exhibitions'), true);
    expect(artists.containsKey('interviews'), true);
    expect(artists.containsKey('scene_photos'), true);
    expect(artists.containsKey('sketches'), true);
    expect(artists.containsKey('tags'), true);
    expect(artists.containsKey('theatre_performances'), true);
    expect(artists.containsKey('videointerviews'), true);
  });
}
