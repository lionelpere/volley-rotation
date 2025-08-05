# Architecture Logicielle - Application de Gestion des Rotations de Volley-ball

## Vue d'ensemble

Cette architecture définit la structure technique et organisationnelle de l'application Flutter de gestion des rotations de volley-ball, basée sur l'analyse fonctionnelle enrichie et les ressources UI existantes.

**Mise à jour** : Cette architecture a été améliorée avec les enseignements de l'application `Volleyball-Simplified`, notamment l'algorithme de rotation, la logique de service, et les patterns UI pour la représentation des terrains.

## 1. Architecture Générale

### 1.1. Pattern Architectural
- **Architecture**: MVVM (Model-View-ViewModel) avec Provider pattern pour la gestion d'état
- **Séparation des responsabilités**: Couches distinctes pour les données, la logique métier, et l'interface utilisateur
- **Flux de données**: Unidirectionnel avec Provider/Consumer pour la synchronisation des états

### 1.2. Structure des Couches
```
├── Presentation Layer (UI)
│   ├── Screens (Écrans principaux)
│   ├── Widgets (Composants réutilisables)
│   └── Themes (Styles et thèmes)
├── Business Logic Layer
│   ├── Providers (État global)
│   ├── Services (Logique métier)
│   └── Managers (Gestion des rotations)
├── Data Layer
│   ├── Models (Structures de données)
│   ├── Repositories (Accès aux données)
│   └── Persistence (Stockage local)
└── Core
    ├── Constants
    ├── Utils
    └── Extensions
```

## 2. Technologies et Librairies

### 2.1. Framework Principal
- **Flutter SDK**: ^3.8.1 (multiplateforme: Web, iOS, Android)
- **Dart**: Langage de programmation

### 2.2. Dépendances Principales
```yaml
dependencies:
  # État et navigation
  provider: ^6.1.2              # Gestion d'état réactive
  go_router: ^13.0.0            # Routing avancé et déclaratif
  
  # Persistance
  shared_preferences: ^2.3.3    # Stockage clé-valeur simple
  hive: ^2.2.3                  # Base de données locale performante
  hive_flutter: ^1.1.0
  
  # UI et Animations
  flutter_animate: ^4.5.0       # Animations fluides
  flutter_staggered_grid_view: ^0.7.0  # Grilles flexibles
  
  # Utilities
  equatable: ^2.0.5             # Comparaisons d'objets simplifiées
  json_annotation: ^4.8.1       # Sérialisation JSON
  
  # Icons
  cupertino_icons: ^1.0.8

dev_dependencies:
  # Code generation
  build_runner: ^2.4.9
  json_serializable: ^6.7.1
  hive_generator: ^2.0.1
  
  # Tests
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4               # Mocking pour tests
  
  # Qualité du code
  flutter_lints: ^5.0.0
  very_good_analysis: ^5.1.0    # Règles lint strictes
```

### 2.3. Technologies d'Interface
- **Material Design 3**: Système de design moderne
- **Custom SVG Rendering**: Pour les terrains de volley-ball détaillés
- **Responsive Design**: Adaptation automatique aux différentes tailles d'écran

## 3. Structure des Écrans et Navigation

### 3.1. Architecture de Navigation
```
MainApp
├── SplashScreen (Chargement initial)
└── MainNavigator
    ├── TeamSetupScreen (Écran 1: Notre équipe)
    ├── OpponentSetupScreen (Écran 2: Équipe adverse)
    ├── RotationViewScreen (Écran 3: Visualisation rotations)
    └── SettingsScreen (Configuration)
```

### 3.2. Détail des Écrans

#### Écran 1: Configuration de Notre Équipe (`TeamSetupScreen`)
**Widgets principaux:**
- `PlayerListWidget`: Liste des joueurs avec ajout/suppression
- `PlayerFormWidget`: Formulaire d'ajout (numéro, nom, libéro)
- `PositionAssignmentWidget`: Interface d'attribution des positions P1-P6
- `StartingPlayerSelector`: Sélecteur du joueur démarrant en P1
- `ValidationWidget`: Affichage des erreurs de validation

#### Écran 2: Configuration Équipe Adverse (`OpponentSetupScreen`)
**Widgets principaux:**
- Identiques à l'Écran 1 mais avec un thème différent
- `OpponentPlayerFormWidget`: Version adaptée pour l'équipe adverse

