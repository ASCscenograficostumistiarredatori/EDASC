// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  setUp(() => HttpOverrides.global = null);
  SharedPreferences.setMockInitialValues({});
  test('Supabase many-to-many', () async {
    const magazineModel = ModelEntity(
      id: 'magazine',
      name: '',
      description: null,
      fields: [
        ModelFieldEntity(
          id: 'id',
          description: null,
          variable:
              StringVar(id: 'id', name: 'name', data: null, isNullable: true),
          jsonKey: 'id',
        ),
        ModelFieldEntity(
          id: 'title',
          description: null,
          variable: StringVar(
              id: 'title', name: 'name', data: null, isNullable: true),
          jsonKey: 'title',
        ),
      ],
      methods: [],
    );
    const artistModel = ModelEntity(
      id: 'id',
      name: 'name',
      description: null,
      fields: [
        ModelFieldEntity(
          id: 'id',
          description: null,
          variable:
              StringVar(id: 'id', name: 'name', data: null, isNullable: true),
          jsonKey: 'id',
        ),
        ModelFieldEntity(
          id: 'first_name',
          description: null,
          variable: StringVar(
              id: 'first_name', name: 'name', data: null, isNullable: true),
          jsonKey: 'first_name',
        ),
        ModelFieldEntity(
          id: 'last_name',
          description: null,
          variable: StringVar(
              id: 'last_name', name: 'name', data: null, isNullable: true),
          jsonKey: 'last_name',
        ),
        ModelFieldEntity(
          id: 'bio',
          description: null,
          variable:
              StringVar(id: 'bio', name: 'name', data: null, isNullable: true),
          jsonKey: 'bio',
        ),
        ModelFieldEntity(
          id: 'magazines',
          description: null,
          variable: ModelListVar(
              id: 'magazines',
              name: 'name',
              modelID: 'magazine',
              isNullable: true),
          jsonKey: 'magazines',
        ),
      ],
      methods: [],
    );

    await Supabase.initialize(
      url: 'https://baycjzjkhwwrabgaybur.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJheWNqempraHd3cmFiZ2F5YnVyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDkyOTA4MDIsImV4cCI6MjAyNDg2NjgwMn0.9ENv-bqBxI0l7GxvjBNcdeT381eNHKyzikK1wpVtgM4',
    );
    final artists = await Supabase.instance.client.from('artists').select(
        '*, professions(*), magazines(*), bibliography(*), cinematic_works(*), exhibitions(*), interviews(*), scene_photos(*), sketches(*), tags(*), theatre_performances(*), videointerviews(*)');
    print(artists);
    expect(artists, hasLength(1));
    expect(artists.first.containsKey('professions'), true);
    expect(artists.first.containsKey('magazines'), true);
    expect(artists.first.containsKey('bibliography'), true);
    expect(artists.first.containsKey('cinematic_works'), true);
    expect(artists.first.containsKey('exhibitions'), true);
    expect(artists.first.containsKey('interviews'), true);
    expect(artists.first.containsKey('scene_photos'), true);
    expect(artists.first.containsKey('sketches'), true);
    expect(artists.first.containsKey('tags'), true);
    expect(artists.first.containsKey('theatre_performances'), true);
    expect(artists.first.containsKey('videointerviews'), true);

    final model = await artistModel.retrieveModelFromListJson(artists,
        {artistModel.id: artistModel, magazineModel.id: magazineModel});
    print('Converted model: $model');
    expect(model, isNotNull);
    expect(model.first, isNotNull);
    final magazineField =
        model.first.fields.firstWhere((element) => element.id == 'magazines');
    final magazineTitle = (magazineField.variable as ModelListVar)
        .models!
        .first
        .fields
        .firstWhere((element) => element.id == 'title');
    print((magazineTitle.variable as StringVar).data);
    expect((magazineTitle.variable as StringVar).data, 'Magazine n.-1');
  });
}
