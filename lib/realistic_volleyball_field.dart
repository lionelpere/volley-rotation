import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'team_state.dart';

class RealisticVolleyballField extends StatefulWidget {
  final bool isOpponent;
  
  const RealisticVolleyballField({
    super.key,
    this.isOpponent = false,
  });

  @override
  State<RealisticVolleyballField> createState() => _RealisticVolleyballFieldState();
}

class _RealisticVolleyballFieldState extends State<RealisticVolleyballField> {
  void _showPlayerDialog(String positionKey, String currentPosition) {
    final teamState = Provider.of<TeamState>(context, listen: false);
    TextEditingController controller = TextEditingController(
      text: widget.isOpponent 
        ? teamState.getOpponentPlayer(positionKey)
        : teamState.getHomePlayer(positionKey)
    );
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier le joueur${widget.isOpponent ? ' adverse' : ''} - Position $currentPosition'),
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
                if (widget.isOpponent) {
                  teamState.updateOpponentPlayer(positionKey, controller.text);
                } else {
                  teamState.updateHomePlayer(positionKey, controller.text);
                }
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 500;
    
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 10 : 40),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Terrain de volley réaliste
            Stack(
              children: [
                // Zone étendue pour les lignes pointillées
                SizedBox(
                  width: isSmallScreen ? 300 : 380,
                  height: isSmallScreen ? 160 : 200,
                  child: CustomPaint(
                    painter: VolleyballCourtPainter(
                      isOpponent: widget.isOpponent,
                      isSmallScreen: isSmallScreen,
                    ),
                  ),
                ),
                // Position 4 (Attaquant gauche - avant)
                Positioned(
                  left: isSmallScreen ? 70 : 90,
                  top: isSmallScreen ? 40 : 50,
                  child: Consumer<TeamState>(
                    builder: (context, teamState, child) => PlayerPosition(
                      number: widget.isOpponent 
                        ? teamState.getOpponentPlayer('pos4')
                        : teamState.getHomePlayer('pos4'),
                      position: 'OH',
                      onTap: () => _showPlayerDialog('pos4', '4'),
                      isOpponent: widget.isOpponent,
                    ),
                  ),
                ),
                // Position 3 (Central - avant)
                Positioned(
                  left: isSmallScreen ? 130 : 165,
                  top: isSmallScreen ? 40 : 50,
                  child: Consumer<TeamState>(
                    builder: (context, teamState, child) => PlayerPosition(
                      number: widget.isOpponent 
                        ? teamState.getOpponentPlayer('pos3')
                        : teamState.getHomePlayer('pos3'),
                      position: 'MB',
                      onTap: () => _showPlayerDialog('pos3', '3'),
                      isOpponent: widget.isOpponent,
                    ),
                  ),
                ),
                // Position 2 (Attaquant droit - avant)
                Positioned(
                  left: isSmallScreen ? 190 : 240,
                  top: isSmallScreen ? 40 : 50,
                  child: Consumer<TeamState>(
                    builder: (context, teamState, child) => PlayerPosition(
                      number: widget.isOpponent 
                        ? teamState.getOpponentPlayer('pos2')
                        : teamState.getHomePlayer('pos2'),
                      position: 'RS',
                      onTap: () => _showPlayerDialog('pos2', '2'),
                      isOpponent: widget.isOpponent,
                    ),
                  ),
                ),
                // Position 5 (Réceptionneur gauche - arrière)
                Positioned(
                  left: isSmallScreen ? 70 : 90,
                  top: isSmallScreen ? 100 : 120,
                  child: Consumer<TeamState>(
                    builder: (context, teamState, child) => PlayerPosition(
                      number: widget.isOpponent 
                        ? teamState.getOpponentPlayer('pos5')
                        : teamState.getHomePlayer('pos5'),
                      position: 'OH',
                      onTap: () => _showPlayerDialog('pos5', '5'),
                      isOpponent: widget.isOpponent,
                    ),
                  ),
                ),
                // Position 6 (Défenseur central - arrière)
                Positioned(
                  left: isSmallScreen ? 130 : 165,
                  top: isSmallScreen ? 100 : 120,
                  child: Consumer<TeamState>(
                    builder: (context, teamState, child) => PlayerPosition(
                      number: widget.isOpponent 
                        ? teamState.getOpponentPlayer('pos6')
                        : teamState.getHomePlayer('pos6'),
                      position: 'DS',
                      onTap: () => _showPlayerDialog('pos6', '6'),
                      isOpponent: widget.isOpponent,
                    ),
                  ),
                ),
                // Position 1 (Passeur - arrière droit)
                Positioned(
                  left: isSmallScreen ? 190 : 240,
                  top: isSmallScreen ? 100 : 120,
                  child: Consumer<TeamState>(
                    builder: (context, teamState, child) => PlayerPosition(
                      number: widget.isOpponent 
                        ? teamState.getOpponentPlayer('pos1')
                        : teamState.getHomePlayer('pos1'),
                      position: 'S',
                      onTap: () => _showPlayerDialog('pos1', '1'),
                      isOpponent: widget.isOpponent,
                    ),
                  ),
                ),
              ],
            ),
            // Libero à côté
            SizedBox(width: isSmallScreen ? 20 : 40),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.isOpponent ? 'Libero Adverse' : 'Libero',
                  style: const TextStyle(
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
                        color: widget.isOpponent ? Colors.red.shade700 : Colors.red.shade400,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          widget.isOpponent 
                            ? teamState.getOpponentPlayer('libero')
                            : teamState.getHomePlayer('libero'),
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
      ),
    );
  }
}

