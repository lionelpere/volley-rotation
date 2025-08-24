import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Callout card types
enum CalloutType {
  info,
  success,
  warning,
  tip,
}

/// CalloutCard widget for displaying different types of alerts and information
class CalloutCard extends StatelessWidget {
  final String title;
  final String message;
  final CalloutType type;
  final IconData? customIcon;

  const CalloutCard({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    this.customIcon,
  });

  /// Creates an info callout
  const CalloutCard.info({
    super.key,
    required this.title,
    required this.message,
    this.customIcon,
  }) : type = CalloutType.info;

  /// Creates a success callout
  const CalloutCard.success({
    super.key,
    required this.title,
    required this.message,
    this.customIcon,
  }) : type = CalloutType.success;

  /// Creates a warning callout
  const CalloutCard.warning({
    super.key,
    required this.title,
    required this.message,
    this.customIcon,
  }) : type = CalloutType.warning;

  /// Creates a tip callout
  const CalloutCard.tip({
    super.key,
    required this.title,
    required this.message,
    this.customIcon,
  }) : type = CalloutType.tip;

  @override
  Widget build(BuildContext context) {
    final colors = _getColorsForType(type);
    final icon = customIcon ?? _getIconForType(type);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppDimensions.spacingSm),
      padding: const EdgeInsets.all(AppDimensions.paddingMd),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: colors.border,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: colors.icon,
            size: AppDimensions.iconMd,
          ),
          const SizedBox(width: AppDimensions.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colors.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXs),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.text,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _CalloutColors _getColorsForType(CalloutType type) {
    switch (type) {
      case CalloutType.info:
        return const _CalloutColors(
          background: AppColors.calloutInfo,
          border: AppColors.info,
          icon: AppColors.info,
          text: AppColors.headerSectionTitle,
        );
      case CalloutType.success:
        return const _CalloutColors(
          background: AppColors.calloutSuccess,
          border: AppColors.success,
          icon: AppColors.success,
          text: AppColors.headerSectionTitle,
        );
      case CalloutType.warning:
        return const _CalloutColors(
          background: AppColors.calloutWarning,
          border: AppColors.warning,
          icon: AppColors.warning,
          text: AppColors.headerSectionTitle,
        );
      case CalloutType.tip:
        return const _CalloutColors(
          background: AppColors.calloutTip,
          border: AppColors.buttonPrimary,
          icon: AppColors.buttonPrimary,
          text: AppColors.headerSectionTitle,
        );
    }
  }

  IconData _getIconForType(CalloutType type) {
    switch (type) {
      case CalloutType.info:
        return Icons.info_outline;
      case CalloutType.success:
        return Icons.check_circle_outline;
      case CalloutType.warning:
        return Icons.warning_amber_outlined;
      case CalloutType.tip:
        return Icons.lightbulb_outline;
    }
  }
}

class _CalloutColors {
  final Color background;
  final Color border;
  final Color icon;
  final Color text;

  const _CalloutColors({
    required this.background,
    required this.border,
    required this.icon,
    required this.text,
  });
}