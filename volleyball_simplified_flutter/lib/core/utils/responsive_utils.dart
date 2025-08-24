import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';

/// Responsive design utilities
class ResponsiveUtils {
  /// Check if current screen is mobile size
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppDimensions.mobileBreakpoint;
  }

  /// Check if current screen is tablet size
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppDimensions.mobileBreakpoint && 
           width < AppDimensions.tabletBreakpoint;
  }

  /// Check if current screen is desktop size
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppDimensions.tabletBreakpoint;
  }

  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(AppDimensions.paddingMd);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(AppDimensions.paddingLg);
    } else {
      return const EdgeInsets.all(AppDimensions.paddingXl);
    }
  }

  /// Get responsive margin based on screen size
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(AppDimensions.spacingMd);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(AppDimensions.spacingLg);
    } else {
      return const EdgeInsets.all(AppDimensions.spacingXl);
    }
  }

  /// Get number of columns for grid based on screen size
  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) {
      return 1;
    } else if (isTablet(context)) {
      return 2;
    } else {
      return 3;
    }
  }

  /// Get responsive font size
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    if (isMobile(context)) {
      return baseSize * 0.9;
    } else if (isTablet(context)) {
      return baseSize;
    } else {
      return baseSize * 1.1;
    }
  }
}