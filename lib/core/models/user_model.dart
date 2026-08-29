enum UserRole {
  parent,
  teacher,
  driver,
  attendant,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.parent:
        return 'Parent';
      case UserRole.teacher:
        return 'Teacher';
      case UserRole.driver:
        return 'Bus Driver';
      case UserRole.attendant:
        return 'Bus Attendant';
    }
  }

  String get defaultRoute {
    switch (this) {
      case UserRole.parent:
        return '/parent/home';
      case UserRole.teacher:
        return '/teacher/home';
      case UserRole.driver:
        return '/driver/home';
      case UserRole.attendant:
        return '/attendant/home';
    }
  }
}

class AppUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String? avatarUrl;
  final String? assignedClass;
  final String? assignedBusId;
  final String? assignedRoute;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.avatarUrl,
    this.assignedClass,
    this.assignedBusId,
    this.assignedRoute,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name,
      'avatarUrl': avatarUrl,
      'assignedClass': assignedClass,
      'assignedBusId': assignedBusId,
      'assignedRoute': assignedRoute,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.parent,
      ),
      avatarUrl: json['avatarUrl'],
      assignedClass: json['assignedClass'],
      assignedBusId: json['assignedBusId'],
      assignedRoute: json['assignedRoute'],
    );
  }
}
