import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/curved_navigation_bar.dart';
import 'attendant_home_screen.dart';
import 'qr_scanner_screen.dart';
import 'boarding_student_list_screen.dart';
import '../parent/parent_notifications_screen.dart';
import 'attendant_profile_screen.dart';

class AttendantShell extends StatefulWidget {
  final int initialIndex;

  const AttendantShell({super.key, this.initialIndex = 0});

  @override
  State<AttendantShell> createState() => _AttendantShellState();
}

class _AttendantShellState extends State<AttendantShell> {
  late int _currentIndex;
  final List<int> _tabHistory = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant AttendantShell oldWidget) {
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
    AttendantHomeScreen(),
    QrScannerScreen(),
    BoardingStudentListScreen(),
    ParentNotificationsScreen(),
    AttendantProfileScreen(),
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
              icon: Icons.qr_code_scanner_rounded,
              activeIcon: Icons.qr_code_scanner_sharp,
              label: 'Scan',
            ),
            CurvedNavItem(
              icon: Icons.format_list_bulleted_rounded,
              activeIcon: Icons.format_list_bulleted_rounded,
              label: 'Students',
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
