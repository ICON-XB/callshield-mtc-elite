import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/premium/smart_rule.dart';
import '../../services/blocking/smart_rules_service.dart';

class SmartRulesState {
  final bool isLoading;
  final List<SmartRule> rules;

  const SmartRulesState({this.isLoading = false, this.rules = const []});

  SmartRulesState copyWith({bool? isLoading, List<SmartRule>? rules}) {
    return SmartRulesState(
      isLoading: isLoading ?? this.isLoading,
      rules: rules ?? this.rules,
    );
  }
}

class SmartRulesNotifier extends StateNotifier<SmartRulesState> {
  final SmartRulesService _service;
  SmartRulesNotifier(this._service) : super(const SmartRulesState());

  Future<void> loadRules() async {
    state = state.copyWith(isLoading: true);
    final list = await _service.listRules();
    state = state.copyWith(isLoading: false, rules: list);
  }

  Future<SmartRule> createRule(String name, String pattern,
      {String action = 'block'}) async {
    final r =
        await _service.createRule(name: name, pattern: pattern, action: action);
    state = state.copyWith(rules: [r, ...state.rules]);
    return r;
  }

  Future<void> updateRule(SmartRule rule) async {
    await _service.updateRule(rule);
    await loadRules();
  }

  Future<void> deleteRule(String id) async {
    await _service.deleteRule(id);
    await loadRules();
  }
}

final smartRulesServiceProvider = Provider((ref) => SmartRulesService.instance);
final smartRulesProvider =
    StateNotifierProvider<SmartRulesNotifier, SmartRulesState>((ref) {
  final svc = ref.watch(smartRulesServiceProvider);
  return SmartRulesNotifier(svc);
});
