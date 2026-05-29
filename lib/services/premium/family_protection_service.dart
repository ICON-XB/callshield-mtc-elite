import '../../database/local/database_helper.dart';
import '../../models/premium/family_profile.dart';

class FamilyProtectionService {
  static final FamilyProtectionService instance =
      FamilyProtectionService._internal();
  final _db = DatabaseHelper.instance;

  FamilyProtectionService._internal();

  String _generateId() => DateTime.now().microsecondsSinceEpoch.toString();

  Future<FamilyProfile> createFamily(String name,
      {List<String>? members}) async {
    final id = _generateId();
    final profile = FamilyProfile(
      id: id,
      name: name,
      members: members ?? [],
      createdAt: DateTime.now(),
    );
    await _db.addFamilyProfile(profile.toMap());
    return profile;
  }

  Future<List<FamilyProfile>> getFamilies() async {
    final maps = await _db.getFamilyProfiles();
    return maps.map((m) => FamilyProfile.fromMap(m)).toList();
  }

  Future<void> addMember(String familyId, String phone) async {
    final families = await getFamilies();
    final target = families.firstWhere((f) => f.id == familyId,
        orElse: () => throw StateError('Family not found'));
    final updated = List<String>.from(target.members);
    if (!updated.contains(phone)) updated.add(phone);
    await _db.addFamilyProfile(FamilyProfile(
      id: target.id,
      name: target.name,
      members: updated,
      createdAt: target.createdAt,
    ).toMap());
  }

  Future<void> removeMember(String familyId, String phone) async {
    final families = await getFamilies();
    final target = families.firstWhere((f) => f.id == familyId,
        orElse: () => throw StateError('Family not found'));
    final updated = List<String>.from(target.members);
    updated.removeWhere((p) => p == phone);
    await _db.addFamilyProfile(FamilyProfile(
      id: target.id,
      name: target.name,
      members: updated,
      createdAt: target.createdAt,
    ).toMap());
  }

  Future<void> addSharedBlock(String familyId, String phone,
      {String? reason, String? addedBy}) async {
    await _db.addSharedBlock(familyId, phone, reason: reason, addedBy: addedBy);
  }

  Future<List<Map<String, dynamic>>> getSharedBlocklist(String familyId) async {
    return await _db.getSharedBlocklist(familyId);
  }

  Future<void> removeSharedBlock(String familyId, String phone) async {
    await _db.removeSharedBlock(familyId, phone);
  }
}
