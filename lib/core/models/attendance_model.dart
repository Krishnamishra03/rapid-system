enum AttendanceType {
  busBoarding,
  busExit,
  classAttendance,
}

enum AttendanceStatus {
  present,
  absent,
  late,
}

class AttendanceRecord {
  final String id;
  final String studentId;
  final String studentName;
  final String studentCode;
  final String className;
  final DateTime timestamp;
  final AttendanceType type;
  final AttendanceStatus status;
  final String verifiedBy; // e.g. "Suresh (Attendant)" or "Priya (Teacher)"
  final bool qrVerified;
  final bool faceVerified;
  final String? location;

  const AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentCode,
    required this.className,
    required this.timestamp,
    required this.type,
    required this.status,
    required this.verifiedBy,
    this.qrVerified = true,
    this.faceVerified = true,
    this.location,
  });
}
