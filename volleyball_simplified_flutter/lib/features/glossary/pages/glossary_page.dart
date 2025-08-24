import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/responsive_utils.dart';

/// Glossary page
class GlossaryPage extends StatelessWidget {
  const GlossaryPage({super.key});

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
              'Volleyball Glossary',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppColors.headerSectionTitle,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingMd),
            Text(
              'Complete reference of volleyball terminology and definitions.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.headerSectionText,
                height: 1.6,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXl),
            const Center(
              child: Text('Glossary terms coming soon...'),
            ),
            const SizedBox(height: AppDimensions.spacingXl),
          ],
        ),
      ),
    );
  }
}