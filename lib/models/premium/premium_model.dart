/// Premium subscription tiers and benefits
enum PremiumTier {
  free,
  elite,
  elitePlus,
}

class PremiumModel {
  final PremiumTier tier;
  final bool autoBlocking;
  final bool advancedAnalytics;
  final bool cloudSync;
  final bool aiDetection;
  final bool unlimitedReports;
  final bool familyProtection;
  final int monthlyPrice;

  const PremiumModel({
    required this.tier,
    required this.autoBlocking,
    required this.advancedAnalytics,
    required this.cloudSync,
    required this.aiDetection,
    required this.unlimitedReports,
    required this.familyProtection,
    required this.monthlyPrice,
  });

  factory PremiumModel.free() => const PremiumModel(
        tier: PremiumTier.free,
        autoBlocking: false,
        advancedAnalytics: false,
        cloudSync: false,
        aiDetection: false,
        unlimitedReports: false,
        familyProtection: false,
        monthlyPrice: 0,
      );

  factory PremiumModel.elite() => const PremiumModel(
        tier: PremiumTier.elite,
        autoBlocking: true,
        advancedAnalytics: true,
        cloudSync: true,
        aiDetection: false,
        unlimitedReports: true,
        familyProtection: false,
        monthlyPrice: 49,
      );

  factory PremiumModel.elitePlus() => const PremiumModel(
        tier: PremiumTier.elitePlus,
        autoBlocking: true,
        advancedAnalytics: true,
        cloudSync: true,
        aiDetection: true,
        unlimitedReports: true,
        familyProtection: true,
        monthlyPrice: 99,
      );

  String get tierName {
    switch (tier) {
      case PremiumTier.free:
        return 'Free';
      case PremiumTier.elite:
        return 'Elite';
      case PremiumTier.elitePlus:
        return 'Elite Plus';
    }
  }

  String get description {
    switch (tier) {
      case PremiumTier.free:
        return 'Basic caller ID & community reports';
      case PremiumTier.elite:
        return 'Auto-blocking, advanced analytics & cloud sync';
      case PremiumTier.elitePlus:
        return 'AI detection, family protection & all Elite features';
    }
  }

  List<String> get features {
    switch (tier) {
      case PremiumTier.free:
        return [
          'Basic caller ID lookup',
          'Community reports (read-only)',
          'Manual blocking',
        ];
      case PremiumTier.elite:
        return [
          'Caller ID lookup',
          'Auto-blocking',
          'Advanced analytics',
          'Cloud sync',
          'Unlimited reports',
          'Export call logs',
        ];
      case PremiumTier.elitePlus:
        return [
          'All Elite features',
          'AI-powered threat detection',
          'Family protection plan',
          'Priority support',
          'Custom blocking rules',
          '24/7 threat updates',
        ];
    }
  }
}