#### Écran 3: Visualisation des Rotations (`RotationViewScreen`)
**Widgets principaux:**
- `RotationNavigatorWidget`: Navigation entre les 6 rotations
- `CourtVisualizationWidget`: Représentation graphique du terrain
- `PlayerPositionWidget`: Affichage des joueurs sur le terrain
- `NetConfrontationWidget`: Mise en évidence des confrontations au filet
- `ReceptionLineWidget`: Visualisation de la ligne de réception
- `RotationControlsWidget`: Contrôles de navigation et paramètres

### 3.3. Interface Responsive
- **Mobile (< 600px)**: Navigation par onglets en bas
- **Tablette (600-1200px)**: Menu latéral avec contenu principal
- **Desktop (> 1200px)**: Interface complète avec panneaux latéraux

## 4. Modèles de Données

### 4.1. Structure des Modèles
```dart
// Modèle de base pour un joueur
@HiveType(typeId: 0)
class Player extends Equatable {
  @HiveField(0) final String id;
  @HiveField(1) final String? name;
  @HiveField(2) final bool isLibero;
  @HiveField(3) final String? liberoReplacesPlayerId;
  @HiveField(4) final int jerseyNumber;
}

// Modèle pour une équipe complète
@HiveType(typeId: 1)
class Team extends Equatable {
  @HiveField(0) final String id;
  @HiveField(1) final String name;
  @HiveField(2) final List<Player> players;
  @HiveField(3) final Map<Position, String> initialPositions;
  @HiveField(4) final String startingP1PlayerId;
}

// État du terrain pour une rotation spécifique
@HiveType(typeId: 2)
class CourtState extends Equatable {
  @HiveField(0) final int rotationNumber;
  @HiveField(1) final Map<Position, String> ourTeamPositions;
  @HiveField(2) final Map<Position, String> opponentPositions;
  @HiveField(3) final bool ourTeamIsServing;
  @HiveField(4) final LiberoState liberoState;
}

// Gestion complète d'un match
@HiveType(typeId: 3)
class MatchConfiguration extends Equatable {
  @HiveField(0) final String id;
  @HiveField(1) final Team ourTeam;
  @HiveField(2) final Team opponentTeam;
  @HiveField(3) final List<CourtState> rotations;
  @HiveField(4) final DateTime createdAt;
  @HiveField(5) final DateTime lastModified;
}
```

### 4.2. Énumérations
```dart
enum Position { p1, p2, p3, p4, p5, p6 }
enum LiberoState { onCourt, offCourt, rotating }
enum TeamSide { home, visitor }
enum RotationDirection { clockwise, counterClockwise }
```

## 5. Services et Managers

### 5.1. RotationManager (Inspiré Volleyball-Simplified)
**Responsabilités:**
- Génération des 6 rotations pour chaque équipe
- Gestion de la logique de rotation horaire
- Calcul des entrées/sorties du libéro
- Validation des configurations d'équipe

**Algorithme de Rotation (Adapté de useRotationLogic.jsx) :**

