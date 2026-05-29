import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/intelligence/analytics_service.dart';

class AnalyticsState {
  final int totalScans;
  final int scamAttempts;
  final int successfulBlocks;
  final double blockRate;
  final Map<String, int> threatsByRegion;
  final Map<String, int> threatsByCarrier;

  const AnalyticsState({
    this.totalScans = 0,
    this.scamAttempts = 0,
    this.successfulBlocks = 0,
    this.blockRate = 0.0,
    this.threatsByRegion = const {},
    this.threatsByCarrier = const {},
  });

  AnalyticsState copyWith({
    int? totalScans,
    int? scamAttempts,
    int? successfulBlocks,
    double? blockRate,
    Map<String, int>? threatsByRegion,
    Map<String, int>? threatsByCarrier,
  }) {
    return AnalyticsState(
      totalScans: totalScans ?? this.totalScans,
      scamAttempts: scamAttempts ?? this.scamAttempts,
      successfulBlocks: successfulBlocks ?? this.successfulBlocks,
      blockRate: blockRate ?? this.blockRate,
      threatsByRegion: threatsByRegion ?? this.threatsByRegion,
      threatsByCarrier: threatsByCarrier ?? this.threatsByCarrier,
    );
  }
}

class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  AnalyticsNotifier() : super(const AnalyticsState());

  void loadStats() {
    final stats = AnalyticsService.getThreatStats();
    state = state.copyWith(
      totalScans: stats['totalScans'] as int? ?? 0,
      scamAttempts: stats['scamAttempts'] as int? ?? 0,
      successfulBlocks: stats['successfulBlocks'] as int? ?? 0,
      blockRate: double.parse(stats['blockRate'] as String? ?? '0'),
      threatsByRegion: (stats['threatsByRegion'] as Map).cast<String, int>(),
      threatsByCarrier: (stats['threatsByCarrier'] as Map).cast<String, int>(),
    );
  }

  void recordScan() {
    AnalyticsService.recordScan();
    loadStats();
  }

  void recordBlock() {
    AnalyticsService.recordSuccessfulBlock();
    loadStats();
  }

  void resetWeekly() {
    AnalyticsService.resetWeeklyStats();
    state = const AnalyticsState();
  }
}

final analyticsProvider =
    StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
  return AnalyticsNotifier();
});
