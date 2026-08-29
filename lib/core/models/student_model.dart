enum StudentBoardingStatus {
  notBoarded,
  boarded,
  exited,
  absent,
}

class Student {
  final String id;
  final String name;
  final String photoUrl;
  final String classId; // e.g. "8-A"
  final String section;
  final String studentCode; // e.g. "STU-8042"
  final String parentName;
  final String parentPhone;
  final String busId; // e.g. "BUS-001"
  final String routeName; // e.g. "Route 5"
  final String busStop; // e.g. "Bhopal Nagar"
  final double attendancePercentage; // e.g. 95.0
  final StudentBoardingStatus boardingStatus;
  final String? boardedTime;
  final String? exitedTime;
  final bool qrVerified;
  final bool faceVerified;

  const Student({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.classId,
    required this.section,
    required this.studentCode,
    required this.parentName,
    required this.parentPhone,
    required this.busId,
    required this.routeName,
    required this.busStop,
    required this.attendancePercentage,
    this.boardingStatus = StudentBoardingStatus.notBoarded,
    this.boardedTime,
    this.exitedTime,
    this.qrVerified = false,
    this.faceVerified = false,
  });

  Student copyWith({
    String? id,
    String? name,
    String? photoUrl,
    String? classId,
    String? section,
    String? studentCode,
    String? parentName,
    String? parentPhone,
    String? busId,
    String? routeName,
    String? busStop,
    double? attendancePercentage,
    StudentBoardingStatus? boardingStatus,
    String? boardedTime,
    String? exitedTime,
    bool? qrVerified,
    bool? faceVerified,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      classId: classId ?? this.classId,
      section: section ?? this.section,
      studentCode: studentCode ?? this.studentCode,
      parentName: parentName ?? this.parentName,
      parentPhone: parentPhone ?? this.parentPhone,
      busId: busId ?? this.busId,
      routeName: routeName ?? this.routeName,
      busStop: busStop ?? this.busStop,
      attendancePercentage: attendancePercentage ?? this.attendancePercentage,
      boardingStatus: boardingStatus ?? this.boardingStatus,
      boardedTime: boardedTime ?? this.boardedTime,
      exitedTime: exitedTime ?? this.exitedTime,
      qrVerified: qrVerified ?? this.qrVerified,
      faceVerified: faceVerified ?? this.faceVerified,
    );
  }
}
