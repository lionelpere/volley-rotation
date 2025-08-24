import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Volleyball court visualization widget
class VolleyballCourt extends StatelessWidget {
  final double width;
  final double height;
  final int teamAServing;

  const VolleyballCourt({
    super.key,
    required this.width,
    required this.height,
    required this.teamAServing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.gray800,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.courtBg,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: AppColors.courtLines,
            width: 4,
          ),
        ),
        child: Stack(
          children: [
            // Team labels
            _buildTeamLabel(
              context,
              'Team A',
              AppColors.teamAColor,
              isTop: true,
            ),
            _buildTeamLabel(
              context,
              'Team B',
              AppColors.teamBColor,
              isTop: false,
            ),
            
            // Net line in the middle
            _buildNet(context),
            
            // Attack lines
            _buildAttackLine(context, height * 0.33, isTop: true),
            _buildAttackLine(context, height * 0.67, isTop: false),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamLabel(
    BuildContext context,
    String teamName,
    Color teamColor,
    {required bool isTop}
  ) {
    return Positioned(
      top: isTop ? -8 : null,
      bottom: isTop ? null : -8,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: AppColors.gray700.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          child: Text(
            teamName,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: teamColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNet(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: height / 2 - 16, // Centered with margin adjustment
      child: Container(
        height: 2,
        color: AppColors.netColor,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.netColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'NET',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttackLine(
    BuildContext context,
    double top,
    {required bool isTop}
  ) {
    return Positioned(
      left: 0,
      right: 0,
      top: top - 16, // Adjust for margin
      child: Container(
        height: 2,
        color: AppColors.courtLines,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.courtBg,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                'Attack Line',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.gray800,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}