import 'package:go_router/go_router.dart';
import '../../features/auth/splash_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/parent/parent_shell.dart';
import '../../features/driver/driver_shell.dart';
import '../../features/attendant/attendant_shell.dart';
import '../../features/teacher/teacher_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // Parent Routes
    GoRoute(
      path: '/parent/home',
      builder: (context, state) => const ParentShell(initialIndex: 0),
    ),
    GoRoute(
      path: '/parent/bus',
      builder: (context, state) => const ParentShell(initialIndex: 1),
    ),
    GoRoute(
      path: '/parent/attendance',
      builder: (context, state) => const ParentShell(initialIndex: 2),
    ),
    GoRoute(
      path: '/parent/notifications',
      builder: (context, state) => const ParentShell(initialIndex: 3),
    ),
    GoRoute(
      path: '/parent/profile',
      builder: (context, state) => const ParentShell(initialIndex: 4),
    ),

    // Driver Routes
    GoRoute(
      path: '/driver/home',
      builder: (context, state) => const DriverShell(initialIndex: 0),
    ),
    GoRoute(
      path: '/driver/trip',
      builder: (context, state) => const DriverShell(initialIndex: 1),
    ),
    GoRoute(
      path: '/driver/history',
      builder: (context, state) => const DriverShell(initialIndex: 2),
    ),
    GoRoute(
      path: '/driver/profile',
      builder: (context, state) => const DriverShell(initialIndex: 3),
    ),

    // Attendant Routes
    GoRoute(
      path: '/attendant/home',
      builder: (context, state) => const AttendantShell(initialIndex: 0),
    ),
    GoRoute(
      path: '/attendant/scan',
      builder: (context, state) => const AttendantShell(initialIndex: 1),
    ),
    GoRoute(
      path: '/attendant/students',
      builder: (context, state) => const AttendantShell(initialIndex: 2),
    ),
    GoRoute(
      path: '/attendant/profile',
      builder: (context, state) => const AttendantShell(initialIndex: 4),
    ),

    // Teacher Routes
    GoRoute(
      path: '/teacher/home',
      builder: (context, state) => const TeacherShell(initialIndex: 0),
    ),
    GoRoute(
      path: '/teacher/classes',
      builder: (context, state) => const TeacherShell(initialIndex: 1),
    ),
    GoRoute(
      path: '/teacher/attendance',
      builder: (context, state) => const TeacherShell(initialIndex: 2),
    ),
    GoRoute(
      path: '/teacher/profile',
      builder: (context, state) => const TeacherShell(initialIndex: 4),
    ),
  ],
);
