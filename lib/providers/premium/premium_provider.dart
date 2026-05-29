import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/premium/premium_model.dart';

class PremiumState {
  final PremiumTier currentTier;
  final bool isSubscribed;
  final DateTime? subscriptionExpiry;
  final int availableReports;

  const PremiumState({
    this.currentTier = PremiumTier.free,
    this.isSubscribed = false,
    this.subscriptionExpiry,
    this.availableReports = 10,
  });

  PremiumState copyWith({
    PremiumTier? currentTier,
    bool? isSubscribed,
    DateTime? subscriptionExpiry,
    int? availableReports,
  }) {
    return PremiumState(
      currentTier: currentTier ?? this.currentTier,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      availableReports: availableReports ?? this.availableReports,
    );
  }

  bool get isExpired =>
      subscriptionExpiry != null &&
      subscriptionExpiry!.isBefore(DateTime.now());
}

class PremiumNotifier extends StateNotifier<PremiumState> {
  PremiumNotifier() : super(const PremiumState());

  void upgradeTier(PremiumTier tier) {
    state = state.copyWith(
      currentTier: tier,
      isSubscribed: true,
      subscriptionExpiry: DateTime.now().add(const Duration(days: 30)),
    );
  }

  void downgradeTier() {
    state = const PremiumState();
  }

  void useReport() {
    if (state.availableReports > 0) {
      state = state.copyWith(availableReports: state.availableReports - 1);
    }
  }

  void resetMonthlyReports() {
    state = state.copyWith(availableReports: 100);
  }
}

final premiumProvider =
    StateNotifierProvider<PremiumNotifier, PremiumState>((ref) {
  return PremiumNotifier();
});
