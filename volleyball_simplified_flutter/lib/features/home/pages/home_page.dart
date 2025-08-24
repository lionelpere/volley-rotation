import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../routes/route_names.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../../../shared/widgets/buttons/secondary_button.dart';
import '../../../shared/widgets/cards/callout_card.dart';
import '../widgets/hero_section.dart';

/// Home page of the volleyball simplified app
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const HeroSection(),
          Padding(
            padding: ResponsiveUtils.getResponsivePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.spacingXl),
                _buildWelcomeSection(context),
                const SizedBox(height: AppDimensions.spacingXl),
                _buildFeaturesSection(context),
                const SizedBox(height: AppDimensions.spacingXl),
                _buildCallToAction(context),
                const SizedBox(height: AppDimensions.spacingXl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to Volleyball Simplified',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: AppColors.headerSectionTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingMd),
        Text(
          'Your comprehensive guide to understanding volleyball rotations, positions, and game strategy. '
          'Whether you\'re a beginner learning the basics or an experienced player looking to master '
          'rotations, we\'ve got you covered.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.headerSectionText,
            height: 1.6,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingLg),
        const CalloutCard.tip(
          title: 'New to Volleyball?',
          message: 'Start with the Basics section to learn fundamental rules and concepts, '
                   'then progress through Positions and Rotations for a complete understanding.',
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    final features = [
      _FeatureCard(
        title: 'Volleyball Basics',
        description: 'Learn fundamental rules, scoring, and key concepts',
        icon: Icons.school,
        route: RouteNames.basics,
      ),
      _FeatureCard(
        title: 'Player Positions',
        description: 'Understand court positions and player roles',
        icon: Icons.grid_view,
        route: RouteNames.positions,
      ),
      _FeatureCard(
        title: 'Interactive Rotations',
        description: 'Practice rotations with our interactive simulator',
        icon: Icons.rotate_right,
        route: RouteNames.rotations,
      ),
      _FeatureCard(
        title: 'Game Sense Tips',
        description: 'Develop strategic thinking and game awareness',
        icon: Icons.psychology,
        route: RouteNames.gameSense,
      ),
      _FeatureCard(
        title: 'Volleyball Glossary',
        description: 'Complete reference of volleyball terminology',
        icon: Icons.book,
        route: RouteNames.glossary,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Features',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: AppColors.headerSectionTitle,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingLg),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: ResponsiveUtils.getGridColumns(context),
            crossAxisSpacing: AppDimensions.spacingMd,
            mainAxisSpacing: AppDimensions.spacingMd,
            childAspectRatio: ResponsiveUtils.isMobile(context) ? 1.2 : 1.0,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return _buildFeatureCard(context, feature);
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCard(BuildContext context, _FeatureCard feature) {
    return Card(
      child: InkWell(
        onTap: () => context.go(feature.route),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                feature.icon,
                size: AppDimensions.iconXl,
                color: AppColors.buttonPrimary,
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              Text(
                feature.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.infoCardTitle,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                feature.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.headerSectionText,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallToAction(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingXl),
      decoration: BoxDecoration(
        color: AppColors.highlightSectionBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: AppColors.highlightSectionBorder,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Ready to Get Started?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.highlightSectionText,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Text(
            'Begin your volleyball journey with our structured learning path, '
            'or jump straight into the interactive rotation simulator.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.highlightSectionText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          Wrap(
            spacing: AppDimensions.spacingMd,
            runSpacing: AppDimensions.spacingMd,
            alignment: WrapAlignment.center,
            children: [
              PrimaryButton(
                text: 'Start Learning',
                onPressed: () => context.go(RouteNames.basics),
                icon: Icons.play_arrow,
              ),
              SecondaryButton(
                text: 'Try Rotations',
                onPressed: () => context.go(RouteNames.rotations),
                icon: Icons.sports_volleyball,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureCard {
  final String title;
  final String description;
  final IconData icon;
  final String route;

  const _FeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
  });
}