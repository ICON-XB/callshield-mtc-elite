import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class PremiumStatusScreen extends StatelessWidget {
  const PremiumStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MTCTheme.primaryNavy,
      appBar: AppBar(
        title: const Text('CallShield Elite'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEliteHeader(),
            const SizedBox(height: 30),
            Text('ELITE BENEFITS', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: MTCTheme.textSecondary, letterSpacing: 1.5)),
            const SizedBox(height: 15),
            _buildPerksGrid(),
            const SizedBox(height: 40),
            _buildSubscriptionCard(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildEliteHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: MTCTheme.surfaceGray,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20)],
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [MTCTheme.primaryBlue, MTCTheme.accentTeal]),
              boxShadow: [BoxShadow(color: MTCTheme.primaryBlue.withValues(alpha: 0.2), blurRadius: 30)],
            ),
            child: const Icon(Icons.star_rounded, color: Colors.white, size: 50),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(duration: 2.seconds, begin: const Offset(0.95, 0.95)),
          const SizedBox(height: 20),
          Text('MTC ELITE ACTIVE', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w900, color: MTCTheme.accentTeal, letterSpacing: 1.5)),
          const SizedBox(height: 5),
          Text('Your device has maximum protection.', style: GoogleFonts.outfit(fontSize: 14, color: MTCTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildPerksGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1.1,
      children: [
        _perkCard('Unlimited Lookups', 'Direct access to MTC API', Icons.manage_search_rounded),
        _perkCard('AI SMS Filter', 'Deep scan for phishing links', Icons.message_rounded),
        _perkCard('Ad-Free Experience', 'Zero interruptions', Icons.block_flipped),
        _perkCard('Priority Support', '24/7 MTC Security Team', Icons.support_agent_rounded),
      ],
    );
  }

  Widget _perkCard(String title, String sub, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: MTCTheme.surfaceGray, 
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: MTCTheme.accentTeal, size: 28),
          const Spacer(),
          Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13, color: MTCTheme.textMain)),
          const SizedBox(height: 4),
          Text(sub, style: GoogleFonts.outfit(fontSize: 10, color: MTCTheme.textSecondary, height: 1.2)),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [MTCTheme.primaryBlue, Color(0xFF1E3A5F)]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: MTCTheme.primaryBlue.withValues(alpha: 0.23), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('BILLING METHOD', style: GoogleFonts.outfit(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.bold, letterSpacing: 2)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: MTCTheme.accentTeal.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                child: const Text('SEAMLESS', style: TextStyle(color: MTCTheme.accentTeal, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text('MTC Airtime Deduction', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
          const SizedBox(height: 5),
          const Text('N\$ 29.99 / month automatically billed to your MTC account.', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, 
              foregroundColor: MTCTheme.primaryBlue, 
              minimumSize: const Size(double.infinity, 50), 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
            ),
            child: const Text('MANAGE PLAN', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
