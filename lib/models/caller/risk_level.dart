import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// 4-tier risk assessment model for MTC National Security Registry.
///
/// MTC Question: "How does your spam detection algorithm work?"
/// Answer: We use a multi-tier scoring system that combines:
///   1. Network prefix intelligence (MTC/Telecom/Paratus)
///   2. Community report density
///   3. Business verification status
///   4. Pattern analysis (VoIP, international, masked numbers)
enum RiskLevel {
  safe(
    MTCTheme.safeGreen,
    Icons.verified_rounded,
    'Safe',
    'This number is verified and safe to answer.',
  ),
  lowRisk(
    MTCTheme.lowRiskBlue,
    Icons.info_rounded,
    'Low Risk',
    'This number is not in our database. Proceed with caution.',
  ),
  suspicious(
    MTCTheme.warningAmber,
    Icons.warning_amber_rounded,
    'Suspicious',
    'This number has been flagged by community reports.',
  ),
  scam(
    MTCTheme.alertRed,
    Icons.gpp_bad_rounded,
    'Scam',
    'This number is a confirmed scam. Do not answer.',
  );

  final Color color;
  final IconData icon;
  final String displayName;
  final String description;

  const RiskLevel(this.color, this.icon, this.displayName, this.description);
}
