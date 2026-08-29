import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/services/app_state_service.dart';
import '../../core/widgets/curved_navigation_bar.dart';
import 'parent_home_screen.dart';
import 'parent_bus_screen.dart';
import 'parent_attendance_screen.dart';
import 'parent_notifications_screen.dart';
import 'parent_profile_screen.dart';

class ParentShell extends StatefulWidget {
  final int initialIndex;

  const ParentShell({super.key, this.initialIndex = 0});

  @override
  State<ParentShell> createState() => _ParentShellState();
}

class _ParentShellState extends State<ParentShell> {
  late int _currentIndex;
  final List<int> _tabHistory = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant ParentShell oldWidget) {
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
    ParentHomeScreen(),
    ParentBusScreen(),
    ParentAttendanceScreen(),
    ParentNotificationsScreen(),
    ParentProfileScreen(),
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
    final appState = context.watch<AppStateService>();
    final unreadCount = appState.unreadNotificationCount;

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
          items: [
            const CurvedNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: 'Home',
            ),
            const CurvedNavItem(
              icon: Icons.directions_bus_outlined,
              activeIcon: Icons.directions_bus_filled_rounded,
              label: 'Bus',
            ),
            const CurvedNavItem(
              icon: Icons.fact_check_outlined,
              activeIcon: Icons.fact_check_rounded,
              label: 'Attendance',
            ),
            CurvedNavItem(
              icon: Icons.notifications_outlined,
              activeIcon: Icons.notifications_rounded,
              label: 'Notifications',
              badgeCount: unreadCount,
            ),
            const CurvedNavItem(
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
