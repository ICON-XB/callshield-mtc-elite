import '../../database/local/database_helper.dart';
import '../../models/premium/smart_rule.dart';

class SmartRulesService {
  static final SmartRulesService instance = SmartRulesService._internal();
  final _db = DatabaseHelper.instance;

  SmartRulesService._internal();

  String _generateId() => DateTime.now().microsecondsSinceEpoch.toString();

  Future<SmartRule> createRule({
    required String name,
    required String pattern,
    String action = 'block',
    bool enabled = true,
    String? owner,
  }) async {
    final id = _generateId();
    final rule = SmartRule(
      id: id,
      name: name,
      pattern: pattern,
      action: action,
      enabled: enabled,
      owner: owner,
      createdAt: DateTime.now(),
    );
    await _db.addSmartRule(rule.toMap());
    return rule;
  }

  Future<List<SmartRule>> listRules() async {
    final maps = await _db.getSmartRules();
    return maps.map((m) => SmartRule.fromMap(m)).toList();
  }

  Future<void> updateRule(SmartRule rule) async {
    await _db.updateSmartRule(rule.id, rule.toMap());
  }

  Future<void> deleteRule(String id) async {
    await _db.deleteSmartRule(id);
  }

  /// Returns true if any enabled rule matches the input phone/name
  bool matchesAnyRule(String phone, {String? name, String? metadata}) {
    // Load rules synchronously is not possible here; caller should use async APIs for heavy use.
    // We provide a simple synchronous check by loading rules asynchronously and blocking is avoided.
    // For now, load rules synchronously using Future.wait is not ideal; instead callers should call
    // `evaluateRules` async method.
    throw UnimplementedError('Use evaluateRules for async matching');
  }

  Future<List<SmartRule>> evaluateRules(String phone,
      {String? name, String? metadata}) async {
    final rules = await listRules();
    final matches = <SmartRule>[];
    for (final r in rules) {
      if (!r.enabled) continue;
      try {
        final reg = RegExp(r.pattern, caseSensitive: false);
        if (reg.hasMatch(phone) ||
            (name != null && reg.hasMatch(name)) ||
            (metadata != null && reg.hasMatch(metadata))) {
          matches.add(r);
        }
      } catch (e) {
        // If pattern is not a valid regex, fallback to simple contains
        final low = r.pattern.toLowerCase();
        if (phone.toLowerCase().contains(low) ||
            (name != null && name.toLowerCase().contains(low))) {
          matches.add(r);
        }
      }
    }
    return matches;
  }
}
