import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/home/pages/home_page.dart';
import '../features/basics/pages/volleyball_basics_page.dart';
import '../features/positions/pages/positions_page.dart';
import '../features/rotations/pages/rotations_page.dart';
import '../features/game_sense/pages/game_sense_page.dart';
import '../features/glossary/pages/glossary_page.dart';
import '../shared/widgets/navigation/app_shell.dart';
import 'route_names.dart';

/// App router configuration using GoRouter
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.home,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: RouteNames.home,
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: RouteNames.basics,
            name: 'basics',
            builder: (context, state) => const VolleyballBasicsPage(),
          ),
          GoRoute(
            path: RouteNames.positions,
            name: 'positions',
            builder: (context, state) => const PositionsPage(),
          ),
          GoRoute(
            path: RouteNames.rotations,
            name: 'rotations',
            builder: (context, state) => const RotationsPage(),
          ),
          GoRoute(
            path: RouteNames.gameSense,
            name: 'game-sense',
            builder: (context, state) => const GameSensePage(),
          ),
          GoRoute(
            path: RouteNames.glossary,
            name: 'glossary',
            builder: (context, state) => const GlossaryPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              '404 - Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'The page "${state.uri}" could not be found.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}