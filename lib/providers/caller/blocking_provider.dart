import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/security/firebase_service.dart';
import '../../services/blocking/auto_blocking_service.dart';
import '../../services/notifications/notification_service.dart';

class BlockingState {
  final Set<String> blockedNumbers;
  final int totalBlocked;
  final bool autoBlockingEnabled;

  const BlockingState({
    this.blockedNumbers = const {},
    this.totalBlocked = 0,
    this.autoBlockingEnabled = false,
  });

  BlockingState copyWith({
    Set<String>? blockedNumbers,
    int? totalBlocked,
    bool? autoBlockingEnabled,
  }) {
    return BlockingState(
      blockedNumbers: blockedNumbers ?? this.blockedNumbers,
      totalBlocked: totalBlocked ?? this.totalBlocked,
      autoBlockingEnabled: autoBlockingEnabled ?? this.autoBlockingEnabled,
    );
  }
}

class BlockingNotifier extends StateNotifier<BlockingState> {
  BlockingNotifier() : super(const BlockingState());

  Future<void> blockNumber(String phoneNumber, String reason) async {
    AutoBlockingService.addAutoBlock(phoneNumber);
    state = state.copyWith(
      blockedNumbers: {...state.blockedNumbers, phoneNumber},
      totalBlocked: state.totalBlocked + 1,
    );

    // Sync to cloud
    await FirebaseService.syncToCloud({
      'action': 'block',
      'number': phoneNumber,
      'reason': reason,
      'timestamp': DateTime.now().toIso8601String(),
    });

    NotificationService.sendNotification(
      '🚫 Blocked: $phoneNumber',
    );
  }

  Future<void> unblockNumber(String phoneNumber) async {
    AutoBlockingService.removeAutoBlock(phoneNumber);
    state = state.copyWith(
      blockedNumbers: state.blockedNumbers..remove(phoneNumber),
      totalBlocked: state.totalBlocked > 0 ? state.totalBlocked - 1 : 0,
    );

    // Sync to cloud
    await FirebaseService.syncToCloud({
      'action': 'unblock',
      'number': phoneNumber,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void toggleAutoBlocking(bool enabled) {
    state = state.copyWith(autoBlockingEnabled: enabled);
  }

  Future<void> loadBlockedNumbers() async {
    final blocked = AutoBlockingService.getAutoBlockedNumbers();
    state = state.copyWith(
      blockedNumbers: blocked,
      totalBlocked: blocked.length,
    );
  }
}

final blockingProvider =
    StateNotifierProvider<BlockingNotifier, BlockingState>((ref) {
  return BlockingNotifier();
});
