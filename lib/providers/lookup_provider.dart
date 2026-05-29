import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/caller/lookup_result.dart';
import '../models/caller/risk_level.dart';
import '../repositories/lookup_repository.dart';
import '../database/local/database_helper.dart';

final lookupRepositoryProvider = Provider((ref) => NumberLookupRepository());

final recentLookupsProvider = FutureProvider<List<LookupResult>>((ref) async {
  final data = await DatabaseHelper.instance.getHistory();
  return data.map((m) => LookupResult.fromMap(m)).toList();
});

class LookupState {
  final bool isLoading;
  final LookupResult? lastResult;
  final List<LookupResult> lookups;
  final bool isPremium;

  const LookupState({
    this.isLoading = false,
    this.lastResult,
    this.lookups = const [],
    this.isPremium = false,
  });

  LookupState copyWith({
    bool? isLoading,
    LookupResult? lastResult,
    List<LookupResult>? lookups,
    bool? isPremium,
  }) {
    return LookupState(
      isLoading: isLoading ?? this.isLoading,
      lastResult: lastResult ?? this.lastResult,
      lookups: lookups ?? this.lookups,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}

class LookupNotifier extends StateNotifier<LookupState> {
  final NumberLookupRepository _repository;

  LookupNotifier(this._repository) : super(const LookupState());

  Future<void> lookupNumber(String phone) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _repository.identifyNumber(phone);
      final List<LookupResult> lookups = [result, ...state.lookups];
      state = state.copyWith(
        isLoading: false,
        lastResult: result,
        lookups: lookups,
      );
      try {
        await DatabaseHelper.instance.addToHistory(result.toMap());
      } catch (e) {
        // Silently fail history save
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void clearResult() {
    state = state.copyWith(lastResult: null);
  }
}

final lookupProvider =
    StateNotifierProvider<LookupNotifier, LookupState>((ref) {
  final repo = ref.watch(lookupRepositoryProvider);
  return LookupNotifier(repo);
});

class CurrentCallState {
  final LookupResult? value;
  const CurrentCallState({this.value});
}

class CurrentCallNotifier extends StateNotifier<CurrentCallState> {
  CurrentCallNotifier() : super(const CurrentCallState());

  void simulateIncomingCall(String phone) {
    if (phone.isEmpty) {
      state = const CurrentCallState();
      return;
    }
    state = CurrentCallState(
      value: LookupResult(
        phoneNumber: phone,
        name: 'Test User',
        riskLevel: phone.startsWith('081') ? RiskLevel.scam : RiskLevel.safe,
        isRegistered: phone.startsWith('081'),
        network: 'MTC Namibia',
      ),
    );
  }
}

final currentCallProvider =
    StateNotifierProvider<CurrentCallNotifier, CurrentCallState>((ref) {
  return CurrentCallNotifier();
});
