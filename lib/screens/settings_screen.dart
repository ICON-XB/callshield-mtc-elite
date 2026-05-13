import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import 'blocked_list_screen.dart';
import 'report_form_screen.dart';
import 'premium_status_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MTCTheme.primaryNavy,
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: MTCTheme.primaryNavy,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          children: [
            const SizedBox(height: 30),
            _buildHeader(),
            const SizedBox(height: 30),
            _buildPremiumPromotion(context),
            const SizedBox(height: 30),
            _buildSectionHeader('SECURITY ARCHIVE'),
            _buildTacticalButton(context, 'Blacklist Archive', 'Manage 1,248 blocked entities', Icons.block, const BlockedListScreen()),
            _buildTacticalButton(context, 'Report Scammer', 'Submit to MTC National Database', Icons.report_problem, const ReportFormScreen()),
            const SizedBox(height: 30),
            _buildSectionHeader('TACTICAL BLOCKING RULES'),
            _settingToggle('AI Voice Signature Scan', true, Icons.psychology),
            _settingToggle('Hidden Number Shield', true, Icons.visibility_off),
            _settingToggle('International Scam Block', false, Icons.public),
            _settingToggle('Spam SMS Sterilization', true, Icons.message),
            const SizedBox(height: 30),
            _buildSectionHeader('SYSTEM PREFERENCES'),
            _settingToggle('Biometric App Lock', false, Icons.fingerprint),
            _settingLink('MTC Network Status', Icons.network_check),
            _settingLink('Privacy & Legal', Icons.description),
            const SizedBox(height: 50),
            const Center(child: Text('Version 3.4.2-Elite', style: TextStyle(color: Colors.white10, fontSize: 10))),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ELITE COMMAND', style: GoogleFonts.spaceGrotesk(color: MTCTheme.accentTeal, fontWeight: FontWeight.bold, letterSpacing: 4, fontSize: 10)),
        const Text('Configuration', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white)),
      ],
    );
  }

  Widget _buildPremiumPromotion(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumStatusScreen())),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [MTCTheme.primaryBlue, MTCTheme.accentTeal]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: MTCTheme.primaryBlue.withValues(alpha: 0.3), blurRadius: 20)],
        ),
        child: const Row(
          children: [
            Icon(Icons.star, color: Colors.white),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ANNUAL ELITE ACTIVE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white)),
                Text('Tap to view your premium perks', style: TextStyle(fontSize: 10, color: Colors.white70)),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 5),
      child: Text(title, style: GoogleFonts.spaceGrotesk(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white24, letterSpacing: 2)),
    );
  }

  Widget _buildTacticalButton(BuildContext context, String title, String sub, IconData icon, Widget target) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: MTCTheme.surfaceGray, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white12)),
      child: ListTile(
        leading: Icon(icon, color: MTCTheme.primaryBlue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
        subtitle: Text(sub, style: const TextStyle(fontSize: 10, color: Colors.white54)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white10, size: 12),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => target)),
      ),
    );
  }

  Widget _settingToggle(String title, bool val, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: MTCTheme.surfaceGray, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white12)),
      child: SwitchListTile(
        value: val,
        onChanged: (v) {},
        secondary: Icon(icon, color: Colors.white54, size: 20),
        title: Text(title, style: const TextStyle(fontSize: 13, color: Colors.white)),
        activeColor: MTCTheme.accentTeal,
      ),
    );
  }

  Widget _settingLink(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.white10, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 13)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white10, size: 12),
      onTap: () {},
    );
  }
}
