import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/app_state_service.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/map_card.dart';
import '../../core/widgets/emergency_sos_dialog.dart';

class DriverTripScreen extends StatefulWidget {
  const DriverTripScreen({super.key});

  @override
  State<DriverTripScreen> createState() => _DriverTripScreenState();
}

class _DriverTripScreenState extends State<DriverTripScreen> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateService>();
    final bus = appState.busInfo;
    final stops = appState.busStops;

    return Scaffold(
      appBar: AppBar(
        title: Text('Live Trip Navigation (${bus.busNumber})'),
        actions: [
          IconButton(
            icon: Icon(
              _isExpanded ? Icons.fullscreen_rounded : Icons.fullscreen_exit_rounded,
              color: AppColors.accent,
            ),
            tooltip: _isExpanded ? 'Collapse Panel' : 'Expand Panel',
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
          ),
          IconButton(
            icon: const Icon(Icons.sos, color: AppColors.danger),
            onPressed: () => EmergencySosModal.show(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          InteractiveMapCard(
            busInfo: bus,
            busStops: stops,
            height: MediaQuery.of(context).size.height,
            showControls: false,
          ),

          // Top Active Trip Status Bar
          Positioned(
            top: 14,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: bus.isTripActive ? AppColors.primary : AppColors.warningBg,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(40), blurRadius: 10),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: bus.isTripActive ? AppColors.success : AppColors.warning,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    bus.isTripActive ? 'TRIP ACTIVE • GPS BROADCASTING' : 'TRIP NOT STARTED',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${bus.boardedCount}/${bus.totalStudents} Boarded',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Driver Controls Expandable & Collapsible Bottom Panel
          Positioned(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom + 95,
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity! < -100) {
                  setState(() => _isExpanded = true);
                } else if (details.primaryVelocity! > 100) {
                  setState(() => _isExpanded = false);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(35),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Drag Handle Bar & Summary Row
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _isExpanded = !_isExpanded),
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              width: 44,
                              height: 5,
                              decoration: BoxDecoration(
                                color: AppColors.textMuted.withAlpha(120),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bus.busNumber,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    bus.routeName,
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.accent.withAlpha(20),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Stop: ${bus.currentStopName}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.accent,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    _isExpanded ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,
                                    color: AppColors.accent,
                                    size: 26,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Expandable Controls Section
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      firstCurve: Curves.easeInOutCubic,
                      secondCurve: Curves.easeInOutCubic,
                      crossFadeState: _isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      secondChild: const SizedBox.shrink(),
                      firstChild: Column(
                        children: [
                          const SizedBox(height: 14),
                          const Divider(color: AppColors.border),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Students Boarded', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                    Text('${bus.boardedCount} / ${bus.totalStudents}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Next Stop', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                    Text(bus.nextStopName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          if (bus.isTripActive)
                            AppButton(
                              text: 'END TRIP',
                              type: AppButtonType.danger,
                              icon: Icons.stop_circle_outlined,
                              onPressed: () => _showEndTripConfirmation(context, appState),
                            )
                          else
                            AppButton(
                              text: 'START TRIP NOW',
                              icon: Icons.play_arrow_rounded,
                              onPressed: () {
                                appState.startTrip();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Trip Started!')),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEndTripConfirmation(BuildContext context, AppStateService appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Route 5 Trip?'),
        content: const Text(
          'Ensure all students have safely arrived and exited at school before completing the trip.',
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () {
              appState.endTrip();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.primary,
                  content: Text('🏁 Trip Completed! All students logged safe.'),
                ),
              );
            },
            child: const Text('End Trip'),
          ),
        ],
      ),
    );
  }
}
