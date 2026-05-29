/// Analytics tracking service for threat patterns and statistics
class AnalyticsService {
  static int totalScansThisWeek = 0;
  static int scamAttemptsThisWeek = 0;
  static int successfulBlocks = 0;
  static final Map<String, int> threatsByRegion = {};
  static final Map<String, int> threatsByCarrier = {};
  static final List<DateTime> incomingCallTimestamps = [];

  /// Records a scan
  static void recordScan() {
    totalScansThisWeek++;
  }

  /// Records a scam attempt
  static void recordScamAttempt(String region, String carrier) {
    scamAttemptsThisWeek++;
    threatsByRegion[region] = (threatsByRegion[region] ?? 0) + 1;
    threatsByCarrier[carrier] = (threatsByCarrier[carrier] ?? 0) + 1;
  }

  /// Records a successful block
  static void recordSuccessfulBlock() {
    successfulBlocks++;
  }

  /// Records incoming call for pattern analysis
  static void recordIncomingCall() {
    incomingCallTimestamps.add(DateTime.now());
  }

  /// Gets threat statistics
  static Map<String, dynamic> getThreatStats() {
    return {
      'totalScans': totalScansThisWeek,
      'scamAttempts': scamAttemptsThisWeek,
      'successfulBlocks': successfulBlocks,
      'blockRate': totalScansThisWeek > 0
          ? (successfulBlocks / totalScansThisWeek * 100).toStringAsFixed(1)
          : '0',
      'threatsByRegion': threatsByRegion,
      'threatsByCarrier': threatsByCarrier,
    };
  }

  /// Gets most dangerous numbers
  static List<String> getMostDangerousNumbers(int limit) {
    // Placeholder - would integrate with threat intelligence
    return [];
  }

  /// Resets weekly stats
  static void resetWeeklyStats() {
    totalScansThisWeek = 0;
    scamAttemptsThisWeek = 0;
    successfulBlocks = 0;
    threatsByRegion.clear();
    threatsByCarrier.clear();
    incomingCallTimestamps.clear();
  }
}
