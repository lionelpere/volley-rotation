import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/volleyball_term.dart';

/// Info card widget displaying volleyball terms and concepts
class InfoCard extends StatelessWidget {
  final VolleyballTerm term;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.term,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasLink = term.link != null;
    
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      term.term,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.infoCardTitle,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (hasLink)
                    Icon(
                      Icons.arrow_forward_ios,
                      size: AppDimensions.iconSm,
                      color: AppColors.buttonPrimary,
                    ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Text(
                term.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.headerSectionText,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}