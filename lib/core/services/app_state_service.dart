import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/student_model.dart';
import '../models/bus_model.dart';
import '../models/notification_model.dart';
import '../models/emergency_model.dart';

class AppStateService extends ChangeNotifier {
  // Current Authenticated User & Active Role
  AppUser _currentUser = const AppUser(
    id: 'usr-parent-01',
    name: 'Amit Sharma',
    email: 'amit.sharma@example.com',
    phone: '+91 98765 43210',
    role: UserRole.parent,
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
    assignedClass: '8-A',
    assignedBusId: 'BUS-001',
    assignedRoute: 'Route 5',
  );

  bool _isLoggedIn = false;
  Timer? _gpsSimulationTimer;

  // Selected child for parent view
  String _selectedStudentId = 'stu-001';

  // Bus Tracking Data
  BusInfo _busInfo = const BusInfo(
    busNumber: 'BUS-001',
    routeName: 'Route 5 - North Sector',
    driverName: 'Rajesh Kumar',
    driverPhone: '+91 98123 45678',
    attendantName: 'Suresh Verma',
    attendantPhone: '+91 98765 12345',
    totalStudents: 42,
    boardedCount: 35,
    isTripActive: false,
    currentLat: 23.259933, // Bhopal coordinates demo
    currentLng: 77.412613,
    currentStopName: 'Stop 3 - Civil Lines',
    nextStopName: 'Stop 4 - Bhopal Nagar',
    etaMinutes: 2,
  );

  final List<BusStop> _busStops = const [
    BusStop(id: 's1', name: 'Stop 1 - Central Depot', latitude: 23.2500, longitude: 77.4000, scheduledTime: '07:20 AM', isCompleted: true),
    BusStop(id: 's2', name: 'Stop 2 - MP Nagar Circle', latitude: 23.2540, longitude: 77.4050, scheduledTime: '07:35 AM', isCompleted: true),
    BusStop(id: 's3', name: 'Stop 3 - Civil Lines', latitude: 23.2580, longitude: 77.4100, scheduledTime: '07:42 AM', isCompleted: true, isCurrent: true),
    BusStop(id: 's4', name: 'Stop 4 - Bhopal Nagar', latitude: 23.2620, longitude: 77.4150, scheduledTime: '07:50 AM'),
    BusStop(id: 's5', name: 'Stop 5 - St. Xavier School', latitude: 23.2700, longitude: 77.4250, scheduledTime: '08:25 AM'),
  ];

  // Students Dataset
  final List<Student> _students = [
    const Student(
      id: 'stu-001',
      name: 'Rahul Sharma',
      photoUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?w=150',
      classId: '8-A',
      section: 'A',
      studentCode: 'STU-8042',
      parentName: 'Amit Sharma',
      parentPhone: '+91 98765 43210',
      busId: 'BUS-001',
      routeName: 'Route 5',
      busStop: 'Bhopal Nagar',
      attendancePercentage: 95.0,
      boardingStatus: StudentBoardingStatus.boarded,
      boardedTime: '07:42 AM',
      qrVerified: true,
      faceVerified: true,
    ),
    const Student(
      id: 'stu-002',
      name: 'Aman Verma',
      photoUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150',
      classId: '8-A',
      section: 'A',
      studentCode: 'STU-8043',
      parentName: 'Suresh Verma',
      parentPhone: '+91 98123 00001',
      busId: 'BUS-001',
      routeName: 'Route 5',
      busStop: 'MP Nagar',
      attendancePercentage: 92.5,
      boardingStatus: StudentBoardingStatus.boarded,
      boardedTime: '07:36 AM',
      qrVerified: true,
      faceVerified: true,
    ),
    const Student(
      id: 'stu-003',
      name: 'Priya Singh',
      photoUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
      classId: '8-A',
      section: 'A',
      studentCode: 'STU-8044',
      parentName: 'Vikram Singh',
      parentPhone: '+91 98123 00002',
      busId: 'BUS-001',
      routeName: 'Route 5',
      busStop: 'Civil Lines',
      attendancePercentage: 98.0,
      boardingStatus: StudentBoardingStatus.boarded,
      boardedTime: '07:40 AM',
      qrVerified: true,
      faceVerified: true,
    ),
    const Student(
      id: 'stu-004',
      name: 'Ankit Jain',
      photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      classId: '8-A',
      section: 'A',
      studentCode: 'STU-8045',
      parentName: 'Rakesh Jain',
      parentPhone: '+91 98123 00003',
      busId: 'BUS-001',
      routeName: 'Route 5',
      busStop: 'Bhopal Nagar',
      attendancePercentage: 88.0,
      boardingStatus: StudentBoardingStatus.notBoarded,
      qrVerified: false,
      faceVerified: false,
    ),
    const Student(
      id: 'stu-005',
      name: 'Rohit Sharma',
      photoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      classId: '8-A',
      section: 'A',
      studentCode: 'STU-8046',
      parentName: 'Sunil Sharma',
      parentPhone: '+91 98123 00004',
      busId: 'BUS-001',
      routeName: 'Route 5',
      busStop: 'Bhopal Nagar',
      attendancePercentage: 91.0,
      boardingStatus: StudentBoardingStatus.notBoarded,
      qrVerified: false,
      faceVerified: false,
    ),
    const Student(
      id: 'stu-006',
      name: 'Neha Gupta',
      photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      classId: '8-A',
      section: 'A',
      studentCode: 'STU-8047',
      parentName: 'Deepak Gupta',
      parentPhone: '+91 98123 00005',
      busId: 'BUS-001',
      routeName: 'Route 5',
      busStop: 'Arera Colony',
      attendancePercentage: 96.0,
      boardingStatus: StudentBoardingStatus.notBoarded,
      qrVerified: false,
      faceVerified: false,
    ),
  ];

