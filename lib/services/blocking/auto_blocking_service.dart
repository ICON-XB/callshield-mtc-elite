import '../blocking/smart_rules_service.dart';

/// Auto-blocking rules engine for advanced filtering
class AutoBlockingService {
  static final Set<String> _autoBlockedNumbers = {};
  static bool _blockConfirmedScams = true;
  static bool _blockPrivateNumbers = false;
  static bool _blockRepeatedSpam = true;
  static int _spamThreshold = 5; // Block after 5 reports

  /// Adds a number to auto-block list
  static void addAutoBlock(String phoneNumber) {
    _autoBlockedNumbers.add(phoneNumber);
  }

  /// Removes a number from auto-block list
  static void removeAutoBlock(String phoneNumber) {
    _autoBlockedNumbers.remove(phoneNumber);
  }

  /// Checks if a number should be auto-blocked
  static bool shouldAutoBlock(String phoneNumber, int reportCount) {
    // Exact number match
    if (_autoBlockedNumbers.contains(phoneNumber)) {
      return true;
    }

    // Rule 1: Block confirmed scams
    if (_blockConfirmedScams && reportCount > 20) {
      return true;
    }

    // Rule 2: Block private numbers
    if (_blockPrivateNumbers && _isPrivateNumber(phoneNumber)) {
      return true;
    }

    // Rule 3: Block repeated spam attempts
    if (_blockRepeatedSpam && reportCount >= _spamThreshold) {
      return true;
    }

    return false;
  }

  /// Toggles scam blocking
  static void setBlockConfirmedScams(bool value) {
    _blockConfirmedScams = value;
  }

  /// Toggles private number blocking
  static void setBlockPrivateNumbers(bool value) {
    _blockPrivateNumbers = value;
  }

  /// Toggles repeated spam blocking
  static void setBlockRepeatedSpam(bool value) {
    _blockRepeatedSpam = value;
  }

  /// Sets spam report threshold for blocking
  static void setSpamThreshold(int threshold) {
    _spamThreshold = threshold;
  }

  static bool _isPrivateNumber(String number) {
    return RegExp(r'(private|masked|withheld|restricted|unknown)',
            caseSensitive: false)
        .hasMatch(number);
  }

  /// Gets all auto-blocked numbers
  static Set<String> getAutoBlockedNumbers() => Set.from(_autoBlockedNumbers);

  /// Clears all auto-blocked numbers
  static void clearAutoBlocked() {
    _autoBlockedNumbers.clear();
  }

  /// Async version that also evaluates user-defined smart rules.
  static Future<bool> shouldAutoBlockAsync(String phoneNumber, int reportCount,
      {String? name, String? metadata}) async {
    // First, check existing synchronous rules
    if (shouldAutoBlock(phoneNumber, reportCount)) return true;

    // Evaluate smart rules
    try {
      final matches = await SmartRulesService.instance
          .evaluateRules(phoneNumber, name: name, metadata: metadata);
      if (matches.isNotEmpty) return true;
    } catch (_) {
      // Ignore rule engine failures and fall back to existing logic
    }
    return false;
  }
}
