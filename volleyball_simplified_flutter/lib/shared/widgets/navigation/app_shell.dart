import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../routes/route_names.dart';

/// App shell widget that provides navigation structure
class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({
    super.key,
    required this.child,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final currentLocation = GoRouterState.of(context).uri.path;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Volleyball Simplified'),
        leading: isMobile
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              )
            : null,
        automaticallyImplyLeading: isMobile,
        actions: isMobile
            ? null
            : _buildDesktopNavigation(context, currentLocation),
      ),
      drawer: isMobile ? _buildMobileDrawer(context, currentLocation) : null,
      body: widget.child,
      bottomNavigationBar: isMobile ? _buildBottomNavigation(context, currentLocation) : null,
    );
  }

  List<Widget> _buildDesktopNavigation(BuildContext context, String currentLocation) {
    return _getNavigationItems()
        .map(
          (item) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingXs),
            child: TextButton(
              onPressed: () => context.go(item.route),
              style: TextButton.styleFrom(
                foregroundColor: currentLocation == item.route
                    ? AppColors.navbarText
                    : AppColors.navbarHover,
              ),
              child: Text(item.label),
            ),
          ),
        )
        .toList();
  }

  Widget _buildMobileDrawer(BuildContext context, String currentLocation) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.navbarBg,
            ),
            child: Text(
              'Volleyball Simplified',
              style: TextStyle(
                color: AppColors.navbarText,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ..._getNavigationItems().map(
            (item) => ListTile(
              leading: Icon(
                item.icon,
                color: currentLocation == item.route
                    ? AppColors.buttonPrimary
                    : AppColors.navbarHover,
              ),
              title: Text(
                item.label,
                style: TextStyle(
                  color: currentLocation == item.route
                      ? AppColors.buttonPrimary
                      : AppColors.navbarText,
                  fontWeight: currentLocation == item.route
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
              selected: currentLocation == item.route,
              onTap: () {
                context.go(item.route);
                Navigator.of(context).pop(); // Close drawer
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context, String currentLocation) {
    final items = _getNavigationItems();
    final currentIndex = items.indexWhere((item) => item.route == currentLocation);

    return BottomNavigationBar(
      currentIndex: currentIndex == -1 ? 0 : currentIndex,
      onTap: (index) => context.go(items[index].route),
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.navbarBg,
      selectedItemColor: AppColors.navbarText,
      unselectedItemColor: AppColors.navbarHover,
      items: items
          .map(
            (item) => BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.label,
            ),
          )
          .toList(),
    );
  }

  List<_NavigationItem> _getNavigationItems() {
    return [
      _NavigationItem(
        label: 'Home',
        route: RouteNames.home,
        icon: Icons.home,
      ),
      _NavigationItem(
        label: 'Basics',
        route: RouteNames.basics,
        icon: Icons.school,
      ),
      _NavigationItem(
        label: 'Positions',
        route: RouteNames.positions,
        icon: Icons.grid_view,
      ),
      _NavigationItem(
        label: 'Rotations',
        route: RouteNames.rotations,
        icon: Icons.rotate_right,
      ),
      _NavigationItem(
        label: 'Game Sense',
        route: RouteNames.gameSense,
        icon: Icons.psychology,
      ),
      _NavigationItem(
        label: 'Glossary',
        route: RouteNames.glossary,
        icon: Icons.book,
      ),
    ];
  }
}

class _NavigationItem {
  final String label;
  final String route;
  final IconData icon;

  const _NavigationItem({
    required this.label,
    required this.route,
    required this.icon,
  });
}