class VolleyballCourtPainter extends CustomPainter {
  final bool isOpponent;
  final bool isSmallScreen;
  
  VolleyballCourtPainter({
    required this.isOpponent,
    this.isSmallScreen = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint courtPaint = Paint()
      ..color = isOpponent ? Colors.red.shade50 : Colors.orange.shade100
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final Paint netPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final Paint attackLinePaint = Paint()
      ..color = Colors.grey.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint dashedLinePaint = Paint()
      ..color = Colors.grey.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Dimensions adaptées selon la taille d'écran
    final double margin = isSmallScreen ? 40.0 : 55.0;
    final double courtWidth = isSmallScreen ? 220.0 : 270.0;
    final double courtHeight = isSmallScreen ? 110.0 : 135.0;
    final double attackLineDistance = isSmallScreen ? 73.0 : 90.0;
    final double topMargin = isSmallScreen ? 25.0 : 32.5;

    // Demi-terrain principal adapté
    final Rect courtRect = Rect.fromLTWH(margin, topMargin, courtWidth, courtHeight);
    
    // Remplir le terrain
    canvas.drawRect(courtRect, courtPaint);
    
    // Contours épais du terrain
    canvas.drawRect(courtRect, borderPaint);
    
    // Ligne de filet (en bas du demi-terrain)
    final double netY = courtRect.bottom;
    canvas.drawLine(
      Offset(courtRect.left, netY),
      Offset(courtRect.right, netY),
      netPaint,
    );
    
    // Ligne d'attaque à 3m du filet (depuis le bas)
    final double attackLineY = courtRect.bottom - attackLineDistance;
    canvas.drawLine(
      Offset(courtRect.left, attackLineY),
      Offset(courtRect.right, attackLineY),
      attackLinePaint,
    );
    
    // Prolongement en pointillés de la ligne d'attaque
    _drawDashedLine(
      canvas,
      Offset(10, attackLineY),
      Offset(courtRect.left, attackLineY),
      dashedLinePaint,
    );
    _drawDashedLine(
      canvas,
      Offset(courtRect.right, attackLineY),
      Offset(size.width - 10, attackLineY),
      dashedLinePaint,
    );
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const double dashLength = 8.0;
    const double dashSpace = 4.0;
    
    final double totalDistance = (end - start).distance;
    final Offset direction = (end - start) / totalDistance;
    
    double currentDistance = 0.0;
    while (currentDistance < totalDistance) {
      final Offset dashStart = start + direction * currentDistance;
      final double remainingDistance = totalDistance - currentDistance;
      final double currentDashLength = dashLength < remainingDistance ? dashLength : remainingDistance;
      final Offset dashEnd = dashStart + direction * currentDashLength;
      
      canvas.drawLine(dashStart, dashEnd, paint);
      currentDistance += dashLength + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PlayerPosition extends StatelessWidget {
  final String number;
  final String position;
  final VoidCallback? onTap;
  final bool isOpponent;

  const PlayerPosition({
    super.key,
    required this.number,
    required this.position,
    this.onTap,
    this.isOpponent = false,
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
              color: isOpponent ? Colors.red.shade600 : Colors.blue.shade600,
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