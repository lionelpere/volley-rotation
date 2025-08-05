import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'business_logic/volleyball_business_logic.dart';

class VolleyballField extends StatefulWidget {
  const VolleyballField({super.key});

  @override
  State<VolleyballField> createState() => _VolleyballFieldState();
}

class _VolleyballFieldState extends State<VolleyballField> {
  late RotationProvider rotationProvider;

  @override
  void initState() {
    super.initState();
    rotationProvider = RotationProvider();
    _initializeTeam();
  }

  void _initializeTeam() {
    // Initialize with simple player positions
    final initialPositions = {
      Position.p1: '1',
      Position.p2: '2',
      Position.p3: '3',
      Position.p4: '4',
      Position.p5: '5',
      Position.p6: '6',
    };
    
    
    final courtState = CourtState(
      rotationNumber: 1,
      homeTeamPositions: initialPositions,
      visitorTeamPositions: {},
      homeTeamIsServing: true,
    );
    
    rotationProvider.setCurrentRotation(courtState);
  }

  void _showPlayerDialog(Position position) {
    final currentPlayer = rotationProvider.currentRotation?.homeTeamPositions[position] ?? '';
    TextEditingController controller = TextEditingController(text: currentPlayer);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier le joueur - Position ${position.name}'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Numéro du joueur',
              hintText: 'Ex: 10, 15, L...',
            ),
            maxLength: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                rotationProvider.updatePlayerAtPosition(position, controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Valider'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRotationControls() {
    return Consumer<RotationProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Rotation info
              Column(
                children: [
                  Text(
                    'Rotation ${provider.currentRotation?.rotationNumber ?? 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    provider.currentRotation?.homeTeamIsServing == true 
                      ? 'Home Team Serving'
                      : 'Away Team Serving',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              // Control buttons
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => provider.rotateClockwise(),
                    icon: const Icon(Icons.rotate_right),
                    label: const Text('Rotate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => provider.handleServiceChange(true),
                    icon: const Icon(Icons.sports_volleyball),
                    label: const Text('Home Point'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => provider.handleServiceChange(false),
                    icon: const Icon(Icons.sports_volleyball),
                    label: const Text('Away Point'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: rotationProvider,
      child: Column(
        children: [
          // Rotation Controls
          _buildRotationControls(),
          const SizedBox(height: 20),
          // Court Container
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Main volleyball court
                Container(
                  width: 400,
                  height: 350,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 4),
                    color: Colors.orange.shade200,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Team A Label
                      Positioned(
                        top: -5,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Home Team',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Net line in the middle
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 172,
                        child: Container(
                          height: 4,
                          color: Colors.black,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                              child: const Text(
                                'NET',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Attack line - front court
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 116,
                        child: Container(
                          height: 2,
                          color: Colors.white,
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                'Attack Line',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  backgroundColor: Colors.orange,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Attack line - back court
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 228,
                        child: Container(
                          height: 2,
                          color: Colors.white,
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text(
                                'Attack Line',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  backgroundColor: Colors.orange,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Position 4 (Outside Hitter - Front Left)
                      Positioned(
                        left: 60,
                        top: 60,
                        child: Consumer<RotationProvider>(
                          builder: (context, provider, child) => PlayerPosition(
                            playerId: provider.currentRotation?.homeTeamPositions[Position.p4] ?? '4',
                            position: Position.p4,
                            onTap: () => _showPlayerDialog(Position.p4),
                          ),
                        ),
                      ),
                      // Position 3 (Middle Blocker - Front Center)
                      Positioned(
                        left: 175,
                        top: 60,
                        child: Consumer<RotationProvider>(
                          builder: (context, provider, child) => PlayerPosition(
                            playerId: provider.currentRotation?.homeTeamPositions[Position.p3] ?? '3',
                            position: Position.p3,
                            onTap: () => _showPlayerDialog(Position.p3),
                          ),
                        ),
                      ),
                      // Position 2 (Right Side - Front Right)
                      Positioned(
                        left: 290,
                        top: 60,
                        child: Consumer<RotationProvider>(
                          builder: (context, provider, child) => PlayerPosition(
                            playerId: provider.currentRotation?.homeTeamPositions[Position.p2] ?? '2',
                            position: Position.p2,
                            onTap: () => _showPlayerDialog(Position.p2),
                          ),
                        ),
                      ),
                      // Position 5 (Outside Hitter - Back Left)
                      Positioned(
                        left: 60,
                        top: 260,
                        child: Consumer<RotationProvider>(
                          builder: (context, provider, child) => PlayerPosition(
                            playerId: provider.currentRotation?.homeTeamPositions[Position.p5] ?? '5',
                            position: Position.p5,
                            onTap: () => _showPlayerDialog(Position.p5),
                          ),
                        ),
                      ),
                      // Position 6 (Libero/DS - Back Center)
                      Positioned(
                        left: 175,
                        top: 260,
                        child: Consumer<RotationProvider>(
                          builder: (context, provider, child) => PlayerPosition(
                            playerId: provider.currentRotation?.homeTeamPositions[Position.p6] ?? '6',
                            position: Position.p6,
                            onTap: () => _showPlayerDialog(Position.p6),
                          ),
                        ),
                      ),
                      // Position 1 (Setter - Back Right)
                      Positioned(
                        left: 290,
                        top: 260,
                        child: Consumer<RotationProvider>(
                          builder: (context, provider, child) => PlayerPosition(
                            playerId: provider.currentRotation?.homeTeamPositions[Position.p1] ?? '1',
                            position: Position.p1,
                            onTap: () => _showPlayerDialog(Position.p1),
                          ),
                        ),
                      ),
                      // Server indicator for Position 1
                      Consumer<RotationProvider>(
                        builder: (context, provider, child) {
                          if (provider.currentRotation?.homeTeamIsServing == true) {
                            return Positioned(
                              left: 240,
                              top: 290,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.blue, width: 2),
                                ),
                                child: const Text(
                                  'SERVER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
                // Libero info section
                const SizedBox(width: 20),
                Consumer<RotationProvider>(
                  builder: (context, provider, child) => _buildLiberoSection(provider),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiberoSection(RotationProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Libero Status',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Column(
            children: [
              Icon(
                Icons.sports_volleyball,
                color: Colors.red.shade600,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                provider.currentRotation?.homeLiberoState.description ?? 'Off Court',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => provider.toggleLiberoSubstitution(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade400,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text(
            'Toggle Libero',
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class PlayerPosition extends StatelessWidget {
  final String playerId;
  final Position position;
  final VoidCallback? onTap;

  const PlayerPosition({
    super.key,
    required this.playerId,
    required this.position,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isServer = position == Position.p1;
    final color = isServer ? Colors.green.shade600 : Colors.blue.shade600;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Text(
                playerId,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          position.shortName,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}