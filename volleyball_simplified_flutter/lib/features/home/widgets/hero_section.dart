import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../routes/route_names.dart';
import '../../../shared/widgets/buttons/primary_button.dart';

/// Hero section widget for the home page
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    return Container(
      width: double.infinity,
      height: isMobile ? 300 : 400,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/Training.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.3),
              Colors.black.withValues(alpha: 0.6),
            ],
          ),
        ),
        child: Padding(
          padding: ResponsiveUtils.getResponsivePadding(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Master Volleyball\nRotations',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 28 : 48,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingMd),
              Text(
                'Learn, practice, and perfect your understanding of volleyball positions, '
                'rotations, and game strategy with our interactive tools.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: isMobile ? 16 : 18,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingXl),
              Wrap(
                spacing: AppDimensions.spacingMd,
                runSpacing: AppDimensions.spacingMd,
                children: [
                  PrimaryButton(
                    text: 'Start Learning',
                    onPressed: () => context.go(RouteNames.basics),
                    icon: Icons.school,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: TextButton.icon(
                      onPressed: () => context.go(RouteNames.rotations),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingLg,
                          vertical: AppDimensions.paddingMd,
                        ),
                      ),
                      icon: const Icon(Icons.play_circle_outline),
                      label: const Text(
                        'Try Interactive Demo',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}