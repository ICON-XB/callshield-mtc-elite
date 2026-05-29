import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/caller/lookup_result.dart';
import '../../models/caller/risk_level.dart';
import '../../repositories/lookup_repository.dart';
import '../../database/local/database_helper.dart';
import '../../services/blocking/auto_blocking_service.dart';
import '../../services/blocking/smart_rules_service.dart';
import '../../services/notifications/notification_service.dart';
import '../../services/overlay/overlay_service.dart';
import 'blocking_provider.dart';

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
  final Ref _ref;

  CurrentCallNotifier(this._ref) : super(const CurrentCallState());

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

  Future<Map<String, dynamic>> processIncomingCall(
    String phone, {
    String? callerName,
    BuildContext? context,
  }) async {
    if (phone.trim().isEmpty) {
      state = const CurrentCallState();
      return {
        'shouldBlock': false,
        'reason': 'Empty phone number',
        'phoneNumber': phone,
      };
    }

    final repo = _ref.read(lookupRepositoryProvider);
    final result = await repo.identifyNumber(phone);
    final enrichedResult = callerName == null
        ? result
        : LookupResult(
            phoneNumber: result.phoneNumber,
            name: callerName,
            riskLevel: result.riskLevel,
            isRegistered: result.isRegistered,
            photoUrl: result.photoUrl,
            network: result.network,
            timestamp: result.timestamp,
          );

    state = CurrentCallState(value: enrichedResult);

    final matches = await SmartRulesService.instance.evaluateRules(
      enrichedResult.phoneNumber,
      name: enrichedResult.name,
    );

    if (matches.isNotEmpty) {
      await _ref.read(blockingProvider.notifier).blockNumber(
            enrichedResult.phoneNumber,
            'Matched smart rule: ${matches.first.name}',
          );
      NotificationService.sendThreatNotification(
        enrichedResult.phoneNumber,
        enrichedResult.name,
        'Smart Rule Match',
      );
      return {
        'shouldBlock': true,
        'reason': 'Matched smart rule: ${matches.first.name}',
        'phoneNumber': enrichedResult.phoneNumber,
        'callerName': enrichedResult.name,
      };
    }

    final reportCount = await DatabaseHelper.instance.getReportCount(
      enrichedResult.phoneNumber.replaceAll(RegExp(r'[^0-9+]'), ''),
    );

    final shouldAutoBlock = await AutoBlockingService.shouldAutoBlockAsync(
      enrichedResult.phoneNumber,
      reportCount,
      name: enrichedResult.name,
    );

    if (shouldAutoBlock) {
      await _ref.read(blockingProvider.notifier).blockNumber(
            enrichedResult.phoneNumber,
            'Auto-blocked by protection rules',
          );
      NotificationService.sendThreatNotification(
        enrichedResult.phoneNumber,
        enrichedResult.name,
        'Auto-Blocked',
      );
      return {
        'shouldBlock': true,
        'reason': 'Auto-blocked by protection rules',
        'phoneNumber': enrichedResult.phoneNumber,
        'callerName': enrichedResult.name,
      };
    }

    NotificationService.sendNotification(
      '📞 Incoming call from ${enrichedResult.name} (${enrichedResult.phoneNumber})',
    );

    if (context != null && context.mounted) {
      OverlayService.showIncomingCallOverlay(
        context,
        enrichedResult,
        () {
          OverlayService.hideOverlay();
          state = const CurrentCallState();
        },
        () {
          OverlayService.hideOverlay();
          state = const CurrentCallState();
        },
      );
    }

    return {
      'shouldBlock': false,
      'reason': 'Allowed',
      'phoneNumber': enrichedResult.phoneNumber,
      'callerName': enrichedResult.name,
    };
  }

  Future<void> handleIncomingCall(
    BuildContext? context,
    String phone, {
    String? callerName,
  }) async {
    await processIncomingCall(
      phone,
      callerName: callerName,
      context: context,
    );
  }
}

final currentCallProvider =
    StateNotifierProvider<CurrentCallNotifier, CurrentCallState>((ref) {
  return CurrentCallNotifier(ref);
});
