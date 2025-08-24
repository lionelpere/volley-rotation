import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/buttons/secondary_button.dart';
import '../../../shared/widgets/cards/callout_card.dart';
import '../providers/rotation_provider.dart';
import '../widgets/court_with_players.dart';

/// Interactive rotations page
class RotationsPage extends StatelessWidget {
  const RotationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimensions.spacingLg),
            _buildHeader(context),
            const SizedBox(height: AppDimensions.spacingXl),
            _buildInstructions(),
            const SizedBox(height: AppDimensions.spacingXl),
            _buildGameControls(context),
            const SizedBox(height: AppDimensions.spacingLg),
            const CourtWithPlayers(),
            const SizedBox(height: AppDimensions.spacingLg),
            _buildScoreBoard(context),
            const SizedBox(height: AppDimensions.spacingXl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interactive Rotations',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: AppColors.headerSectionTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        Text(
          'Practice volleyball rotations with our interactive simulator. '
          'Score points for each team and watch how rotations work in real games.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.headerSectionText,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions() {
    return const CalloutCard.tip(
      title: 'How It Works',
      message: 'Click the team buttons to score points. Teams only rotate when they win the serve from the opponent. '
               'Watch how players move clockwise around the court with each rotation.',
    );
  }

  Widget _buildGameControls(BuildContext context) {
    return Consumer<RotationProvider>(
      builder: (context, rotationProvider, child) {
        if (rotationProvider.matchOver) {
          return _buildMatchOverControls(context, rotationProvider);
        }
        
        return _buildActiveGameControls(context, rotationProvider);
      },
    );
  }

  Widget _buildActiveGameControls(BuildContext context, RotationProvider rotationProvider) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                text: 'Team A Scores',
                onPressed: rotationProvider.teamAScores,
                width: double.infinity,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingMd),
            Expanded(
              child: PrimaryButton(
                text: 'Team B Scores',
                onPressed: rotationProvider.teamBScores,
                width: double.infinity,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        Row(
          children: [
            Expanded(
              child: SecondaryButton(
                text: 'Rotate Team A',
                onPressed: rotationProvider.rotateTeamAManually,
                width: double.infinity,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingMd),
            Expanded(
              child: SecondaryButton(
                text: 'Rotate Team B',
                onPressed: rotationProvider.rotateTeamBManually,
                width: double.infinity,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        SecondaryButton(
          text: 'Reset Game',
          onPressed: rotationProvider.resetGame,
          icon: Icons.refresh,
        ),
      ],
    );
  }

  Widget _buildMatchOverControls(BuildContext context, RotationProvider rotationProvider) {
    return Column(
      children: [
        CalloutCard.success(
          title: 'Match Over!',
          message: 'Team ${rotationProvider.winner} wins with ${rotationProvider.winner == 'A' ? rotationProvider.teamAScore : rotationProvider.teamBScore} points!',
        ),
        const SizedBox(height: AppDimensions.spacingLg),
        PrimaryButton(
          text: 'Start New Game',
          onPressed: rotationProvider.resetGame,
          icon: Icons.refresh,
          width: 200,
        ),
      ],
    );
  }

  Widget _buildScoreBoard(BuildContext context) {
    return Consumer<RotationProvider>(
      builder: (context, rotationProvider, child) {
        return Container(
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          decoration: BoxDecoration(
            color: AppColors.infoCardBg,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(
              color: AppColors.infoCardBorder,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                'Game Statistics',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.headerSectionTitle,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingLg),
              Row(
                children: [
                  Expanded(
                    child: _buildTeamStats(
                      context,
                      'Team A',
                      rotationProvider.teamAScore,
                      rotationProvider.teamARotations,
                      rotationProvider.isTeamAServing,
                      AppColors.teamAColor,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingLg),
                  Expanded(
                    child: _buildTeamStats(
                      context,
                      'Team B',
                      rotationProvider.teamBScore,
                      rotationProvider.teamBRotations,
                      rotationProvider.isTeamBServing,
                      AppColors.teamBColor,
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

  Widget _buildTeamStats(
    BuildContext context,
    String teamName,
    int score,
    int rotations,
    bool isServing,
    Color teamColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: teamColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
        border: Border.all(
          color: teamColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                teamName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: teamColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isServing) ...[
                const SizedBox(width: AppDimensions.spacingSm),
                Icon(
                  Icons.sports_volleyball,
                  color: teamColor,
                  size: AppDimensions.iconMd,
                ),
              ],
            ],
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            score.toString(),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: teamColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            '$rotations rotations',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.headerSectionText,
            ),
          ),
        ],
      ),
    );
  }
}