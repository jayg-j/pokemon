import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/services/pokemon_api.dart';

void main() {
  runApp(const PokemonApp());
}

class PokemonApp extends StatelessWidget {
  const PokemonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEF5350),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const PokemonDetailScreen(pokemonId: 841),
    );
  }
}

class PokemonDetailScreen extends StatefulWidget {
  const PokemonDetailScreen({super.key, required this.pokemonId});

  final int pokemonId;

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  final _api = PokemonApi();
  late Future<Pokemon> _pokemonFuture;

  @override
  void initState() {
    super.initState();
    _pokemonFuture = _api.fetchPokemon(widget.pokemonId);
  }

  void _reload() {
    setState(() {
      _pokemonFuture = _api.fetchPokemon(widget.pokemonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémon #${widget.pokemonId}'),
        centerTitle: true,
      ),
      body: FutureBuilder<Pokemon>(
        future: _pokemonFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _ErrorView(
              message: snapshot.error.toString(),
              onRetry: _reload,
            );
          }

          final pokemon = snapshot.data!;
          return _PokemonView(pokemon: pokemon);
        },
      ),
    );
  }
}

class _PokemonView extends StatelessWidget {
  const _PokemonView({required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName =
        pokemon.name[0].toUpperCase() + pokemon.name.substring(1);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          elevation: 0,
          color: theme.colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                if (pokemon.imageUrl != null)
                  Image.network(
                    pokemon.imageUrl!,
                    height: 220,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.catching_pokemon,
                      size: 120,
                      color: theme.colorScheme.primary,
                    ),
                  )
                else
                  Icon(
                    Icons.catching_pokemon,
                    size: 120,
                    color: theme.colorScheme.primary,
                  ),
                const SizedBox(height: 12),
                Text(
                  displayName,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '#${pokemon.id.toString().padLeft(4, '0')}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: pokemon.types
                      .map((type) => Chip(label: Text(type.toUpperCase())))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _InfoRow(
          label: 'Height',
          value: '${pokemon.height / 10} m',
        ),
        _InfoRow(
          label: 'Weight',
          value: '${pokemon.weight / 10} kg',
        ),
        const SizedBox(height: 8),
        Text(
          'Abilities',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: pokemon.abilities
              .map((ability) => Chip(label: Text(ability)))
              .toList(),
        ),
        const SizedBox(height: 16),
        Text(
          'Base stats',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...pokemon.stats.map((stat) => _StatBar(stat: stat)),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  const _StatBar({required this.stat});

  final PokemonStat stat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (stat.baseStat / 255).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(stat.name.replaceAll('-', ' ').toUpperCase()),
              Text('${stat.baseStat}'),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
