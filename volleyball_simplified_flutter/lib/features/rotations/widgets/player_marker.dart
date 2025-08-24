import 'package:flutter/material.dart';

import '../../../core/constants/app_dimensions.dart';

/// Player marker widget for volleyball court
class PlayerMarker extends StatelessWidget {
  final String playerId;
  final Color teamColor;
  final bool isServer;

  const PlayerMarker({
    super.key,
    required this.playerId,
    required this.teamColor,
    this.isServer = false,
  });

  @override
  Widget build(BuildContext context) {
    final markerSize = AppDimensions.playerMarkerSizeSm;
    
    return Transform.translate(
      offset: Offset(-markerSize / 2, -markerSize / 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Server indicator
          if (isServer)
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: teamColor.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: teamColor, width: 2),
              ),
              child: Text(
                'SERVER',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          
          // Player marker
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: markerSize,
            height: markerSize,
            decoration: BoxDecoration(
              color: teamColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                playerId,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}