```dart
class RotationManager {
  /// Génère toutes les rotations possibles pour un match
  static List<CourtState> generateRotations({
    required Team ourTeam,
    required Team opponentTeam,
    required String ourStartingP1,
    required String opponentStartingP1,
  }) {
    final rotations = <CourtState>[];
    
    // Configuration initiale
    var ourPositions = _setupInitialPositions(ourTeam, ourStartingP1);
    var opponentPositions = _setupInitialPositions(opponentTeam, opponentStartingP1);
    
    // Générer les 6 rotations
    for (int i = 0; i < 6; i++) {
      rotations.add(CourtState(
        rotationNumber: i + 1,
        ourTeamPositions: Map.from(ourPositions),
        opponentPositions: Map.from(opponentPositions),
        ourTeamIsServing: true, // Configurable
        liberoState: _calculateLiberoState(ourPositions, ourTeam),
      ));
      
      // Rotation horaire pour la prochaine itération
      ourPositions = _rotateClockwise(ourPositions);
      opponentPositions = _rotateClockwise(opponentPositions);
    }
    
    return rotations;
  }
  
  /// Rotation horaire: dernier élément -> premier élément
  /// Inspiré de la logique JavaScript de Volleyball-Simplified
  static Map<Position, String> _rotateClockwise(Map<Position, String> positions) {
    final positionOrder = [Position.p1, Position.p2, Position.p3, Position.p4, Position.p5, Position.p6];
    final values = positionOrder.map((pos) => positions[pos]!).toList();
    
    // Dernier élément -> premier élément (rotation horaire)
    final last = values.removeLast();
    values.insert(0, last);
    
    final rotated = <Position, String>{};
    for (int i = 0; i < positionOrder.length; i++) {
      rotated[positionOrder[i]] = values[i];
    }
    
    return rotated;
  }
  
  /// Calcule l'état du libéro selon sa position
  static LiberoState _calculateLiberoState(Map<Position, String> positions, Team team) {
    final libero = team.players.firstWhere((p) => p.isLibero, orElse: () => null);
    if (libero == null) return LiberoState.offCourt;
    
    // Logique: libéro actif en back row uniquement
    final backRowPositions = [Position.p1, Position.p5, Position.p6];
    final isInBackRow = backRowPositions.any((pos) => positions[pos] == libero.id);
    
    return isInBackRow ? LiberoState.onCourt : LiberoState.offCourt;
  }
  
  /// Configuration initiale des positions avec joueur démarrant en P1
  static Map<Position, String> _setupInitialPositions(Team team, String startingP1Id) {
    final positions = <Position, String>{};
    final players = List<String>.from(team.players.map((p) => p.id));
    
    // Placer le joueur démarrant en P1
    positions[Position.p1] = startingP1Id;
    players.remove(startingP1Id);
    
    // Répartir les autres joueurs selon la configuration de l'équipe
    final remainingPositions = [Position.p2, Position.p3, Position.p4, Position.p5, Position.p6];
    for (int i = 0; i < remainingPositions.length; i++) {
      positions[remainingPositions[i]] = players[i];
    }
    
    return positions;
  }
  
  /// Logique de service basée sur Volleyball-Simplified
  static CourtState handleServiceChange(CourtState current, bool ourTeamScored) {
    if (current.ourTeamIsServing && ourTeamScored) {
      // Notre équipe servait et a marqué -> pas de rotation
      return current;
    } else if (!current.ourTeamIsServing && !ourTeamScored) {
      // Équipe adverse servait et a marqué -> pas de rotation
      return current;
    } else {
      // Changement de service -> l'équipe qui gagne le service effectue une rotation
      return current.copyWith(
        ourTeamIsServing: ourTeamScored,
        ourTeamPositions: ourTeamScored 
          ? _rotateClockwise(current.ourTeamPositions)
          : current.ourTeamPositions,
        opponentPositions: !ourTeamScored
          ? _rotateClockwise(current.opponentPositions)
          : current.opponentPositions,
      );
    }
  }
}
```

### 5.2. PersistenceService
**Responsabilités:**
- Sauvegarde/récupération des configurations d'équipe
- Historique des matchs
- Préférences utilisateur
- Cache des données fréquemment utilisées

```dart
class PersistenceService {
  Future<void> saveMatchConfiguration(MatchConfiguration match);
  Future<MatchConfiguration?> loadLastMatch();
  Future<List<Team>> getSavedTeams();
  Future<void> saveTeam(Team team);
}
```

### 5.3. ValidationService
**Responsabilités:**
- Validation des équipes (6 joueurs, unicité des numéros)
- Validation des positions initiales
- Vérification des règles du libéro

## 6. Gestion d'État avec Provider

### 6.1. Providers Principaux
```dart
// État global de l'application
class AppStateProvider extends ChangeNotifier {
  MatchConfiguration? currentMatch;
  bool isLoading = false;
  String? errorMessage;
}

// État spécifique aux équipes
class TeamProvider extends ChangeNotifier {
  Team? ourTeam;
  Team? opponentTeam;
  
  void updateOurTeam(Team team);
  void updateOpponentTeam(Team team);
  void validateTeams();
}

// État des rotations
class RotationProvider extends ChangeNotifier {
  List<CourtState> rotations = [];
  int currentRotationIndex = 0;
  
  void generateRotations();
  void navigateToRotation(int index);
  void nextRotation();
  void previousRotation();
}
```

## 7. Interface Utilisateur - Composants Clés

### 7.1. CourtVisualizationWidget
**Fonctionnalités:**
- Rendu SVG personnalisé du terrain de volley-ball
- Positionnement dynamique des joueurs
- Animations de transition entre rotations
- Mise en évidence des confrontations au filet
- Indication visuelle de la ligne de réception

### 7.2. PlayerPositionWidget
**Fonctionnalités:**
- Affichage des joueurs avec numéro et nom
- Distinction visuelle du libéro
- Indication du serveur
- Couleurs différentes par équipe

