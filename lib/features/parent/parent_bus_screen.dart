import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/app_state_service.dart';
import '../../core/widgets/map_card.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/neumorphic_glass_widgets.dart';

class ParentBusScreen extends StatefulWidget {
  const ParentBusScreen({super.key});

  @override
  State<ParentBusScreen> createState() => _ParentBusScreenState();
}

class _ParentBusScreenState extends State<ParentBusScreen> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateService>();
    final bus = appState.busInfo;
    final stops = appState.busStops;

    return Scaffold(
      appBar: AppBar(
        title: Text('Live Bus Telemetry (${bus.busNumber})'),
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
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Telemetry Coordinates',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('⚡ Refreshed latest GPS telemetry coordinates!')),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Full Screen Map View
          InteractiveMapCard(
            busInfo: bus,
            busStops: stops,
            height: MediaQuery.of(context).size.height,
            showControls: false,
          ),

          // Fintech Expandable & Collapsible Glass Sheet Panel
          Positioned(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom + 95,
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity! < -100) {
                  // Drag UP -> Expand
                  setState(() => _isExpanded = true);
                } else if (details.primaryVelocity! > 100) {
                  // Drag DOWN -> Collapse
                  setState(() => _isExpanded = false);
                }
              },
              child: GlassCard(
                borderRadius: 28,
                blur: 16,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Drag Handle Bar & Collapsed Summary Header (Always Visible)
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
                                  Row(
                                    children: [
                                      Text(
                                        bus.busNumber,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.textPrimary,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.accent.withAlpha(20),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'ETA ${bus.etaMinutes}m',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.accent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    bus.routeName,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  StatusBadge(
                                    label: bus.isTripActive ? '🟢 En Route' : 'Parked',
                                    type: bus.isTripActive ? BadgeType.onRoute : BadgeType.pending,
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.accent.withAlpha(15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _isExpanded ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,
                                      color: AppColors.accent,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Expandable Detailed Information (Shown when _isExpanded == true)
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      firstCurve: Curves.easeInOutCubic,
                      secondCurve: Curves.easeInOutCubic,
                      crossFadeState: _isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      secondChild: const SizedBox.shrink(),
                      firstChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 14),
                          const Divider(color: AppColors.border),
                          const SizedBox(height: 12),

                          // Stop & ETA stats
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoTile(
                                  icon: Icons.location_on_rounded,
                                  iconColor: AppColors.accent,
                                  label: 'NEXT STOP',
                                  value: bus.nextStopName,
                                ),
                              ),
                              Container(width: 1, height: 38, color: AppColors.border),
                              Expanded(
                                child: _buildInfoTile(
                                  icon: Icons.timer_rounded,
                                  iconColor: AppColors.success,
                                  label: 'ESTIMATED ETA',
                                  value: '${bus.etaMinutes} min',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Driver & Attendant Contact Row
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(220),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AppColors.primary,
                                  child: const Icon(Icons.person_rounded, color: Colors.white, size: 20),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bus.driverName,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        'Attendant: ${bus.attendantName}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.accent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    elevation: 0,
                                  ),
                                  icon: const Icon(Icons.call_rounded, size: 15),
                                  label: const Text('Call School', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Calling School Helpline / Driver ${bus.driverPhone}')),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().slideY(begin: 0.2, end: 0, duration: 400.ms).fadeIn(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900, color: AppColors.textMuted, letterSpacing: 0.5),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
