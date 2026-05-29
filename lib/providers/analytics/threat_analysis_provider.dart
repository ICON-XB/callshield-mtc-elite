import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/telecom/spoof_detection_service.dart';
import '../../services/ai/ai_detection_service.dart';
import '../../services/intelligence/threat_intelligence_service.dart';
import '../../services/intelligence/analytics_service.dart';
import '../../models/caller/lookup_result.dart';

class ThreatAnalysisState {
  final double threatScore;
  final String threatClassification;
  final List<String> riskFactors;
  final bool isAnomalous;
  final bool isSpoofed;
  final bool isVoIP;

  const ThreatAnalysisState({
    this.threatScore = 0.0,
    this.threatClassification = 'Unknown',
    this.riskFactors = const [],
    this.isAnomalous = false,
    this.isSpoofed = false,
    this.isVoIP = false,
  });

  ThreatAnalysisState copyWith({
    double? threatScore,
    String? threatClassification,
    List<String>? riskFactors,
    bool? isAnomalous,
    bool? isSpoofed,
    bool? isVoIP,
  }) {
    return ThreatAnalysisState(
      threatScore: threatScore ?? this.threatScore,
      threatClassification: threatClassification ?? this.threatClassification,
      riskFactors: riskFactors ?? this.riskFactors,
      isAnomalous: isAnomalous ?? this.isAnomalous,
      isSpoofed: isSpoofed ?? this.isSpoofed,
      isVoIP: isVoIP ?? this.isVoIP,
    );
  }
}

class ThreatAnalysisNotifier extends StateNotifier<ThreatAnalysisState> {
  ThreatAnalysisNotifier() : super(const ThreatAnalysisState());

  Future<void> analyzeThreat(
    LookupResult result,
    List<LookupResult> callHistory,
  ) async {
    final reportProfile =
        ThreatIntelligenceService.getThreatProfile(result.phoneNumber);
    final reportCount = reportProfile?.totalReports ?? 0;

    // Calculate threat score
    final threatScore =
        AiDetectionService.calculateThreatScore(result, reportCount);

    // Check for anomalies
    final isAnomalous = AiDetectionService.detectAnomalousPattern(callHistory);

    // Check for spoofing
    final isSpoofed = SpoofDetectionService.isSpoofedNumber(
      result.phoneNumber,
      result.network,
    );

    // Check for VoIP
    final isVoIP = SpoofDetectionService.isLikelyVoIP(result.phoneNumber);

    // Collect risk factors
    final List<String> riskFactors = [];
    if (reportCount > 10) riskFactors.add('High report count ($reportCount)');
    if (isAnomalous) riskFactors.add('Anomalous calling pattern');
    if (isSpoofed) riskFactors.add('Potential spoofing detected');
    if (isVoIP) riskFactors.add('VoIP call detected');
    if (!result.isRegistered) riskFactors.add('Not MTC registered');

    // Record analytics
    AnalyticsService.recordScan();
    if (threatScore > 0.7) {
      AnalyticsService.recordScamAttempt(
        'Windhoek',
        result.network,
      );
    }

    state = state.copyWith(
      threatScore: threatScore,
      threatClassification: AiDetectionService.classifyThreat(result),
      riskFactors: riskFactors,
      isAnomalous: isAnomalous,
      isSpoofed: isSpoofed,
      isVoIP: isVoIP,
    );
  }
}

final threatAnalysisProvider =
    StateNotifierProvider<ThreatAnalysisNotifier, ThreatAnalysisState>((ref) {
  return ThreatAnalysisNotifier();
});