### 7.3. RotationControlsWidget
**Fonctionnalités:**
- Navigation fluide entre rotations
- Boutons précédent/suivant
- Indicateur de progression (1/6, 2/6, etc.)
- Retour rapide à la configuration

## 8. Préparation pour Extensions Futures

### 8.1. Architecture API-Ready
```dart
// Interface pour futurs appels API
abstract class RemoteDataSource {
  Future<List<Team>> fetchTeams();
  Future<void> saveTeamToCloud(Team team);
  Future<MatchConfiguration> syncMatch(String matchId);
}

// Repository pattern pour abstraction des données
class TeamRepository {
  final LocalDataSource localDataSource;
  final RemoteDataSource? remoteDataSource;
  
  Future<List<Team>> getTeams() async {
    // Logique de récupération locale/distante
  }
}
```

### 8.2. Extensibilité
- **Plugin architecture**: Prêt pour l'ajout de fonctionnalités (substitutions, statistiques)
- **Theming system**: Support facile de thèmes personnalisés
- **Localization ready**: Structure préparée pour l'internationalisation
- **Export functionality**: Architecture prête pour l'export PDF/image

## 9. Mockups et Prototypes

### 9.1. Mockup Statique - Terrain de Volley-ball
```html
<!-- Mockup HTML/SVG pour le terrain (basé sur volley-court.html existant) -->
<svg width="360" height="540" viewBox="0 0 360 540">
  <!-- Terrain principal -->
  <rect x="30" y="30" width="300" height="480" fill="#f4e4c1" stroke="#2c3e50" stroke-width="3"/>
  
  <!-- Ligne centrale -->
  <line x1="30" y1="270" x2="330" y2="270" stroke="#2c3e50" stroke-width="3"/>
  
  <!-- Lignes d'attaque -->
  <line x1="30" y1="190" x2="330" y2="190" stroke="#2c3e50" stroke-width="2" stroke-dasharray="5,5"/>
  <line x1="30" y1="350" x2="330" y2="350" stroke="#2c3e50" stroke-width="2" stroke-dasharray="5,5"/>
  
  <!-- Filet -->
  <rect x="25" y="265" width="310" height="10" fill="#34495e"/>
  
  <!-- Positions équipe A (Notre équipe) -->
  <g id="teamA">
    <circle cx="270" cy="120" r="20" fill="#3498db" stroke="#2c3e50" stroke-width="2"/>
    <text x="270" y="125" text-anchor="middle" font-size="14" font-weight="bold" fill="white">1</text>
    
    <circle cx="270" cy="220" r="20" fill="#3498db" stroke="#2c3e50" stroke-width="2"/>
    <text x="270" y="225" text-anchor="middle" font-size="14" font-weight="bold" fill="white">2</text>
    
    <circle cx="180" cy="220" r="20" fill="#3498db" stroke="#2c3e50" stroke-width="2"/>
    <text x="180" y="225" text-anchor="middle" font-size="14" font-weight="bold" fill="white">3</text>
    
    <circle cx="90" cy="220" r="20" fill="#3498db" stroke="#2c3e50" stroke-width="2"/>
    <text x="90" y="225" text-anchor="middle" font-size="14" font-weight="bold" fill="white">4</text>
    
    <circle cx="90" cy="120" r="20" fill="#3498db" stroke="#2c3e50" stroke-width="2"/>
    <text x="90" y="125" text-anchor="middle" font-size="14" font-weight="bold" fill="white">5</text>
    
    <circle cx="180" cy="120" r="20" fill="#3498db" stroke="#2c3e50" stroke-width="2"/>
    <text x="180" y="125" text-anchor="middle" font-size="14" font-weight="bold" fill="white">6</text>
    
    <!-- Libéro -->
    <circle cx="60" cy="150" r="18" fill="#85c1e9" stroke="#2c3e50" stroke-width="2"/>
    <text x="60" y="155" text-anchor="middle" font-size="12" font-weight="bold" fill="white">L</text>
  </g>
  
  <!-- Positions équipe B (Adversaire) -->
  <g id="teamB">
    <circle cx="270" cy="420" r="20" fill="#e74c3c" stroke="#2c3e50" stroke-width="2"/>
    <text x="270" y="425" text-anchor="middle" font-size="14" font-weight="bold" fill="white">1</text>
    
    <circle cx="270" cy="320" r="20" fill="#e74c3c" stroke="#2c3e50" stroke-width="2"/>
    <text x="270" y="325" text-anchor="middle" font-size="14" font-weight="bold" fill="white">2</text>
    
    <circle cx="180" cy="320" r="20" fill="#e74c3c" stroke="#2c3e50" stroke-width="2"/>
    <text x="180" y="325" text-anchor="middle" font-size="14" font-weight="bold" fill="white">3</text>
    
    <circle cx="90" cy="320" r="20" fill="#e74c3c" stroke="#2c3e50" stroke-width="2"/>
    <text x="90" y="325" text-anchor="middle" font-size="14" font-weight="bold" fill="white">4</text>
    
    <circle cx="90" cy="420" r="20" fill="#e74c3c" stroke="#2c3e50" stroke-width="2"/>
    <text x="90" y="425" text-anchor="middle" font-size="14" font-weight="bold" fill="white">5</text>
    
    <circle cx="180" cy="420" r="20" fill="#e74c3c" stroke="#2c3e50" stroke-width="2"/>
    <text x="180" y="425" text-anchor="middle" font-size="14" font-weight="bold" fill="white">6</text>
    
    <!-- Libéro -->
    <circle cx="300" cy="390" r="18" fill="#f1948a" stroke="#2c3e50" stroke-width="2"/>
    <text x="300" y="395" text-anchor="middle" font-size="12" font-weight="bold" fill="white">L</text>
  </g>
  
  <!-- Confrontations au filet -->
  <g id="netConfrontations" opacity="0.7">
    <line x1="270" y1="220" x2="270" y2="320" stroke="#f39c12" stroke-width="3"/>
    <line x1="180" y1="220" x2="180" y2="320" stroke="#f39c12" stroke-width="3"/>
    <line x1="90" y1="220" x2="90" y2="320" stroke="#f39c12" stroke-width="3"/>
  </g>
  
  <!-- Légendes -->
  <text x="180" y="15" text-anchor="middle" font-size="16" font-weight="bold">Rotation 1</text>
  <text x="15" y="160" text-anchor="middle" font-size="12" font-weight="bold" transform="rotate(-90 15 160)">NOTRE ÉQUIPE</text>
  <text x="15" y="380" text-anchor="middle" font-size="12" font-weight="bold" transform="rotate(-90 15 380)">ADVERSAIRE</text>
</svg>
```

