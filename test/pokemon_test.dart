import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon/models/pokemon.dart';

void main() {
  test('Pokemon.fromJson parses core fields', () {
    final pokemon = Pokemon.fromJson({
      'id': 841,
      'name': 'flapple',
      'height': 3,
      'weight': 10,
      'sprites': {
        'front_default': 'https://example.com/841.png',
        'other': {
          'official-artwork': {
            'front_default': 'https://example.com/art/841.png',
          },
        },
      },
      'types': [
        {
          'type': {'name': 'grass'},
        },
        {
          'type': {'name': 'dragon'},
        },
      ],
      'stats': [
        {
          'base_stat': 70,
          'stat': {'name': 'hp'},
        },
      ],
      'abilities': [
        {
          'ability': {'name': 'ripen'},
        },
      ],
    });

    expect(pokemon.id, 841);
    expect(pokemon.name, 'flapple');
    expect(pokemon.imageUrl, 'https://example.com/art/841.png');
    expect(pokemon.types, ['grass', 'dragon']);
    expect(pokemon.stats.first.baseStat, 70);
    expect(pokemon.abilities, ['ripen']);
  });
}
