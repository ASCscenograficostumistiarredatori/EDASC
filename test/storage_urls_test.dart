import 'dart:convert';

import 'package:asc/src/core/constants.dart';
import 'package:asc/src/core/storage_urls.dart';
import 'package:flutter_test/flutter_test.dart';

/// Host del progetto Supabase dismesso: non deve sopravvivere alla
/// normalizzazione in nessun punto delle risposte.
const legacyHost = 'zlntcwuxekavvhzqhbxz.supabase.co';

String get currentHost => Uri.parse(supabaseUrl).host;

void main() {
  group('migrateLegacyStorageUrls', () {
    test('riscrive un singolo URL', () {
      final migrato = migrateLegacyStorageUrls(
        'https://$legacyHost/storage/v1/object/public/assets/images/foto.jpg',
      );

      expect(
        migrato,
        'https://$currentHost/storage/v1/object/public/assets/images/foto.jpg',
      );
      expect(migrato.contains(legacyHost), isFalse);
    });

    test('riscrive tutti gli URL dentro un blob HTML', () {
      final html = '<div>'
          '<img src="https://$legacyHost/storage/v1/object/public/assets/Credits%20Page/logo%20EDASC-red%202.png"/>'
          '<img src="https://$legacyHost/storage/v1/object/public/assets/Credits%20Page/Logo-TOCC-%201.png"/>'
          '</div>';

      final migrato = migrateLegacyStorageUrls(html);

      expect(migrato.contains(legacyHost), isFalse);
      expect(currentHost.allMatches(migrato).length, 2);
      // Il resto del markup non deve essere toccato.
      expect(migrato.contains('logo%20EDASC-red%202.png'), isTrue);
      expect(migrato.contains('Logo-TOCC-%201.png'), isTrue);
    });

    test('lascia intatte le stringhe che non contengono il vecchio host', () {
      const url = 'https://edasc1.wordpress.com/';
      expect(migrateLegacyStorageUrls(url), url);
    });
  });

  group('normalizeSupabasePayload', () {
    test('nessun riferimento al vecchio host sopravvive in una risposta '
        'annidata', () {
      // Forma realistica: una select con relazioni annidate e un blob HTML.
      final risposta = <String, dynamic>{
        'id': 'abc',
        'profile_picture':
            'https://$legacyHost/storage/v1/object/public/assets/images/artista.jpg',
        'credits_page':
            '<img src="https://$legacyHost/storage/v1/object/public/assets/a.png"/>',
        'magazines': <Map<String, dynamic>>[
          {
            'image_url':
                'https://$legacyHost/storage/v1/object/public/assets/images/riv.jpeg',
            'pdf_url':
                'https://$legacyHost/storage/v1/object/public/assets/PDF/riv.pdf',
          },
        ],
        'map_pin': <Map<String, dynamic>>[
          {
            'image': null,
            'latitude': 41.9,
          },
        ],
      };

      final normalizzata = normalizeSupabasePayload(risposta);

      // Il guard che conta: serializzo tutto e cerco l'host legacy.
      expect(jsonEncode(normalizzata).contains(legacyHost), isFalse);
      expect(
        normalizzata['profile_picture'],
        'https://$currentHost/storage/v1/object/public/assets/images/artista.jpg',
      );
      expect(
        (normalizzata['magazines'] as List).first['pdf_url'],
        'https://$currentHost/storage/v1/object/public/assets/PDF/riv.pdf',
      );
      // I valori non stringa restano intatti.
      expect((normalizzata['map_pin'] as List).first['image'], isNull);
      expect((normalizzata['map_pin'] as List).first['latitude'], 41.9);
    });

    test('preserva il tipo a runtime di una select (List<Map<String, '
        'dynamic>>)', () {
      // Una `.select()` di supabase restituisce esattamente questo tipo: se la
      // normalizzazione lo degradasse, i `fromJsonList` esistenti si
      // romperebbero.
      final righe = <Map<String, dynamic>>[
        {
          'url':
              'https://$legacyHost/storage/v1/object/public/assets/images/a.jpg'
        },
      ];

      final normalizzate = normalizeSupabasePayload(righe);

      expect(normalizzate, isA<List<Map<String, dynamic>>>());
      expect(jsonEncode(normalizzate).contains(legacyHost), isFalse);
    });

    test('gestisce il null di una maybeSingle()', () {
      final Map<String, dynamic>? vuoto = null;
      expect(normalizeSupabasePayload(vuoto), isNull);
    });

    test('normalizza anche una stringa passata direttamente', () {
      final migrato = normalizeSupabasePayload(
        'https://$legacyHost/storage/v1/object/public/assets/x.png',
      );
      expect(migrato.contains(legacyHost), isFalse);
    });
  });
}
