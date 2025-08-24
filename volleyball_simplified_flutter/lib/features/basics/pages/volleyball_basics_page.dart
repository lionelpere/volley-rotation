import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../shared/widgets/cards/callout_card.dart';

/// Volleyball basics page
class VolleyballBasicsPage extends StatelessWidget {
  const VolleyballBasicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimensions.spacingLg),
            Text(
              'Volleyball Basics',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppColors.headerSectionTitle,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              'Learn the fundamental rules, scoring system, and key concepts of volleyball.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.headerSectionText,
                height: 1.6,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXl),
            
            const CalloutCard.info(
              title: 'Game Objective',
              message: 'The objective is to send the ball over the net and ground it on the opponent\'s court, '
                       'while preventing the same effort by the opponent.',
            ),
            
            const SizedBox(height: AppDimensions.spacingLg),
            _buildBasicRulesSection(context),
            const SizedBox(height: AppDimensions.spacingLg),
            _buildScoringSection(context),
            const SizedBox(height: AppDimensions.spacingLg),
            _buildKeyConceptsSection(context),
            const SizedBox(height: AppDimensions.spacingXl),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicRulesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Rules',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.headerSectionTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        _buildRuleCard(
          context,
          'Team Composition',
          'Each team has 6 players on the court: 3 in the front row and 3 in the back row.',
        ),
        _buildRuleCard(
          context,
          'Ball Contact',
          'Players can hit the ball with any part of their body. Each team has up to 3 touches to return the ball.',
        ),
        _buildRuleCard(
          context,
          'Net Play',
          'The ball must cross the net within the antenna markers. Players cannot touch the net during play.',
        ),
      ],
    );
  }

  Widget _buildScoringSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scoring System',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.headerSectionTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        const CalloutCard.success(
          title: 'Rally Point System',
          message: 'Every rally results in a point, regardless of which team served. '
                   'Games are played to 25 points (must win by 2 points).',
        ),
      ],
    );
  }

  Widget _buildKeyConceptsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Concepts',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.headerSectionTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        _buildRuleCard(
          context,
          'Rotation',
          'Players rotate clockwise when their team wins the serve from the opponent.',
        ),
        _buildRuleCard(
          context,
          'Attack Line',
          'Back row players cannot attack the ball above net height in front of the attack line.',
        ),
        _buildRuleCard(
          context,
          'Libero',
          'A defensive specialist who can substitute freely for back row players.',
        ),
      ],
    );
  }

  Widget _buildRuleCard(BuildContext context, String title, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingMd),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.infoCardTitle,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSm),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.headerSectionText,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}