  // Notifications Dataset
  final List<AppNotification> _notifications = [
    AppNotification(
      id: 'n1',
      title: '🚌 Bus Started',
      message: 'BUS-001 started Route 5 from Central Depot.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 35)),
      category: NotificationCategory.bus,
      isRead: false,
    ),
    AppNotification(
      id: 'n2',
      title: '✓ Child Boarded',
      message: 'Rahul Sharma boarded the bus at 7:42 AM (QR & Face Verified).',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      category: NotificationCategory.attendance,
      isRead: false,
    ),
    AppNotification(
      id: 'n3',
      title: '🏫 School Announcement',
      message: 'Parent-Teacher Meeting scheduled for coming Saturday 10:00 AM.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      category: NotificationCategory.school,
      isRead: true,
    ),
  ];

  // Emergency SOS State
  EmergencyAlert? _activeEmergency;

  // Getters
  AppUser get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  String get selectedStudentId => _selectedStudentId;
  BusInfo get busInfo => _busInfo;
  List<BusStop> get busStops => List.unmodifiable(_busStops);
  List<Student> get students => List.unmodifiable(_students);
  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  EmergencyAlert? get activeEmergency => _activeEmergency;
  int get boardedStudentCount => _students.where((s) => s.boardingStatus == StudentBoardingStatus.boarded || s.boardingStatus == StudentBoardingStatus.exited).length;

  Student get selectedStudent {
    return _students.firstWhere(
      (s) => s.id == _selectedStudentId,
      orElse: () => _students.first,
    );
  }

  int get unreadNotificationCount => _notifications.where((n) => !n.isRead).length;

  // Role Switcher for quick Dev/Demo previewing
  void switchRole(UserRole role) {
    switch (role) {
      case UserRole.parent:
        _currentUser = const AppUser(
          id: 'usr-parent-01',
          name: 'Amit Sharma',
          email: 'amit.sharma@example.com',
          phone: '+91 98765 43210',
          role: UserRole.parent,
          avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
          assignedClass: '8-A',
          assignedBusId: 'BUS-001',
          assignedRoute: 'Route 5',
        );
        break;
      case UserRole.driver:
        _currentUser = const AppUser(
          id: 'usr-driver-01',
          name: 'Rajesh Kumar',
          email: 'rajesh.driver@rapidsmart.com',
          phone: '+91 98123 45678',
          role: UserRole.driver,
          avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
          assignedBusId: 'BUS-001',
          assignedRoute: 'Route 5',
        );
        break;
      case UserRole.attendant:
        _currentUser = const AppUser(
          id: 'usr-attendant-01',
          name: 'Suresh Verma',
          email: 'suresh.attendant@rapidsmart.com',
          phone: '+91 98765 12345',
          role: UserRole.attendant,
          avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
          assignedBusId: 'BUS-001',
          assignedRoute: 'Route 5',
        );
        break;
      case UserRole.teacher:
        _currentUser = const AppUser(
          id: 'usr-teacher-01',
          name: 'Priya Verma',
          email: 'priya.teacher@stxaviers.edu',
          phone: '+91 99887 76655',
          role: UserRole.teacher,
          avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
          assignedClass: '8-A',
        );
        break;
    }
    notifyListeners();
  }

