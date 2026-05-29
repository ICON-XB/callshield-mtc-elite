import 'dart:async';
import 'package:flutter/foundation.dart';

/// Notification service for real-time threat alerts
class NotificationService {
  static final List<String> _notificationQueue = [];
  static StreamController<String>? _notificationStream;

  static Stream<String> get notificationStream {
    _notificationStream ??= StreamController<String>.broadcast();
    return _notificationStream!.stream;
  }

  /// Sends a notification to the queue
  static void sendNotification(String message) {
    _notificationQueue.add(message);
    _notificationStream?.add(message);
    debugPrint('📲 Notification: $message');
  }

  /// Sends a threat-specific notification
  static void sendThreatNotification(
    String phoneNumber,
    String callerName,
    String threatLevel,
  ) {
    final message = '⚠️ $threatLevel: Call from $callerName ($phoneNumber)';
    sendNotification(message);
  }

  /// Gets recent notifications
  static List<String> getRecentNotifications({int limit = 10}) {
    return _notificationQueue.length > limit
        ? _notificationQueue.sublist(_notificationQueue.length - limit)
        : _notificationQueue;
  }

  /// Clears notification queue
  static void clearQueue() {
    _notificationQueue.clear();
  }

  /// Disposes the stream
  static void dispose() {
    _notificationStream?.close();
    _notificationStream = null;
  }
}
