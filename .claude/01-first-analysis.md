## Analyse Fonctionnelle de l'Application de Gestion des Rotations de Volley-ball (Format Claude Code)

Cette analyse fonctionnelle détaille les exigences et le comportement attendu de l'application de gestion des rotations de volley-ball. Elle servira de base pour la conception et la mise en œuvre de l'application en Flutter.

**Note :** Cette analyse a été enrichie avec les informations de l'application de référence `Volleyball-Simplified`, qui fournit une excellente base pour comprendre la logique des rotations, les positions des joueurs, et les règles du volley-ball.

### 1. Introduction

L'objectif de cette application est de permettre aux utilisateurs de visualiser et d'organiser les rotations des joueurs de volley-ball. Elle prend en compte les règles standard du jeu, y compris la gestion du libéro. L'application affichera les confrontations au filet et les lignes de réception pour les équipes.

#### 1.1. Règles Fondamentales du Volley-ball (Référence Volleyball-Simplified)

**Système de Zones :**
- Le terrain est divisé en 6 zones numérotées :
  - Zone 1 : Arrière-droite (serveur)
  - Zone 6 : Arrière-centre 
  - Zone 5 : Arrière-gauche
  - Zone 4 : Avant-gauche
  - Zone 3 : Avant-centre (zone du passeur central)
  - Zone 2 : Avant-droite (zone du passeur opposé)

**Logique de Rotation :**
- Les joueurs effectuent une rotation horaire à travers les 6 zones
- La rotation s'effectue uniquement quand l'équipe gagne le service
- Le serveur se trouve toujours en Zone 1
- Après service, les joueurs peuvent se déplacer librement (spécialistion par poste)

**Postes Spécialisés :**
- **Outside Hitter (OH)** : Attaquant côté gauche, joue en front et back row
- **Opposite Hitter (OPP)** : Attaquant côté droit, face au passeur
- **Middle Blocker (MB)** : Spécialiste du bloc et attaques rapides
- **Setter (S)** : "Quarterback" de l'équipe, distribue le jeu
- **Libero (L)** : Spécialiste défensif, back row uniquement
- **Defensive Specialist (DS)** : Défenseur back row
- **Serving Specialist (SS)** : Spécialiste du service

### 2. Exigences Fonctionnelles

L'application sera développée avec une architecture multi-écrans et une persistance des données.

#### 2.1. Gestion des Données et Persistance

*   **Persistance Locale des Données :** Toutes les données saisies par l'utilisateur (joueurs, équipes, configurations de rotation) doivent être stockées localement sur l'appareil.
    *   **Technologie Suggérée :** `shared_preferences` pour des configurations simples, ou `Hive`/`sqflite` pour des structures de données plus complexes et une meilleure performance.
*   **Appels API (Préparation) :** L'architecture doit prévoir des points d'intégration pour de futurs appels API. Ces APIs serviront à sauvegarder et récupérer les données (équipes, configurations de match) lors de la fermeture et de l'ouverture de l'application. Cette fonctionnalité n'est pas requise pour la V1 mais doit être envisagée dans la conception.
    *   **Technologie Suggérée :** Package `http` ou `dio`.

#### 2.2. Écran 1 : Encodage des Joueurs (Notre Équipe)

Cet écran permet de configurer la composition et la position initiale de l'équipe locale.

*   **Saisie des Joueurs :**
    *   **Action :** Ajouter/Supprimer des joueurs.
    *   **Champ 1 :** Numéro du joueur (obligatoire, entier unique par équipe).
    *   **Champ 2 :** Nom du joueur (facultatif, chaîne de caractères).
    *   **Action :** Désigner un joueur comme Libéro.
        *   **Contrainte :** Un seul joueur peut être désigné comme libéro actif par équipe à la fois.
        *   **Affichage :** Le libéro doit être visuellement distinct (ex: couleur de maillot).
    *   **Action :** Indiquer le joueur que le Libéro remplace initialement.
        *   **Contrainte :** Le libéro remplace un joueur en position arrière (P1, P5, P6).
        *   **Logique :** Le libéro entre en jeu pour le joueur remplacé et sort quand ce joueur doit passer en zone avant.
