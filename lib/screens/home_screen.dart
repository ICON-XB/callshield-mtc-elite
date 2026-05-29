import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import '../providers/caller/lookup_provider.dart';
import '../widgets/cards/result_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final lookupState = ref.watch(lookupProvider);

    return Scaffold(
      backgroundColor: MTCTheme.primaryNavy,
      appBar: AppBar(
        title: const Text('CallShield Protection'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 25),
            Text('SEARCH ANY NUMBER',
                style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: MTCTheme.textSecondary,
                    letterSpacing: 1.2)),
            const SizedBox(height: 12),
            _buildSimplifiedSearch(),
            const SizedBox(height: 30),
            if (lookupState.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (lookupState.lastResult != null)
              _buildResultDisplay(lookupState)
            else
              _buildQuickActions(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: MTCTheme.primaryBlue,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: MTCTheme.primaryBlue.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.check_circle_rounded, color: Colors.white, size: 60),
          const SizedBox(height: 16),
          Text('Your phone is safe',
              style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('CallShield is blocking scam calls in the background.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                  color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildSimplifiedSearch() {
    return Container(
      decoration: BoxDecoration(
        color: MTCTheme.surfaceGray,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 15)
        ],
        border: Border.all(color: Colors.white12),
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.outfit(color: Colors.white),
        onSubmitted: (val) {
          if (val.isNotEmpty) {
            ref.read(lookupProvider.notifier).lookupNumber(val);
          }
        },
        decoration: InputDecoration(
          hintText: 'Enter phone number...',
          hintStyle: const TextStyle(color: Colors.white30),
          prefixIcon: const Icon(Icons.search, color: MTCTheme.accentTeal),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          suffixIcon: IconButton(
            icon: const Icon(Icons.arrow_forward_rounded,
                color: MTCTheme.accentTeal),
            onPressed: () => ref
                .read(lookupProvider.notifier)
                .lookupNumber(_searchController.text),
          ),
        ),
      ),
    );
  }

  Widget _buildResultDisplay(LookupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('SEARCH RESULT',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54)),
            TextButton(
                onPressed: () =>
                    ref.read(lookupProvider.notifier).clearResult(),
                child: const Text('Clear',
                    style: TextStyle(color: MTCTheme.primaryBlue))),
          ],
        ),
        const SizedBox(height: 10),
        ResultCard(
          title: state.lastResult!.phoneNumber,
          status: state.lastResult!.riskLevel.displayName,
          statusColor: state.lastResult!.riskLevel.color,
          ownerName: state.lastResult!.name,
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('QUICK ACTIONS',
            style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: MTCTheme.textSecondary,
                letterSpacing: 1.2)),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
                child: _actionTile(
                    'Recent Calls', Icons.history, MTCTheme.primaryBlue)),
            const SizedBox(width: 15),
            Expanded(
                child: _actionTile('Blocked', Icons.block, MTCTheme.alertRed)),
          ],
        ),
      ],
    );
  }

  Widget _actionTile(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
          color: MTCTheme.surfaceGray,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12)),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(label,
              style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white)),
        ],
      ),
    );
  }
}
