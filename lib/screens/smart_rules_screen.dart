import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/premium/smart_rule.dart';
import '../providers/blocking/smart_rules_provider.dart';

class SmartRulesScreen extends ConsumerStatefulWidget {
  const SmartRulesScreen({super.key});

  @override
  ConsumerState<SmartRulesScreen> createState() => _SmartRulesScreenState();
}

class _SmartRulesScreenState extends ConsumerState<SmartRulesScreen> {
  final _nameController = TextEditingController();
  final _patternController = TextEditingController();
  String _action = 'block';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(smartRulesProvider.notifier).loadRules());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _patternController.dispose();
    super.dispose();
  }

  Future<void> _createRule() async {
    final name = _nameController.text.trim();
    final pattern = _patternController.text.trim();

    if (name.isEmpty || pattern.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name and pattern')),
      );
      return;
    }

    await ref
        .read(smartRulesProvider.notifier)
        .createRule(name, pattern, action: _action);

    if (!mounted) return;
    _nameController.clear();
    _patternController.clear();
    setState(() => _action = 'block');
  }

  Future<void> _deleteRule(String id) async {
    await ref.read(smartRulesProvider.notifier).deleteRule(id);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(smartRulesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Smart Rules',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildRuleForm(),
            const SizedBox(height: 20),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: state.rules.length,
                      itemBuilder: (_, index) {
                        final rule = state.rules[index];
                        return _buildRuleCard(rule);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Smart Rule',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Rule name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _patternController,
              decoration: const InputDecoration(
                labelText: 'Regex / keyword pattern',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _action,
              items: const [
                DropdownMenuItem(value: 'block', child: Text('Block')),
                DropdownMenuItem(value: 'notify', child: Text('Notify')),
                DropdownMenuItem(
                  value: 'block_and_notify',
                  child: Text('Block + Notify'),
                ),
              ],
              onChanged: (value) => setState(() => _action = value ?? 'block'),
              decoration: const InputDecoration(labelText: 'Action'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createRule,
                child: const Text('Save Rule'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleCard(SmartRule rule) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          rule.name,
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${rule.pattern} • ${rule.action}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _deleteRule(rule.id),
        ),
      ),
    );
  }
}
