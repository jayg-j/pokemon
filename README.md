# Pokémon (Flutter)

Flutter app that loads and displays a Pokémon from the [PokéAPI](https://pokeapi.co/).

The default screen fetches **[Flapple (#841)](https://pokeapi.co/api/v2/pokemon/841)** and shows artwork, types, abilities, and base stats.

## Requirements

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable)
- Network access (live API calls)

## Setup

If platform folders are missing after clone, generate them once:

```bash
flutter create .
flutter pub get
```

## Run

```bash
flutter run
```

## API

Data source: `GET https://pokeapi.co/api/v2/pokemon/841`

To show a different Pokémon, change `pokemonId` in `lib/main.dart` (`PokemonDetailScreen`).
