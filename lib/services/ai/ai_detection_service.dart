import 'package:flutter/foundation.dart';
import '../../models/caller/lookup_result.dart';
import '../../models/caller/risk_level.dart';

/// AI-based threat detection and classification
class AiDetectionService {
  /// ML-based risk scoring (0.0 = safe, 1.0 = confirmed scam)
  static double calculateThreatScore(LookupResult result, int reportCount) {
    double score = 0.0;

    // Base score from risk level
    score += _riskLevelScore(result.riskLevel);

    // Community report scoring
    score += _communityScore(reportCount);

    // Network verification bonus
    if (result.isRegistered) {
      score -= 0.3; // Reduce score for verified MTC customers
    }

    // Clamp between 0 and 1
    return (score / 100).clamp(0.0, 1.0);
  }

  /// Detects anomalous calling patterns
  static bool detectAnomalousPattern(List<LookupResult> callHistory) {
    if (callHistory.isEmpty) return false;

    // High frequency calls in short time = anomaly
    final recentCalls = callHistory.where((c) {
      final diff = DateTime.now().difference(c.timestamp);
      return diff.inMinutes < 30;
    }).length;

    if (recentCalls > 5) {
      debugPrint('🚨 ANOMALY: $recentCalls calls in last 30 minutes');
      return true;
    }

    // Repeated calls to same number from different "names"
    final phoneGroups = <String, Set<String>>{};
    for (var call in callHistory.take(10)) {
      phoneGroups.putIfAbsent(call.phoneNumber, () => {}).add(call.name);
    }

    for (var entry in phoneGroups.entries) {
      if (entry.value.length > 3) {
        debugPrint(
            '🚨 ANOMALY: Number ${entry.key} showing ${entry.value.length} different names');
        return true;
      }
    }

    return false;
  }

  /// Classifies threat type
  static String classifyThreat(LookupResult result) {
    switch (result.riskLevel) {
      case RiskLevel.safe:
        return 'Verified Safe';
      case RiskLevel.lowRisk:
        return 'Unknown Caller';
      case RiskLevel.suspicious:
        return 'Community Flagged';
      case RiskLevel.scam:
        return 'Confirmed Scam';
    }
  }

  static double _riskLevelScore(RiskLevel level) {
    switch (level) {
      case RiskLevel.safe:
        return 0.0;
      case RiskLevel.lowRisk:
        return 15.0;
      case RiskLevel.suspicious:
        return 60.0;
      case RiskLevel.scam:
        return 95.0;
    }
  }

  static double _communityScore(int reportCount) {
    // Scale: 0-5 reports = 0-10 score, 5-20 reports = 10-40 score, 20+ = 40-70 score
    if (reportCount == 0) return 0.0;
    if (reportCount <= 5) return reportCount * 2.0;
    if (reportCount <= 20) return 10.0 + ((reportCount - 5) * 1.5);
    return 40.0 + ((reportCount - 20) * 0.5).clamp(0.0, 30.0);
  }
}
