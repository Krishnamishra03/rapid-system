import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../constants/app_colors.dart';
import '../models/bus_model.dart';

class InteractiveMapCard extends StatelessWidget {
  final BusInfo busInfo;
  final List<BusStop> busStops;
  final double height;
  final bool showControls;
  final VoidCallback? onExpandTap;

  const InteractiveMapCard({
    super.key,
    required this.busInfo,
    required this.busStops,
    this.height = 300,
    this.showControls = true,
    this.onExpandTap,
  });

  @override
  Widget build(BuildContext context) {
    final busPosition = LatLng(busInfo.currentLat, busInfo.currentLng);
    
    // Route points between stops
    final polylinePoints = busStops
        .map((stop) => LatLng(stop.latitude, stop.longitude))
        .toList();

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: busPosition,
                initialZoom: 14.5,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.rapidsmart.attendance',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: polylinePoints,
                      strokeWidth: 4.5,
                      color: AppColors.accent,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    // Bus Marker
                    Marker(
                      point: busPosition,
                      width: 50,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(100),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.directions_bus_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                    // Bus Stops Markers
                    ...busStops.map(
                      (stop) => Marker(
                        point: LatLng(stop.latitude, stop.longitude),
                        width: 32,
                        height: 32,
                        child: Container(
                          decoration: BoxDecoration(
                            color: stop.isCompleted
                                ? AppColors.success
                                : (stop.isCurrent ? AppColors.warning : AppColors.surface),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: stop.isCurrent ? AppColors.primary : AppColors.border,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            stop.isCompleted ? Icons.check : Icons.location_on,
                            size: 16,
                            color: stop.isCompleted || stop.isCurrent ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Top Status Pill Overlay
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      busInfo.isTripActive ? 'LIVE • ${busInfo.busNumber}' : 'BUS PARKED',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'ETA ${busInfo.etaMinutes}m',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (onExpandTap != null)
              Positioned(
                top: 14,
                right: 14,
                child: FloatingActionButton.small(
                  heroTag: 'map_expand_${DateTime.now().millisecondsSinceEpoch}',
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.primary,
                  onPressed: onExpandTap,
                  child: const Icon(Icons.fullscreen),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
