/// Community-driven threat intelligence system
/// Tracks report counts, reputation scores, and threat patterns
class ThreatIntelligenceService {
  // In-memory threat database (would be Cloud DB in production)
  static final Map<String, ThreatProfile> _threatDatabase = {};

  /// Records a report against a number
  static void reportThreat(String phoneNumber, String category) {
    final profile = _threatDatabase.putIfAbsent(
      phoneNumber,
      () => ThreatProfile(phoneNumber: phoneNumber),
    );

    profile.addReport(category);
  }

  /// Gets threat profile for a number
  static ThreatProfile? getThreatProfile(String phoneNumber) {
    return _threatDatabase[phoneNumber];
  }

  /// Gets reputation score (0-100, higher = more dangerous)
  static int getReputationScore(String phoneNumber) {
    final profile = _threatDatabase[phoneNumber];
    return profile?.reputationScore ?? 0;
  }

  /// Gets most common threat type for a number
  static String? getMostCommonThreat(String phoneNumber) {
    final profile = _threatDatabase[phoneNumber];
    return profile?.mostCommonCategory;
  }

  /// Clears threat database (for testing)
  static void clearDatabase() {
    _threatDatabase.clear();
  }
}

/// Individual threat profile for a number
class ThreatProfile {
  final String phoneNumber;
  final Map<String, int> reportsByCategory = {};
  int totalReports = 0;
  DateTime lastReported = DateTime.now();

  ThreatProfile({required this.phoneNumber});

  void addReport(String category) {
    reportsByCategory[category] = (reportsByCategory[category] ?? 0) + 1;
    totalReports++;
    lastReported = DateTime.now();
  }

  int get reputationScore {
    // Base: 5 points per report, capped at 100
    return (totalReports * 5).clamp(0, 100);
  }

  String? get mostCommonCategory {
    if (reportsByCategory.isEmpty) return null;
    return reportsByCategory.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  List<String> get reportSummary {
    return reportsByCategory.entries
        .map((e) => '${e.key}: ${e.value}')
        .toList();
  }
}
