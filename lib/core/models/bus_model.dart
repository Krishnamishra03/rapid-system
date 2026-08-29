class BusStop {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String scheduledTime;
  final bool isCompleted;
  final bool isCurrent;

  const BusStop({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.scheduledTime,
    this.isCompleted = false,
    this.isCurrent = false,
  });
}

class BusInfo {
  final String busNumber; // "BUS-001"
  final String routeName; // "Route 5 - North Sector"
  final String driverName;
  final String driverPhone;
  final String attendantName;
  final String attendantPhone;
  final int totalStudents;
  final int boardedCount;
  final bool isTripActive;
  final double currentLat;
  final double currentLng;
  final String currentStopName;
  final String nextStopName;
  final int etaMinutes;

  const BusInfo({
    required this.busNumber,
    required this.routeName,
    required this.driverName,
    required this.driverPhone,
    required this.attendantName,
    required this.attendantPhone,
    required this.totalStudents,
    required this.boardedCount,
    required this.isTripActive,
    required this.currentLat,
    required this.currentLng,
    required this.currentStopName,
    required this.nextStopName,
    required this.etaMinutes,
  });

  BusInfo copyWith({
    String? busNumber,
    String? routeName,
    String? driverName,
    String? driverPhone,
    String? attendantName,
    String? attendantPhone,
    int? totalStudents,
    int? boardedCount,
    bool? isTripActive,
    double? currentLat,
    double? currentLng,
    String? currentStopName,
    String? nextStopName,
    int? etaMinutes,
  }) {
    return BusInfo(
      busNumber: busNumber ?? this.busNumber,
      routeName: routeName ?? this.routeName,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      attendantName: attendantName ?? this.attendantName,
      attendantPhone: attendantPhone ?? this.attendantPhone,
      totalStudents: totalStudents ?? this.totalStudents,
      boardedCount: boardedCount ?? this.boardedCount,
      isTripActive: isTripActive ?? this.isTripActive,
      currentLat: currentLat ?? this.currentLat,
      currentLng: currentLng ?? this.currentLng,
      currentStopName: currentStopName ?? this.currentStopName,
      nextStopName: nextStopName ?? this.nextStopName,
      etaMinutes: etaMinutes ?? this.etaMinutes,
    );
  }
}
