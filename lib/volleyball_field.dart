import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'team_state.dart';

class VolleyballField extends StatefulWidget {
  const VolleyballField({super.key});

  @override
  State<VolleyballField> createState() => _VolleyballFieldState();
}

class _VolleyballFieldState extends State<VolleyballField> {
  void _showPlayerDialog(String positionKey, String currentPosition) {
    final teamState = Provider.of<TeamState>(context, listen: false);
    TextEditingController controller = TextEditingController(text: teamState.getHomePlayer(positionKey));
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier le joueur - Position $currentPosition'),
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
                teamState.updateHomePlayer(positionKey, controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Valider'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Main volleyball court
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              color: Colors.orange.shade100,
            ),
            child: Stack(
              children: [
                // Net line in the middle
                Positioned(
                  left: 0,
                  right: 0,
                  top: 88.5,
                  child: Container(
                    height: 3,
                    color: Colors.black,
                  ),
                ),
                // Attack line - front court
                Positioned(
                  left: 0,
                  right: 0,
                  top: 60,
                  child: Container(
                    height: 2,
                    color: Colors.grey.shade600,
                  ),
                ),
                // Attack line - back court
                Positioned(
                  left: 0,
                  right: 0,
                  top: 117,
                  child: Container(
                    height: 2,
                    color: Colors.grey.shade600,
                  ),
                ),
                // Position 4 (Outside Hitter - Front Left)
                Positioned(
                  left: 40,
                  top: 30,
                  child: Consumer<TeamState>(
                    builder: (context, teamState, child) => PlayerPosition(
                      number: teamState.getHomePlayer('pos4'),
                      position: 'OH',
                      onTap: () => _showPlayerDialog('pos4', '4'),
                    ),
                  ),
                ),
                // Position 3 (Middle Blocker - Front Center)
                Positioned(
                  left: 125,
                  top: 30,
                  child: Consumer<TeamState>(
                    builder: (context, teamState, child) => PlayerPosition(
                      number: teamState.getHomePlayer('pos3'),
                      position: 'MB',
                      onTap: () => _showPlayerDialog('pos3', '3'),
                    ),
                  ),
                ),
                // Position 2 (Right Side - Front Right)
                Positioned(
                  left: 210,
                  top: 30,
                  child: Consumer<TeamState>(
                    builder: (context, teamState, child) => PlayerPosition(
                      number: teamState.getHomePlayer('pos2'),
                      position: 'RS',
                      onTap: () => _showPlayerDialog('pos2', '2'),
                    ),
                  ),
                ),
                // Position 5 (Outside Hitter - Back Left)
                Positioned(
                  left: 40,
                  top: 135,
                  child: Consumer<TeamState>(
                    builder: (context, teamState, child) => PlayerPosition(
                      number: teamState.getHomePlayer('pos5'),
                      position: 'OH',
                      onTap: () => _showPlayerDialog('pos5', '5'),
                    ),
                  ),
                ),
                // Position 6 (Libero/DS - Back Center)
                Positioned(
                  left: 125,
                  top: 135,
                  child: Consumer<TeamState>(
                    builder: (context, teamState, child) => PlayerPosition(
                      number: teamState.getHomePlayer('pos6'),
                      position: 'DS',
                      onTap: () => _showPlayerDialog('pos6', '6'),
                    ),
                  ),
                ),
                // Position 1 (Setter - Back Right)
                Positioned(
                  left: 210,
                  top: 135,
                  child: Consumer<TeamState>(
                    builder: (context, teamState, child) => PlayerPosition(
                      number: teamState.getHomePlayer('pos1'),
                      position: 'S',
                      onTap: () => _showPlayerDialog('pos1', '1'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Libero aside
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Libero',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Consumer<TeamState>(
                builder: (context, teamState, child) => GestureDetector(
                  onTap: () => _showPlayerDialog('libero', 'Libéro'),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        teamState.getHomePlayer('libero'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Libero',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PlayerPosition extends StatelessWidget {
  final String number;
  final String position;
  final VoidCallback? onTap;

  const PlayerPosition({
    super.key,
    required this.number,
    required this.position,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          position,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}