import 'dart:convert';

class FamilyProfile {
  final String id;
  final String name;
  final List<String> members;
  final DateTime createdAt;

  FamilyProfile({
    required this.id,
    required this.name,
    required this.members,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'members': jsonEncode(members),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory FamilyProfile.fromMap(Map<String, dynamic> m) {
    final rawMembers = m['members'] as String? ?? '[]';
    List<dynamic> parsed = [];
    try {
      parsed = jsonDecode(rawMembers) as List<dynamic>;
    } catch (_) {
      parsed = [];
    }
    return FamilyProfile(
      id: m['id'] as String,
      name: m['name'] as String,
      members: parsed.map((e) => e.toString()).toList(),
      createdAt:
          DateTime.tryParse(m['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
