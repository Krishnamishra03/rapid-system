import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/curved_navigation_bar.dart';
import 'driver_home_screen.dart';
import 'driver_trip_screen.dart';
import 'driver_history_screen.dart';
import 'driver_profile_screen.dart';

class DriverShell extends StatefulWidget {
  final int initialIndex;

  const DriverShell({super.key, this.initialIndex = 0});

  @override
  State<DriverShell> createState() => _DriverShellState();
}

class _DriverShellState extends State<DriverShell> {
  late int _currentIndex;
  final List<int> _tabHistory = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant DriverShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      setState(() {
        if (_currentIndex != widget.initialIndex) {
          _tabHistory.add(_currentIndex);
        }
        _currentIndex = widget.initialIndex;
      });
    }
  }

  final List<Widget> _screens = const [
    DriverHomeScreen(),
    DriverTripScreen(),
    DriverHistoryScreen(),
    DriverProfileScreen(),
  ];

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _tabHistory.add(_currentIndex);
      _currentIndex = index;
    });
  }

  bool _handleBackPress() {
    if (_tabHistory.isNotEmpty) {
      final previousIndex = _tabHistory.removeLast();
      setState(() {
        _currentIndex = previousIndex;
      });
      return false; // Handled back step-by-step
    }
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
      return false;
    }
    return true; // Go back to login
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final shouldPopRoute = _handleBackPress();
        if (shouldPopRoute) {
          context.go('/login');
        }
      },
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: AnimatedCurvedNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          items: const [
            CurvedNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: 'Home',
            ),
            CurvedNavItem(
              icon: Icons.navigation_outlined,
              activeIcon: Icons.navigation_rounded,
              label: 'Active Trip',
            ),
            CurvedNavItem(
              icon: Icons.history_rounded,
              activeIcon: Icons.history_toggle_off_rounded,
              label: 'History',
            ),
            CurvedNavItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person_rounded,
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
