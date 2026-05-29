import 'package:flutter/material.dart';
import '../../models/caller/lookup_result.dart';
import '../../models/caller/risk_level.dart';

/// Dynamic alert message builder for threat notifications
class AlertMessageBuilder {
  static String buildThreatMessage(LookupResult result, int reportCount) {
    switch (result.riskLevel) {
      case RiskLevel.safe:
        return '✓ Verified Safe\n${result.name} is registered with MTC';

      case RiskLevel.lowRisk:
        return '? Unknown Caller\nNumber not in database. Be cautious.';

      case RiskLevel.suspicious:
        return '⚠️ Community Alert\nThis number has been reported $reportCount times';

      case RiskLevel.scam:
        return '🚨 Confirmed Scam\nDo not answer. This number is flagged as dangerous.';
    }
  }

  static String buildDetailedAlert(
      LookupResult result, int reportCount, String? threatType) {
    final buffer = StringBuffer();

    buffer
        .writeln('CALL ALERT - ${result.riskLevel.displayName.toUpperCase()}');
    buffer.writeln('');
    buffer.writeln('Number: ${result.phoneNumber}');
    buffer.writeln('Name: ${result.name}');
    buffer.writeln('Network: ${result.network}');
    buffer.writeln('MTC Verified: ${result.isRegistered ? "Yes" : "No"}');
    buffer.writeln('');
    buffer.writeln('Threat Level: ${result.riskLevel.description}');

    if (reportCount > 0) {
      buffer.writeln('Reports: $reportCount users flagged this number');
      if (threatType != null) {
        buffer.writeln('Category: $threatType');
      }
    }

    return buffer.toString();
  }

  static Color getAlertColor(RiskLevel riskLevel) {
    return riskLevel.color;
  }

  static IconData getAlertIcon(RiskLevel riskLevel) {
    return riskLevel.icon;
  }

  static String getRecommendation(RiskLevel riskLevel) {
    switch (riskLevel) {
      case RiskLevel.safe:
        return 'Safe to answer';
      case RiskLevel.lowRisk:
        return 'Answer with caution';
      case RiskLevel.suspicious:
        return 'Consider blocking';
      case RiskLevel.scam:
        return 'Do not answer - Block immediately';
    }
  }
}
