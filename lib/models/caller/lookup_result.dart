import 'risk_level.dart';

class LookupResult {
  final String phoneNumber;
  final String name;
  final RiskLevel riskLevel;
  final bool isRegistered;
  final String? photoUrl;
  final String network;
  final DateTime timestamp;

  LookupResult({
    required this.phoneNumber,
    required this.name,
    required this.riskLevel,
    required this.isRegistered,
    this.photoUrl,
    required this.network,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Produces a map that matches the database 'history' table columns exactly
  Map<String, dynamic> toMap() {
    return {
      'phone': phoneNumber,
      'name': name,
      'risk_level': riskLevel.name,
      'is_mtc': isRegistered ? 1 : 0,
      'photo_url': photoUrl,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory LookupResult.fromMap(Map<String, dynamic> map) {
    return LookupResult(
      phoneNumber: map['phone'] ?? '',
      name: map['name'] ?? 'Unknown',
      riskLevel: RiskLevel.values.firstWhere(
        (r) => r.name == (map['risk_level'] ?? 'scam'),
        orElse: () => RiskLevel.scam,
      ),
      isRegistered: (map['is_mtc'] ?? 0) == 1,
      photoUrl: map['photo_url'],
      network: 'MTC Namibia',
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
