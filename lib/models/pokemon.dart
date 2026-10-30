class Pokemon {
  const Pokemon({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.imageUrl,
    required this.types,
    required this.stats,
    required this.abilities,
  });

  final int id;
  final String name;
  final int height;
  final int weight;
  final String? imageUrl;
  final List<String> types;
  final List<PokemonStat> stats;
  final List<String> abilities;

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final sprites = json['sprites'] as Map<String, dynamic>?;
    final other = sprites?['other'] as Map<String, dynamic>?;
    final artwork = other?['official-artwork'] as Map<String, dynamic>?;
    final imageUrl =
        artwork?['front_default'] as String? ?? sprites?['front_default'] as String?;

    final types = (json['types'] as List<dynamic>)
        .map((entry) => (entry['type'] as Map<String, dynamic>)['name'] as String)
        .toList();

    final stats = (json['stats'] as List<dynamic>)
        .map((entry) => PokemonStat.fromJson(entry as Map<String, dynamic>))
        .toList();

    final abilities = (json['abilities'] as List<dynamic>)
        .map((entry) => (entry['ability'] as Map<String, dynamic>)['name'] as String)
        .toList();

    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      height: json['height'] as int,
      weight: json['weight'] as int,
      imageUrl: imageUrl,
      types: types,
      stats: stats,
      abilities: abilities,
    );
  }
}

class PokemonStat {
  const PokemonStat({required this.name, required this.baseStat});

  final String name;
  final int baseStat;

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      name: json['stat']['name'] as String,
      baseStat: json['base_stat'] as int,
    );
  }
}