### 9.2. Structure des Écrans Mobiles
```
┌─────────────────────────┐
│   ⚡ Volley Rotation    │ <- AppBar
├─────────────────────────┤
│                         │
│   [Configuration UI]    │ <- Écrans 1 & 2
│   - Formulaire joueurs  │
│   - Attribution pos.    │
│   - Validation         │
│                         │
├─────────────────────────┤
│  📱 Équipe | 🏐 Adv.   │ <- Navigation
└─────────────────────────┘

┌─────────────────────────┐
│   🏐 Rotation 3/6      │ <- AppBar avec nav.
├─────────────────────────┤
│                         │
│     [Terrain SVG]       │ <- Écran 3
│   Visualisation rotations│
│                         │
├─────────────────────────┤
│   ← 3/6 →  |  ⚙️       │ <- Contrôles
└─────────────────────────┘
```

## 10. Plan de Développement

### Phase 1: Fondations (Sprint 1-2)
1. Setup projet Flutter avec architecture de base
2. Implémentation des modèles de données avec Hive
3. Configuration Provider et services de base
4. Interface de base responsive

### Phase 2: Écrans de Configuration (Sprint 3-4)
1. Écran 1: Configuration notre équipe
2. Écran 2: Configuration équipe adverse  
3. Validation et persistence
4. Navigation entre écrans

### Phase 3: Visualisation des Rotations (Sprint 5-6)
1. Générateur de rotations avec logique libéro
2. Interface de visualisation du terrain SVG
3. Navigation entre rotations
4. Confrontations au filet et ligne de réception

### Phase 4: Polish et Tests (Sprint 7)
1. Tests unitaires et d'intégration
2. Amélioration UX/UI
3. Performance et optimisations
4. Documentation

### Livraisons
- **V1.0**: Application complète selon spécifications fonctionnelles
- **V1.1**: Améliorations UX basées sur feedback utilisateurs
- **V2.0**: Extensions futures (API, statistiques, export)

## Conclusion

Cette architecture fournit une base solide et extensible pour l'application de gestion des rotations de volley-ball. Elle respecte les principes SOLID, utilise des patterns éprouvés, et prépare l'application pour de futures évolutions tout en maintenant une excellente expérience utilisateur sur toutes les plateformes cibles.