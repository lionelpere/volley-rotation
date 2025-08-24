import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'core/theme/app_theme.dart';
import 'features/rotations/providers/rotation_provider.dart';
import 'routes/app_router.dart';

/// Root application widget
class VolleyballSimplifiedApp extends StatelessWidget {
  const VolleyballSimplifiedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RotationProvider(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Volleyball Simplified',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        builder: (context, child) {
          return ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 640, name: MOBILE),
              const Breakpoint(start: 641, end: 1024, name: TABLET),
              const Breakpoint(start: 1025, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
          );
        },
      ),
    );
  }
}