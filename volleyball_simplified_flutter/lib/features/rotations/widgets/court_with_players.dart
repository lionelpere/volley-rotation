import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/responsive_utils.dart';
import '../providers/rotation_provider.dart';
import 'volleyball_court.dart';
import 'player_marker.dart';

/// Interactive volleyball court with players
class CourtWithPlayers extends StatelessWidget {
  const CourtWithPlayers({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RotationProvider>(
      builder: (context, rotationProvider, child) {
        final isMobile = ResponsiveUtils.isMobile(context);
        final courtWidth = isMobile ? 320.0 : AppDimensions.courtWidth;
        final courtHeight = isMobile ? 280.0 : AppDimensions.courtHeight;
        
        return Center(
          child: SizedBox(
            width: courtWidth,
            height: courtHeight,
            child: Stack(
              children: [
                // Court background
                VolleyballCourt(
                  width: courtWidth,
                  height: courtHeight,
                  teamAServing: rotationProvider.teamAServing,
                ),
                
                // Team A Players (Blue)
                ..._buildTeamAPlayers(
                  context,
                  rotationProvider.teamAPlayers,
                  courtWidth,
                  courtHeight,
                  rotationProvider.isTeamAServing,
                ),
                
                // Team B Players (Red)
                ..._buildTeamBPlayers(
                  context,
                  rotationProvider.teamBPlayers,
                  courtWidth,
                  courtHeight,
                  rotationProvider.isTeamBServing,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildTeamAPlayers(
    BuildContext context,
    List<String> players,
    double courtWidth,
    double courtHeight,
    bool isServing,
  ) {
    // Team A positions (top half of court)
    final positions = _getTeamAPositions(courtWidth, courtHeight);
    
    return List.generate(6, (index) {
      final position = positions[index];
      final isServer = index == 0 && isServing; // Position 1 is the server
      
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        left: position.dx,
        top: position.dy,
        child: PlayerMarker(
          playerId: players[index],
          teamColor: AppColors.teamAColor,
          isServer: isServer,
        ),
      );
    });
  }

  List<Widget> _buildTeamBPlayers(
    BuildContext context,
    List<String> players,
    double courtWidth,
    double courtHeight,
    bool isServing,
  ) {
    // Team B positions (bottom half of court)
    final positions = _getTeamBPositions(courtWidth, courtHeight);
    
    return List.generate(6, (index) {
      final position = positions[index];
      final isServer = index == 0 && isServing; // Position 1 is the server
      
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        left: position.dx,
        top: position.dy,
        child: PlayerMarker(
          playerId: players[index],
          teamColor: AppColors.teamBColor,
          isServer: isServer,
        ),
      );
    });
  }

  List<Offset> _getTeamAPositions(double courtWidth, double courtHeight) {
    // Positions based on the original React app percentage positions
    // Converted to absolute positions for Team A (top half)
    return [
      Offset(courtWidth * 0.20, courtHeight * 0.18), // Position 1 (back right)
      Offset(courtWidth * 0.50, courtHeight * 0.18), // Position 2 (front right)
      Offset(courtWidth * 0.80, courtHeight * 0.18), // Position 3 (front center)
      Offset(courtWidth * 0.80, courtHeight * 0.36), // Position 4 (front left)
      Offset(courtWidth * 0.50, courtHeight * 0.36), // Position 5 (back left)
      Offset(courtWidth * 0.20, courtHeight * 0.36), // Position 6 (back center)
    ];
  }

  List<Offset> _getTeamBPositions(double courtWidth, double courtHeight) {
    // Positions for Team B (bottom half) - mirrored from Team A
    return [
      Offset(courtWidth * 0.80, courtHeight * 0.82), // Position 1 (back right)
      Offset(courtWidth * 0.50, courtHeight * 0.82), // Position 2 (front right)
      Offset(courtWidth * 0.20, courtHeight * 0.82), // Position 3 (front center)
      Offset(courtWidth * 0.20, courtHeight * 0.64), // Position 4 (front left)
      Offset(courtWidth * 0.50, courtHeight * 0.64), // Position 5 (back left)
      Offset(courtWidth * 0.80, courtHeight * 0.64), // Position 6 (back center)
    ];
  }
}