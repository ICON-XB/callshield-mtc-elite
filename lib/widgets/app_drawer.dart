import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import '../screens/premium_status_screen.dart';
import '../screens/lookup_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/alerts_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/simulation_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: MTCTheme.primaryNavy,
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(context, 'Elite Dashboard', Icons.dashboard_rounded, null, isSelected: true),
                _drawerItem(context, 'Set as Default App', Icons.settings_suggest_rounded, null, iconColor: MTCTheme.accentTeal),
                _drawerItem(context, 'Number Lookup', Icons.search_rounded, const LookupScreen()),
                _drawerItem(context, 'Active Protection', Icons.shield_rounded, const SimulationScreen()),
                const Divider(color: Colors.white10, height: 30, indent: 20, endIndent: 20),
                _drawerItem(context, 'Threat Alerts', Icons.notifications_active_rounded, const AlertsScreen()),
                _drawerItem(context, 'Incident Reports', Icons.description_rounded, const ReportsScreen()),
                _drawerItem(context, 'Premium Elite', Icons.star_rounded, const PremiumStatusScreen(), iconColor: Colors.amber),
                const Divider(color: Colors.white10, height: 30, indent: 20, endIndent: 20),
                _drawerItem(context, 'Settings', Icons.settings_rounded, const SettingsScreen()),
                _drawerItem(context, 'Support', Icons.help_outline_rounded, null),
              ],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 24, bottom: 30, right: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF10141D),
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MTCTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.shield, color: MTCTheme.primaryBlue, size: 30),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CALLSHIELD', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
                  Text('MTC ELITE EDITION', style: GoogleFonts.outfit(fontSize: 10, color: MTCTheme.accentTeal, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String title, IconData icon, Widget? destination, {bool isSelected = false, Color? iconColor}) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? (isSelected ? MTCTheme.mtcBlue : Colors.white60), size: 22),
      title: Text(title, style: GoogleFonts.outfit(color: isSelected ? Colors.white : Colors.white70, fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      onTap: () {
        Navigator.pop(context); // Close drawer
        if (destination != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          const Icon(Icons.logout_rounded, color: Colors.white24, size: 20),
          const SizedBox(width: 10),
          Text('Sign Out', style: GoogleFonts.outfit(color: Colors.white24, fontSize: 14)),
          const Spacer(),
          Text('v2.1.0', style: GoogleFonts.outfit(color: Colors.white10, fontSize: 10)),
        ],
      ),
    );
  }
}
