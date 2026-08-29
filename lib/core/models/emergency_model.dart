class EmergencyAlert {
  final String id;
  final String busNumber;
  final String routeName;
  final String triggeredBy; // Driver / Attendant Name
  final String phone;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String locationAddress;
  final bool isResolved;

  const EmergencyAlert({
    required this.id,
    required this.busNumber,
    required this.routeName,
    required this.triggeredBy,
    required this.phone,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.locationAddress,
    this.isResolved = false,
  });
}
