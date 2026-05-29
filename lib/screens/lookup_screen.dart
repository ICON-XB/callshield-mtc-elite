import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import '../providers/caller/lookup_provider.dart';
import '../widgets/cards/result_card.dart';

class LookupScreen extends ConsumerStatefulWidget {
  const LookupScreen({super.key});

  @override
  ConsumerState<LookupScreen> createState() => _LookupScreenState();
}

class _LookupScreenState extends ConsumerState<LookupScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final lookupState = ref.watch(lookupProvider);

    return Scaffold(
      backgroundColor: MTCTheme.primaryNavy,
      appBar: AppBar(
        title: const Text('Search Any Number'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildBigSearch(),
            const SizedBox(height: 30),
            if (lookupState.isLoading)
              const Center(
                  child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator()))
            else if (lookupState.lastResult != null)
              _buildCleanResult(lookupState)
            else
              _buildHistorySection(lookupState),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildBigSearch() {
    return Container(
      decoration: BoxDecoration(
        color: MTCTheme.surfaceGray,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: TextField(
        controller: _controller,
        style: GoogleFonts.outfit(fontSize: 18, color: Colors.white),
        onSubmitted: (val) {
          if (val.isNotEmpty) {
            ref.read(lookupProvider.notifier).lookupNumber(val);
          }
        },
        decoration: const InputDecoration(
          hintText: 'Enter phone number...',
          hintStyle: TextStyle(color: Colors.white30),
          prefixIcon:
              Icon(Icons.search_rounded, color: MTCTheme.primaryBlue, size: 28),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 22, horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildCleanResult(LookupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('SEARCH RESULT',
                style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: MTCTheme.textSecondary,
                    letterSpacing: 1)),
            TextButton(
                onPressed: () =>
                    ref.read(lookupProvider.notifier).clearResult(),
                child: const Text('Clear',
                    style: TextStyle(color: MTCTheme.primaryBlue))),
          ],
        ),
        const SizedBox(height: 15),
        ResultCard(
          title: state.lastResult!.phoneNumber,
          status: state.lastResult!.riskLevel.displayName,
          statusColor: state.lastResult!.riskLevel.color,
          ownerName: state.lastResult!.name,
        ),
      ],
    );
  }

  Widget _buildHistorySection(LookupState state) {
    if (state.lookups.isEmpty) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Icon(Icons.search_off_rounded,
                size: 80, color: Colors.white12),
            const SizedBox(height: 20),
            Text('No history yet',
                style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('YOUR SEARCH HISTORY',
            style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: MTCTheme.textSecondary,
                letterSpacing: 1)),
        const SizedBox(height: 15),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.lookups.length,
          itemBuilder: (context, index) {
            final l = state.lookups[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                  color: MTCTheme.surfaceGray,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: l.riskLevel.color.withValues(alpha: 0.1),
                  child: Icon(l.riskLevel.icon,
                      color: l.riskLevel.color, size: 20),
                ),
                title: Text(l.phoneNumber,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                subtitle: Text(l.network,
                    style: const TextStyle(color: Colors.white70)),
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: Colors.white30),
                onTap: () => ref
                    .read(lookupProvider.notifier)
                    .lookupNumber(l.phoneNumber),
              ),
            );
          },
        ),
      ],
    );
  }
}