  void login(String emailOrPhone, String password) {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void selectStudent(String id) {
    _selectedStudentId = id;
    notifyListeners();
  }

  // Driver actions
  void startTrip() {
    _busInfo = _busInfo.copyWith(isTripActive: true);
    _notifications.insert(
      0,
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '🚌 Bus Trip Started',
        message: '${_busInfo.busNumber} started ${_busInfo.routeName}. GPS Live tracking active.',
        timestamp: DateTime.now(),
        category: NotificationCategory.bus,
      ),
    );
    
    // Start GPS movement simulation
    _startGpsSimulation();
    notifyListeners();
  }

  void endTrip() {
    _busInfo = _busInfo.copyWith(isTripActive: false);
    _gpsSimulationTimer?.cancel();
    _notifications.insert(
      0,
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '🏁 Trip Completed',
        message: '${_busInfo.busNumber} completed ${_busInfo.routeName}. All students arrived safely.',
        timestamp: DateTime.now(),
        category: NotificationCategory.bus,
      ),
    );
    notifyListeners();
  }

  void _startGpsSimulation() {
    _gpsSimulationTimer?.cancel();
    _gpsSimulationTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_busInfo.isTripActive) {
        timer.cancel();
        return;
      }
      // Slightly shift lat/lng towards school
      final newLat = _busInfo.currentLat + 0.0005;
      final newLng = _busInfo.currentLng + 0.0004;
      final newEta = _busInfo.etaMinutes > 1 ? _busInfo.etaMinutes - 1 : 1;

      _busInfo = _busInfo.copyWith(
        currentLat: newLat,
        currentLng: newLng,
        etaMinutes: newEta,
      );
      notifyListeners();
    });
  }

  // Attendant Actions - Boarding & Exit Flow
  void markStudentBoarded(String studentId, {required bool qrVerified, required bool faceVerified}) {
    final index = _students.indexWhere((s) => s.id == studentId);
    if (index != -1) {
      final s = _students[index];
      _students[index] = s.copyWith(
        boardingStatus: StudentBoardingStatus.boarded,
        boardedTime: _formatCurrentTime(),
        qrVerified: qrVerified,
        faceVerified: faceVerified,
      );

      final newBoardedCount = _students.where((st) => st.boardingStatus == StudentBoardingStatus.boarded).length;
      _busInfo = _busInfo.copyWith(boardedCount: newBoardedCount);

      _notifications.insert(
        0,
        AppNotification(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: '✓ Child Boarded Bus',
          message: '${s.name} boarded ${_busInfo.busNumber} at ${_formatCurrentTime()} (QR & Face Verified).',
          timestamp: DateTime.now(),
          category: NotificationCategory.attendance,
        ),
      );

      notifyListeners();
    }
  }

  void markStudentExited(String studentId) {
    final index = _students.indexWhere((s) => s.id == studentId);
    if (index != -1) {
      final s = _students[index];
      _students[index] = s.copyWith(
        boardingStatus: StudentBoardingStatus.exited,
        exitedTime: _formatCurrentTime(),
      );

      _notifications.insert(
        0,
        AppNotification(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: '🏫 Reached School',
          message: '${s.name} safely exited bus & entered school premises at ${_formatCurrentTime()}.',
          timestamp: DateTime.now(),
          category: NotificationCategory.attendance,
        ),
      );

      notifyListeners();
    }
  }

  // Emergency SOS Trigger
  void triggerEmergencySOS() {
    _activeEmergency = EmergencyAlert(
      id: 'sos-${DateTime.now().millisecondsSinceEpoch}',
      busNumber: _busInfo.busNumber,
      routeName: _busInfo.routeName,
      triggeredBy: _currentUser.name,
      phone: _currentUser.phone,
      timestamp: DateTime.now(),
      latitude: _busInfo.currentLat,
      longitude: _busInfo.currentLng,
      locationAddress: 'Near Civil Lines Circle, Sector 4, Bhopal',
    );

    _notifications.insert(
      0,
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '🚨 EMERGENCY SOS ALERT',
        message: 'SOS triggered by ${_currentUser.name} on ${_busInfo.busNumber}. School admin & emergency teams notified.',
        timestamp: DateTime.now(),
        category: NotificationCategory.emergency,
      ),
    );

    notifyListeners();
  }

  void resolveEmergencySOS() {
    _activeEmergency = null;
    notifyListeners();
  }

  void markNotificationAsRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx] = _notifications[idx].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  String _formatCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:$minute $ampm';
  }

  @override
  void dispose() {
    _gpsSimulationTimer?.cancel();
    super.dispose();
  }
}
