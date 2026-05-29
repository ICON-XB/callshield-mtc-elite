import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/caller/lookup_provider.dart';

class HistoryList extends ConsumerWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(recentLookupsProvider);

    return history.when(
      data: (items) {
        if (items.isEmpty) return const Center(child: Text('No recent scans'));
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (c, i) => ListTile(
            leading: CircleAvatar(
              backgroundColor: items[i].riskLevel.color.withValues(alpha: 0.1),
              child: Icon(items[i].riskLevel.icon,
                  color: items[i].riskLevel.color),
            ),
            title: Text(items[i].phoneNumber),
            subtitle: Text(items[i].name),
            trailing:
                Text(items[i].network, style: const TextStyle(fontSize: 10)),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }
}