*   **Attribution des Positions Initiales :**
    *   **Action :** Assignation de 6 joueurs aux positions P1, P2, P3, P4, P5, P6 sur un schéma de terrain visuel.
    *   **Règle :** Le joueur en P1 est le premier serveur du set.
*   **Sélection du Joueur Démarrant en P1 :**
    *   **Contrôle :** Un sélecteur (Dropdown ou Radio Buttons) pour choisir quel joueur de notre équipe (par numéro/nom) débutera le set en position P1.
    *   **Par Défaut :** Le passeur est souvent le choix par défaut pour un système 5-1.
*   **Validation :**
    *   **Règle :** Assurer que 6 joueurs sont assignés aux positions de départ.
    *   **Règle :** Vérifier l'unicité des numéros de joueur au sein de l'équipe.

#### 2.3. Écran 2 : Encodage des Joueurs (Équipe Adverse)

Cet écran est fonctionnellement identique à l'Écran 1, mais pour l'équipe adverse.

*   **Fonctionnalités :** Saisie des joueurs (numéro, nom facultatif, désignation libéro), attribution des positions initiales, sélection du joueur démarrant en P1 pour l'équipe adverse.
*   **Validation :** Identique à l'Écran 1.

#### 2.4. Écran 3 : Génération et Affichage des Rotations

Cet écran est le cœur de l'application, affichant les rotations et les interactions.

*   **Paramètres de Rotation :**
    *   **Contrôle :** Sélectionner explicitement le joueur qui commence en P1 pour notre équipe.
    *   **Contrôle :** Sélectionner explicitement le joueur qui commence en P1 pour l'équipe adverse.
