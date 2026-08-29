import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/curved_navigation_bar.dart';
import 'teacher_dashboard_screen.dart';
import 'teacher_classes_screen.dart';
import 'teacher_attendance_screen.dart';
import '../parent/parent_notifications_screen.dart';
import 'teacher_profile_screen.dart';

class TeacherShell extends StatefulWidget {
  final int initialIndex;

  const TeacherShell({super.key, this.initialIndex = 0});

  @override
  State<TeacherShell> createState() => _TeacherShellState();
}

class _TeacherShellState extends State<TeacherShell> {
  late int _currentIndex;
  final List<int> _tabHistory = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant TeacherShell oldWidget) {
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
    TeacherDashboardScreen(),
    TeacherClassesScreen(),
    TeacherAttendanceScreen(),
    ParentNotificationsScreen(),
    TeacherProfileScreen(),
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
              icon: Icons.class_outlined,
              activeIcon: Icons.class_rounded,
              label: 'Classes',
            ),
            CurvedNavItem(
              icon: Icons.fact_check_outlined,
              activeIcon: Icons.fact_check_rounded,
              label: 'Attendance',
            ),
            CurvedNavItem(
              icon: Icons.notifications_outlined,
              activeIcon: Icons.notifications_rounded,
              label: 'Notifications',
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
