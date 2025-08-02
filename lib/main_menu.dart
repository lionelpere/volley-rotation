import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'volleyball_field.dart';
import 'realistic_volleyball_field.dart';
import 'team_state.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _selectedIndex = 0;

  final List<String> _menuItems = [
    'Base rotation',
    'Base rotation opponent',
  ];

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return const BaseRotationScreen();
      case 1:
        return const OpponentRotationScreen();
      default:
        return const BaseRotationScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(_menuItems[_selectedIndex]),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: isTablet ? _buildTabletLayout() : _buildPhoneLayout(),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        // Menu latéral pour tablette
        Container(
          width: 250,
          color: Colors.grey.shade100,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: _menuItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(
                        index == 0 ? Icons.sports_volleyball : Icons.group,
                        color: _selectedIndex == index
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                      title: Text(
                        _menuItems[index],
                        style: TextStyle(
                          color: _selectedIndex == index
                              ? Theme.of(context).primaryColor
                              : Colors.black87,
                          fontWeight: _selectedIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      selected: _selectedIndex == index,
                      selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Contenu principal
        Expanded(
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildPhoneLayout() {
    return Column(
      children: [
        // Menu horizontal pour téléphone
        Container(
          height: 60,
          color: Colors.grey.shade100,
          child: Row(
            children: _menuItems.asMap().entries.map((entry) {
              int index = entry.key;
              String item = entry.value;
              
              return Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _selectedIndex == index
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        item,
                        style: TextStyle(
                          color: _selectedIndex == index
                              ? Theme.of(context).primaryColor
                              : Colors.black87,
                          fontWeight: _selectedIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // Contenu principal
        Expanded(
          child: _buildContent(),
        ),
      ],
    );
  }
}

class BaseRotationScreen extends StatelessWidget {
  const BaseRotationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: RealisticVolleyballField(isOpponent: false),
    );
  }
}

class OpponentRotationScreen extends StatelessWidget {
  const OpponentRotationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: RealisticVolleyballField(isOpponent: true),
    );
  }
}

class OpponentVolleyballField extends StatefulWidget {
  const OpponentVolleyballField({super.key});

  @override
  State<OpponentVolleyballField> createState() => _OpponentVolleyballFieldState();
}

class _OpponentVolleyballFieldState extends State<OpponentVolleyballField> {
  void _showPlayerDialog(String positionKey, String currentPosition) {
    final teamState = Provider.of<TeamState>(context, listen: false);
    TextEditingController controller = TextEditingController(text: teamState.getOpponentPlayer(positionKey));
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier le joueur adverse - Position $currentPosition'),
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
                teamState.updateOpponentPlayer(positionKey, controller.text);
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
          // Main volleyball court (opponent side - colors changed)
          Container(
            width: 300,
            height: 180,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              color: Colors.red.shade50,
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
                    builder: (context, teamState, child) => OpponentPlayerPosition(
                      number: teamState.getOpponentPlayer('pos4'),
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
                    builder: (context, teamState, child) => OpponentPlayerPosition(
                      number: teamState.getOpponentPlayer('pos3'),
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
                    builder: (context, teamState, child) => OpponentPlayerPosition(
                      number: teamState.getOpponentPlayer('pos2'),
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
                    builder: (context, teamState, child) => OpponentPlayerPosition(
                      number: teamState.getOpponentPlayer('pos5'),
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
                    builder: (context, teamState, child) => OpponentPlayerPosition(
                      number: teamState.getOpponentPlayer('pos6'),
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
                    builder: (context, teamState, child) => OpponentPlayerPosition(
                      number: teamState.getOpponentPlayer('pos1'),
                      position: 'S',
                      onTap: () => _showPlayerDialog('pos1', '1'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Libero aside (opponent - red colors)
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Libero Adverse',
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
                      color: Colors.red.shade700,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        teamState.getOpponentPlayer('libero'),
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

class OpponentPlayerPosition extends StatelessWidget {
  final String number;
  final String position;
  final VoidCallback? onTap;

  const OpponentPlayerPosition({
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
              color: Colors.red.shade600,
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