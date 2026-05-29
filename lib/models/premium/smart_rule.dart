class SmartRule {
  final String id;
  final String name;
  final String pattern; // regex or simple pattern
  final String action; // 'block' or 'notify' or 'block_and_notify'
  final bool enabled;
  final String? owner;
  final DateTime createdAt;

  SmartRule({
    required this.id,
    required this.name,
    required this.pattern,
    required this.action,
    this.enabled = true,
    this.owner,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pattern': pattern,
      'action': action,
      'enabled': enabled ? 1 : 0,
      'owner': owner ?? '',
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory SmartRule.fromMap(Map<String, dynamic> m) {
    return SmartRule(
      id: m['id'] as String,
      name: m['name'] as String,
      pattern: m['pattern'] as String,
      action: m['action'] as String,
      enabled:
          (m['enabled'] is int) ? (m['enabled'] == 1) : (m['enabled'] == true),
      owner: (m['owner'] as String?)?.isEmpty ?? true
          ? null
          : m['owner'] as String?,
      createdAt:
          DateTime.tryParse(m['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
