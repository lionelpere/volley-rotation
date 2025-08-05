# Claude Code - Volleyball Rotation App

## Structure du projet

Ce projet Flutter implémente une application de gestion des rotations de volley-ball avec les fonctionnalités suivantes :

### Fichiers principaux

- **lib/main.dart** : Point d'entrée de l'application
- **lib/main_menu.dart** : Menu principal responsive avec 3 écrans
- **lib/realistic_volleyball_field.dart** : Terrain de volley avec graphisme 9x9 et ligne du 1er tiers
- **lib/team_state.dart** : État global de l'application (compatible avec l'ancien système)
- **lib/rotation_model.dart** : Modèles de données pour les rotations d'équipe
- **lib/persistence_service.dart** : Service de sauvegarde/récupération des données

### Fonctionnalités

1. **Terrain de volley redessiné** : Format carré 9x9 avec ligne du 1er tiers et pointillés
2. **Gestion des rotations** : Classe `RotationManager` pour encapsuler la logique métier
3. **Sauvegarde automatique** : Persistance des données avec SharedPreferences
4. **Menu responsive** : Interface adaptative web/mobile avec navigation par onglets
5. **Génération de combinaisons** : Écran dédié pour toutes les combinaisons de rotation

### Architecture

- **Modèle de données** : Classes `Player`, `LiberoRotation`, `TeamRotation`, `RotationManager`
- **État de l'application** : Provider pattern avec `TeamState` (wrapper de compatibilité)
- **Persistance** : Service centralisé avec `PersistenceService`
- **Interface utilisateur** : Widgets Flutter responsive

### Commandes utiles

```bash
# Installation des dépendances
flutter pub get

# Lancement en mode debug
flutter run

# Build pour le web
flutter build web

# Build pour Android
flutter build apk

# Tests
flutter test
```

### Dépendances

- `provider: ^6.1.2` : Gestion d'état
- `shared_preferences: ^2.3.3` : Persistance locale
- `cupertino_icons: ^1.0.8` : Icônes iOS

### Notes importantes

- Le système est rétrocompatible avec l'ancienne structure
- Les données sont sauvegardées automatiquement à chaque modification
- Le terrain respecte les dimensions 9x9 avec ligne du 1er tiers
- L'interface s'adapte automatiquement aux différentes tailles d'écran