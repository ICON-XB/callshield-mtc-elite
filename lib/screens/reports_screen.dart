import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MTCTheme.primaryNavy,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.white, title: const Text('REPORTS VAULT', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildNationalImpactCard(),
            const SizedBox(height: 40),
            _buildSectionHeader('ACTIVE INVESTIGATIONS'),
            _buildReportItem('+264 81 993 0291', 'MTC INVESTIGATION ACTIVE', MTCTheme.primaryBlue, '92 Interceptions'),
            _buildReportItem('+264 81 445 2210', 'NETWORK-WIDE BLOCK DEPLOYED', MTCTheme.safeGreen, '1,204 Namibians Saved'),
            _buildReportItem('+264 81 002 9911', 'UNDER REVIEW BY SECURITY STAFF', Colors.orange, 'Awaiting Verification'),
            const SizedBox(height: 30),
            _buildSectionHeader('CLOSED CASES'),
            _buildReportItem('+264 81 772 1029', 'THREAT NEUTRALIZED', MTCTheme.safeGreen, 'Verified Scam Source'),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildNationalImpactCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [MTCTheme.primaryNavy, MTCTheme.primaryBlue.withValues(alpha: 0.2)]),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: MTCTheme.primaryBlue.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Text('NATIONAL IMPACT', style: TextStyle(fontSize: 10, color: MTCTheme.accentTeal, fontWeight: FontWeight.bold, letterSpacing: 3)),
          const SizedBox(height: 15),
          const Text('1,402', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white)),
          const Text('People Protected by your reports', style: TextStyle(fontSize: 12, color: Colors.white54)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: MTCTheme.primaryBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: const Text('LEVEL 3 CONTRIBUTOR', style: TextStyle(color: MTCTheme.accentTeal, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ).animate().scale(duration: 800.ms);
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: GoogleFonts.spaceGrotesk(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white24, letterSpacing: 2)),
      ),
    );
  }

  Widget _buildReportItem(String num, String status, Color color, String result) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MTCTheme.surfaceGray,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(num, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              const Icon(Icons.chevron_right, color: Colors.white10),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)).animate(onPlay: (c) => c.repeat()).fade(),
              const SizedBox(width: 10),
              Text(status, style: GoogleFonts.spaceGrotesk(fontSize: 9, color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 15),
          Text(result, style: const TextStyle(fontSize: 11, color: Colors.white54)),
        ],
      ),
    );
  }
}