*   **Génération des Rotations :**
    *   **Logique :** Générer les 6 rotations complètes pour chaque équipe, en respectant les règles de rotation horaire (lorsque l'équipe gagne le service).
    *   **Logique Libéro :** Intégrer la gestion des entrées/sorties du libéro sans compter comme une substitution régulière. Le libéro sort lorsque le joueur remplacé doit passer en zone avant.
*   **Affichage des Rotations :**
    *   **Présentation :** Affichage clair, schématique et concis des rotations.
    *   **Navigation :** Permettre de naviguer entre les 6 rotations (ex: boutons Précédent/Suivant, indicateurs de page).
    *   **Détails par Rotation :**
        *   **Schéma de Terrain :** Représentation visuelle du terrain avec les 6 joueurs de chaque équipe positionnés (P1 à P6).
        *   **Confrontations au Filet :** Mettre en évidence les joueurs de chaque équipe aux positions d'attaque (P2, P3, P4) et montrer graphiquement les paires adverses au filet.
        *   **Serveur/Réception :**
            *   **Serveur :** Identifier le serveur (joueur en P1 de l'équipe qui sert) pour la rotation donnée.
            *   **Ligne de Réception :** Pour l'équipe en réception, montrer la disposition des joueurs en réception (typiquement P5, P6, P1) et leur alignement par rapport au ballon après le service adverse.
    *   **Affichage Responsive :** Le design doit s'adapter pour être clair et lisible sur Web, Mobile et Tablette.

### 3. Exigences Non Fonctionnelles

*   **Technologie :** Flutter.
*   **Compatibilité :** Web, Mobile (iOS, Android), Tablette (iOS, Android). L'affichage doit être responsive.
*   **Expérience Utilisateur (UX) :** L'interface doit être intuitive, visuellement agréable, avec une navigation simple et des représentations claires.
*   **Performance :** La génération et l'affichage des rotations doivent être rapides et fluides, même avec des logiques complexes.

### 4. Algorithme de Rotation (Basé sur Volleyball-Simplified)

#### 4.1. Logique de Rotation Découverte

L'analyse de `useRotationLogic.jsx` révèle un algorithme simple mais efficace :

```javascript
// Rotation horaire: dernier élément -> premier élément
function rotateTeamClockwise() {
  setTeamPlayers(prev => {
    const arr = [...prev];
    const last = arr.pop();      // Prendre le dernier joueur
    arr.unshift(last);           // Le placer en première position
    return arr;
  });
}
```

**Règles de Rotation Identifiées :**
1. **Rotation Conditionnelle** : Une équipe ne tourne que quand elle gagne le service
2. **Direction** : Rotation horaire (clockwise)
3. **Positions** : Array [P1, P2, P3, P4, P5, P6] où P1 = serveur
4. **Service** : Le joueur en P1 sert toujours

#### 4.2. Gestion du Score et du Service

```javascript
function handleTeamScores() {
  if (teamAServing === 1) {
    // A servait et A gagne => pas de rotation, juste score
    setTeamAScore(newScore);
  } else {
    // B servait et A gagne => A gagne le service => A tourne
    setTeamAScore(newScore);
    rotateTeamAClockwise();
    setTeamAServing(1);
  }
}
```

**Implications pour notre Architecture :**
1. Le service détermine qui peut tourner
2. Seule l'équipe qui gagne le service effectue la rotation
3. Le score et les rotations sont intimement liés

#### 4.3. Positions Terrain (Référence UI)

Les positions découvertes dans `CourtWithPlayers.jsx` :

**Équipe A (Bleu) - Positions relatives :**
- P1 (Serveur) : Position variable selon écran
- P2, P3, P4 : Ligne d'attaque (Front Row)
- P5, P6 : Ligne arrière (Back Row)

**Équipe B (Rouge) - Positions miroir :**
- Même logique mais côté opposé du terrain
- Adaptation responsive selon taille écran

### 5. Modèle de Données Amélioré (Inspiré Volleyball-Simplified)

```dart
// Modèle pour un joueur
class Player {
  final String id; // Identifiant unique (ex: numéro du joueur)
  final String? name; // Nom du joueur (optionnel)
  final bool isLibero; // Vrai si le joueur est un libéro
  final String? liberoReplacesPlayerId; // ID du joueur que le libéro remplace (si applicable)

  Player({
    required this.id,
    this.name,
    this.isLibero = false,
    this.liberoReplacesPlayerId,
  });

  // Méthode pour la sérialisation/désérialisation si nécessaire pour la persistance
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'isLibero': isLibero,
    'liberoReplacesPlayerId': liberoReplacesPlayerId,
  };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    id: json['id'],
    name: json['name'],
    isLibero: json['isLibero'] ?? false,
    liberoReplacesPlayerId: json['liberoReplacesPlayerId'],
  );
}

// Modèle pour une équipe
class Team {
  final String name; // Nom de l'équipe (ex: "Notre Équipe", "Adversaire")
  final List<Player> players; // Liste des 6 joueurs de l'équipe
  final Map<int, String> initialPositions; // Map: Position (1-6) -> Player.id
  final String startingP1PlayerId; // ID du joueur qui commence en P1

  Team({
    required this.name,
    required this.players,
    required this.initialPositions,
    required this.startingP1PlayerId,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'players': players.map((p) => p.toJson()).toList(),
    'initialPositions': initialPositions.map((k, v) => MapEntry(k.toString(), v)), // Convertir les clés int en String pour JSON
    'startingP1PlayerId': startingP1PlayerId,
  };

  factory Team.fromJson(Map<String, dynamic> json) => Team(
    name: json['name'],
    players: (json['players'] as List).map((i) => Player.fromJson(i)).toList(),
    initialPositions: (json['initialPositions'] as Map<String, dynamic>).map((k, v) => MapEntry(int.parse(k), v as String)),
    startingP1PlayerId: json['startingP1PlayerId'],
  );
}

// Modèle pour l'état du terrain pour une rotation spécifique
class CourtState {
  final Map<int, String> ourTeamPlayerAtPosition; // Map: Position (1-6) -> Player.id
  final Map<int, String> opponentTeamPlayerAtPosition; // Map: Position (1-6) -> Player.id
  final bool ourTeamIsServing; // Vrai si notre équipe sert dans cette rotation
  final int rotationNumber; // Numéro de la rotation (1 à 6)

  CourtState({
    required this.ourTeamPlayerAtPosition,
    required this.opponentTeamPlayerAtPosition,
    required this.ourTeamIsServing,
    required this.rotationNumber,
  });

  Map<String, dynamic> toJson() => {
    'ourTeamPlayerAtPosition': ourTeamPlayerAtPosition.map((k, v) => MapEntry(k.toString(), v)),
    'opponentTeamPlayerAtPosition': opponentTeamPlayerAtPosition.map((k, v) => MapEntry(k.toString(), v)),
    'ourTeamIsServing': ourTeamIsServing,
    'rotationNumber': rotationNumber,
  };

  factory CourtState.fromJson(Map<String, dynamic> json) => CourtState(
    ourTeamPlayerAtPosition: (json['ourTeamPlayerAtPosition'] as Map<String, dynamic>).map((k, v) => MapEntry(int.parse(k), v as String)),
    opponentTeamPlayerAtPosition: (json['opponentTeamPlayerAtPosition'] as Map<String, dynamic>).map((k, v) => MapEntry(int.parse(k), v as String)),
    ourTeamIsServing: json['ourTeamIsServing'] ?? false,
    rotationNumber: json['rotationNumber'],
  );
}

// Modèle pour un match complet (pour la persistance et la gestion globale)
class Match {
  final Team ourTeam;
  final Team opponentTeam;
  final List<CourtState> rotations; // Liste des 6 états de terrain pour les rotations

  Match({
    required this.ourTeam,
    required this.opponentTeam,
    required this.rotations,
  });

  Map<String, dynamic> toJson() => {
    'ourTeam': ourTeam.toJson(),
    'opponentTeam': opponentTeam.toJson(),
    'rotations': rotations.map((r) => r.toJson()).toList(),
  };

  factory Match.fromJson(Map<String, dynamic> json) => Match(
    ourTeam: Team.fromJson(json['ourTeam']),
    opponentTeam: Team.fromJson(json['opponentTeam']),
    rotations: (json['rotations'] as List).map((i) => CourtState.fromJson(i)).toList(),
  );
}
```

### 5. Flux Utilisateur (User Flow)

1.  **Démarrage Application :** L'application tente de charger `Match` si existant. Si non, initialisation des `Team`s vides.
2.  **Écran 1 (Notre Équipe) :**
    *   L'utilisateur saisit les `Player`s (id, name, isLibero, liberoReplacesPlayerId).
    *   L'utilisateur assigne `Player.id` aux `initialPositions` (1-6).
    *   L'utilisateur sélectionne `startingP1PlayerId`.
    *   Validation des données.
    *   Action : Naviguer vers Écran 2.
3.  **Écran 2 (Équipe Adverse) :**
    *   L'utilisateur effectue les mêmes saisies que pour l'Écran 1 pour l'équipe adverse.
    *   Validation des données.
    *   Action : Naviguer vers Écran 3.
4.  **Écran 3 (Rotations) :**
    *   L'utilisateur peut re-sélectionner les `startingP1PlayerId` pour les deux équipes si nécessaire.
    *   **Action :** Déclencher la génération des `rotations` (liste de `CourtState`).
    *   Affichage interactif des `CourtState`s, permettant de parcourir les rotations.
    *   Mise en évidence des confrontations au filet et de la ligne de réception pour chaque `CourtState`.
    *   Action : Boutons de navigation (Précédent, Suivant, Revenir aux écrans de configuration).
5.  **Fermeture Application :** Sauvegarde automatique de l'objet `Match` courant localement.

---

### Annexe : Suggestions de Fonctionnalités et Écrans Supplémentaires

Ces suggestions visent à enrichir l'application et à offrir une valeur ajoutée aux utilisateurs.

#### Nouvelles Fonctionnalités :

1.  **Gestion des Substitutions Standard (Hors Libéro) :**
    *   **Description :** Permettre d'enregistrer et de visualiser les 6 substitutions standard par set et par équipe.
    *   **Valeur Ajoutée :** Aide les coachs à suivre les remplacements et à s'assurer qu'ils respectent les règles (nombre de substitutions, impossibilité de remplacer un joueur deux fois par le même joueur s'il est sorti, etc.).
    *   **Intégration :** Un bouton ou une section dédiée dans l'Écran 3 pour ajouter une substitution en cours de rotation, ou un écran de suivi de match.
2.  **Visualisation des Schémas d'Attaque/Défense :**
    *   **Description :** Pour chaque rotation, pouvoir définir et afficher des schémas tactiques simples (ex: zones de défense, trajectoires d'attaque préférées par joueur).
    *   **Valeur Ajoutée :** Transforme l'outil en un assistant tactique pour la planification de match.
    *   **Intégration :** Options d'édition sur l'Écran 3 ou un sous-écran lié à chaque rotation.
3.  **Bibliothèque d'Équipes et de Configurations :**
    *   **Description :** Permettre de sauvegarder des configurations d'équipes complètes (joueurs, positions initiales) et de les réutiliser pour de futurs matchs.
    *   **Valeur Ajoutée :** Gain de temps pour les coachs qui utilisent les mêmes compositions d'équipe ou affrontent les mêmes adversaires régulièrement.
    *   **Intégration :** Un nouvel écran "Mes Équipes" ou "Bibliothèque" accessible depuis le menu principal.
4.  **Mode "Match en Direct" (Suivi de Score et Rotation Automatique) :**
    *   **Description :** L'utilisateur entre les points et l'application fait avancer les rotations automatiquement pour l'équipe qui gagne le service, permettant un suivi dynamique du match.
    *   **Valeur Ajoutée :** Outil de coaching en temps réel, évitant les erreurs de rotation.
    *   **Intégration :** Un nouvel écran "Match Live" avec un tableau de score et des boutons "Point pour nous", "Point pour eux".
5.  **Exportation des Rotations (PDF/Image) :**
    *   **Description :** Possibilité d'exporter les schémas de rotation générés sous forme de fichier PDF ou d'images à partager ou imprimer.
    *   **Valeur Ajoutée :** Utile pour les briefings d'équipe ou l'analyse post-match.
    *   **Intégration :** Un bouton "Exporter" sur l'Écran 3.
6.  **Historique des Matchs :**
    *   **Description :** Conserver un historique des matchs joués, avec les équipes, les rotations utilisées, et potentiellement les scores.
    *   **Valeur Ajoutée :** Analyse des tendances, revue des stratégies passées.
    *   **Intégration :** Un nouvel écran "Historique des Matchs".

#### Écrans Supplémentaires Suggérés :

*   **Écran "Mes Équipes" / "Bibliothèque" :**
    *   **Objectif :** Gérer une liste d'équipes pré-enregistrées.
    *   **Contenu :** Liste des équipes, boutons "Ajouter", "Modifier", "Supprimer", "Charger pour un match".
*   **Écran "Match Live" :**
    *   **Objectif :** Suivre un match en temps réel.
    *   **Contenu :** Tableau de score, indicateur de service, représentation graphique de la rotation actuelle des deux équipes, boutons "Point pour [Équipe]", "Temps Mort", "Substitution".
*   **Écran "Statistiques Simples" :**
    *   **Objectif :** Afficher des statistiques basiques (si le mode "Match Live" est implémenté).
    *   **Contenu :** Score, nombre de services gagnants/perdants, nombre de rotations complètes.
*   **Écran "Paramètres Généraux" :**
    *   **Objectif :** Configurer les préférences de l'application.
    *   **Contenu :** Options pour activer/désactiver les appels API, choix de la langue, réinitialisation des données.

Ces extensions permettraient à l'application de passer d'un simple outil de visualisation de rotations à un assistant de coaching plus complet.