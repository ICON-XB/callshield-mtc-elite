import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class BlockedListScreen extends StatelessWidget {
  const BlockedListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MTCTheme.primaryNavy,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text('BLACKLIST ARCHIVE', style: GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(child: _buildBlockedList()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: MTCTheme.primaryBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('BLOCK NEW NUMBER', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          TextField(
            style: GoogleFonts.spaceGrotesk(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search blacklist...',
              hintStyle: const TextStyle(color: Colors.white30),
              prefixIcon: const Icon(Icons.search, color: MTCTheme.primaryBlue),
              filled: true,
              fillColor: MTCTheme.surfaceGray,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _filterChip('ALL', isActive: true),
              _filterChip('SCAMS'),
              _filterChip('SALES'),
              _filterChip('PRIVATE'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? MTCTheme.primaryBlue.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isActive ? MTCTheme.primaryBlue : Colors.transparent),
      ),
      child: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isActive ? Colors.white : Colors.white24)),
    );
  }

  Widget _buildBlockedList() {
    final blocked = [
      {'num': '+264 81 229 4059', 'reason': 'MTC IDENTITY THEFT', 'date': 'Today, 14:02', 'color': MTCTheme.alertRed},
      {'num': '+264 81 002 9931', 'reason': 'TELEMARKETING SALES', 'date': 'Yesterday, 09:15', 'color': Colors.orange},
      {'num': 'PRIVATE CALLER', 'reason': 'HIDDEN NUMBER POLICY', 'date': '2 Days ago', 'color': Colors.grey},
      {'num': '+264 81 553 1029', 'reason': 'VOICE DEEPFAKE DETECTED', 'date': 'May 01', 'color': MTCTheme.alertRed},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: blocked.length,
      itemBuilder: (context, i) {
        final item = blocked[i];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: MTCTheme.surfaceGray,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: (item['color'] as Color).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.block, color: (item['color'] as Color), size: 18),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['num'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(item['reason'] as String, style: GoogleFonts.spaceGrotesk(fontSize: 8, color: (item['color'] as Color), fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(item['date'] as String, style: const TextStyle(fontSize: 8, color: Colors.white10)),
                  const SizedBox(height: 5),
                  const Text('UNBLOCK', style: TextStyle(fontSize: 8, color: MTCTheme.mtcBlue, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: (100 * i).ms).slideX(begin: 0.1);
      },
    );
  }
}
