import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MTCTheme.primaryNavy,
      appBar: AppBar(
        title: Text('Live Alerts', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: MTCTheme.primaryNavy,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              _buildHeader(),
              const SizedBox(height: 30),
              _buildGlobalActions(),
              const SizedBox(height: 30),
              _buildAlertFeed(),
              const SizedBox(height: 30),
              _buildRegionalThreatMap(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Threat Intelligence',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5)),
        Text('Critical infrastructure monitoring: ACTIVE',
            style: GoogleFonts.inter(color: Colors.white38, fontSize: 12)),
      ],
    );
  }

  Widget _buildGlobalActions() {
    return Row(
      children: [
        _actionButton('Acknowledge All', Icons.done_all, MTCTheme.mtcBlue),
        const SizedBox(width: 20),
        _actionButton('Quarantine', Icons.shutter_speed, MTCTheme.alertRed),
      ],
    );
  }

  Widget _actionButton(String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          boxShadow: [
            if (color == MTCTheme.alertRed)
              BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 15)
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(label.toUpperCase(),
                style: GoogleFonts.spaceGrotesk(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                    letterSpacing: 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertFeed() {
    return Column(
      children: [
        _alertCard(
            'Brute Force Detected',
            'CRITICAL THREAT',
            'Unusual authentication patterns detected from multiple IP ranges targeting GATEWAY_71.',
            MTCTheme.alertRed,
            '02:44:12',
            Icons.warning,
            hasProgress: false),
        _alertCard(
            'Data Leak Prevention',
            'ENCRYPTED SHIELD',
            'Encrypted tunnel attempt intercepted. System successfully rerouted traffic to honeypot node MT-SEC-01.',
            MTCTheme.safeGreen,
            '01:15:00',
            Icons.sensors,
            hasProgress: false),
        _alertCard(
            'Core Latency Spike',
            'SYSTEM ALERT',
            'Network backbone experiencing packet loss at Windhoek HUB-04. Possible physical interference.',
            MTCTheme.alertRed,
            '00:58:32',
            Icons.dns,
            hasProgress: true),
      ],
    );
  }

  Widget _alertCard(String title, String tag, String desc, Color color,
      String time, IconData icon,
      {bool hasProgress = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: MTCTheme.surfaceGray,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12), // Uniform border
      ),
      child: Stack(
        children: [
          // Accent Side
          Positioned(
            left: 0, top: 0, bottom: 0,
            child: Container(width: 4, color: color),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Icon(icon, color: color, size: 20),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            Text(tag,
                                style: GoogleFonts.spaceGrotesk(
                                    fontSize: 8,
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2)),
                          ],
                        ),
                      ],
                    ),
                    Text(time,
                        style: GoogleFonts.spaceGrotesk(
                            fontSize: 10, color: Colors.white24)),
                  ],
                ),
                const SizedBox(height: 15),
                if (hasProgress) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('UPTIME STATUS',
                                  style: TextStyle(
                                      fontSize: 8, color: Colors.white24)),
                              Text('92.4%',
                                  style: TextStyle(
                                      fontSize: 8, color: MTCTheme.alertRed))
                            ]),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                            value: 0.92,
                            backgroundColor: Colors.white10,
                            color: MTCTheme.alertRed,
                            minHeight: 4),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
                Text(desc,
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 12, height: 1.5)),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(child: _miniButton('DISMISS', Colors.white24)),
                    const SizedBox(width: 10),
                    Expanded(child: _miniButton('INVESTIGATE', color)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniButton(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8)),
      child: Center(
          child: Text(label,
              style: GoogleFonts.spaceGrotesk(
                  fontSize: 9, fontWeight: FontWeight.bold, color: color))),
    );
  }

  Widget _buildRegionalThreatMap() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: MTCTheme.surfaceGray,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12)),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Regional Threat Map',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Row(children: [
                Text('LIVE FEED',
                    style: TextStyle(fontSize: 8, color: MTCTheme.safeGreen))
              ]),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDGeRoc6bsKmVSyFPTi5KG8Q1BD857QbPTeaHaxR7q3Jo-Q-pKFb77QlLsOZ5lXbU9NO26cWey89y9t_A1_J2dlKRaMFhvmtnM4v5R3UJ2znPDO_epGE-00Xajq7AkE6JX4wkKD46od5jPB_DpjBX7Ev0PTt-9mYe5KwKy6SeoHrg07KqsRsMuT55k_0L8KUP_JD7tz0VGqgf1xFx3PJD9njWA4NSEP3Ck2jPS5QFBY5EVCQvpPcVhPtHEv0GfhNKZ4sJPwXILTwZ4',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
