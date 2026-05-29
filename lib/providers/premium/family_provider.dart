import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/premium/family_profile.dart';
import '../../services/premium/family_protection_service.dart';

class FamilyState {
  final bool isLoading;
  final List<FamilyProfile> families;
  final String? activeFamilyId;

  const FamilyState(
      {this.isLoading = false, this.families = const [], this.activeFamilyId});

  FamilyState copyWith(
      {bool? isLoading,
      List<FamilyProfile>? families,
      String? activeFamilyId}) {
    return FamilyState(
      isLoading: isLoading ?? this.isLoading,
      families: families ?? this.families,
      activeFamilyId: activeFamilyId ?? this.activeFamilyId,
    );
  }
}

class FamilyNotifier extends StateNotifier<FamilyState> {
  final FamilyProtectionService _service;
  FamilyNotifier(this._service) : super(const FamilyState());

  Future<void> loadFamilies() async {
    state = state.copyWith(isLoading: true);
    final list = await _service.getFamilies();
    state = state.copyWith(isLoading: false, families: list);
  }

  Future<FamilyProfile> createFamily(String name,
      {List<String>? members}) async {
    final f = await _service.createFamily(name, members: members);
    final updated = [f, ...state.families];
    state = state.copyWith(families: updated);
    return f;
  }

  Future<void> addMember(String familyId, String phone) async {
    await _service.addMember(familyId, phone);
    await loadFamilies();
  }

  Future<void> addSharedBlock(String familyId, String phone,
      {String? reason, String? addedBy}) async {
    await _service.addSharedBlock(familyId, phone,
        reason: reason, addedBy: addedBy);
  }

  Future<List<Map<String, dynamic>>> getSharedBlocks(String familyId) async {
    return await _service.getSharedBlocklist(familyId);
  }

  Future<void> removeSharedBlock(String familyId, String phone) async {
    await _service.removeSharedBlock(familyId, phone);
  }
}

final familyServiceProvider =
    Provider((ref) => FamilyProtectionService.instance);
final familyProvider =
    StateNotifierProvider<FamilyNotifier, FamilyState>((ref) {
  final svc = ref.watch(familyServiceProvider);
  return FamilyNotifier(svc);
});
