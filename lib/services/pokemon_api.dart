import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokemon/models/pokemon.dart';

class PokemonApi {
  PokemonApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  Future<Pokemon> fetchPokemon(int id) async {
    final response = await _client.get(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode != 200) {
      throw PokemonApiException(
        'Failed to load Pokémon #$id (${response.statusCode})',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Pokemon.fromJson(json);
  }
}

class PokemonApiException implements Exception {
  PokemonApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
