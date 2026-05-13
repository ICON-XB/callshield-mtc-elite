import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D20),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        _buildLeftStreamPanel(),
                        const SizedBox(width: 24),
                        _buildCenterMatrixPanel(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      color: const Color(0xFF0A0E21),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('MTC ELITE', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: MTCTheme.mtcBlue, letterSpacing: 4)),
          const Text('SECURITY COMMAND', style: TextStyle(fontSize: 10, color: Colors.white24, letterSpacing: 2)),
          const SizedBox(height: 60),
          _sidebarItem(Icons.sensors, 'Live Telemetry', isActive: true),
          _sidebarItem(Icons.public, 'Threat Heatmap'),
          _sidebarItem(Icons.insights, 'Analytics'),
          _sidebarItem(Icons.terminal, 'System Logs'),
          const Spacer(),
          _buildOperatorInfo(),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String label, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? MTCTheme.mtcBlue.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: isActive ? MTCTheme.mtcBlue : Colors.transparent, width: 4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: isActive ? Colors.white : Colors.white24, size: 20),
          const SizedBox(width: 15),
          Text(label.toUpperCase(), style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: isActive ? Colors.white : Colors.white24)),
        ],
      ),
    );
  }

  Widget _buildOperatorInfo() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.02), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
      child: Row(
        children: [
          const Icon(Icons.verified_user, color: MTCTheme.mtcBlue, size: 16),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('OPERATOR LOGGED', style: TextStyle(fontSize: 8, color: Colors.white24, fontWeight: FontWeight.bold)),
              Text('ID: MTC-992-SEC', style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(color: const Color(0xFF0A0E21), border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text('CALLSHIELD MTC', style: TextStyle(fontWeight: FontWeight.w900, color: MTCTheme.mtcBlue, letterSpacing: 2)),
              const SizedBox(width: 20),
              Container(width: 1, height: 20, color: Colors.white10),
              const SizedBox(width: 20),
              Row(
                children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: MTCTheme.safeGreen, shape: BoxShape.circle)).animate(onPlay: (c) => c.repeat()).fade(),
                  const SizedBox(width: 10),
                  const Text('NETWORK SECURE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white38)),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _headerStat('SYSTEM STATUS', 'NOMINAL', MTCTheme.safeGreen),
              const SizedBox(width: 40),
              const CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=admin')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerStat(String label, String val, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(fontSize: 8, color: Colors.white24, fontWeight: FontWeight.bold)),
        Text(val, style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildLeftStreamPanel() {
    return SizedBox(
      width: 350,
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: _glassPanel(
              title: 'LIVE TELEMETRY',
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _logEntry('14:22:01', 'INBOUND CALL FILTERED: +264 81 229 XXXX'),
                  _logEntry('14:22:05', 'SUSPICIOUS PACKET DETECTED: NODE_NAM_04', isError: true),
                  _logEntry('14:22:09', 'VOIP HANDSHAKE SECURED: ENCRYPTED', isSuccess: true),
                  _logEntry('14:22:15', 'ANOMALY SCANNING IN PROGRESS...'),
                  _logEntry('14:22:20', 'SYSTEM INTEGRITY: 99.8%'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _glassPanel(
              title: 'INTEGRITY GAUGES',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _circularGauge('CPU LOAD', '82%', 0.82, MTCTheme.safeGreen),
                  _circularGauge('SEC UPTIME', '94%', 0.94, MTCTheme.mtcBlue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logEntry(String time, String msg, {bool isError = false, bool isSuccess = false}) {
    Color color = isError ? MTCTheme.alertRed : (isSuccess ? MTCTheme.safeGreen : Colors.white54);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time, style: GoogleFonts.spaceGrotesk(fontSize: 10, color: MTCTheme.mtcBlue)),
          const SizedBox(width: 15),
          Expanded(child: Text(msg, style: GoogleFonts.spaceGrotesk(fontSize: 10, color: color))),
        ],
      ),
    );
  }

  Widget _circularGauge(String label, String val, double progress, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(width: 60, height: 60, child: CircularProgressIndicator(value: progress, color: color, backgroundColor: Colors.white10, strokeWidth: 4)),
            Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(fontSize: 8, color: Colors.white24, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCenterMatrixPanel() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: _glassPanel(
              title: 'NATIONAL THREAT MATRIX',
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuCQRHSlzsyTaLQrVdVjm-ulSW7pZYgQFjjypwiFUoKFG7NYMrUlnWc5GIhrhhxhekwgXt_3Ol5vPtvIw_-BgP8nxsOC_vdUIlEwFFeIX2HjB7hOqYKU4MpedqUerXMlDRlXIUAMuv0HIzsRcMu1tpXNUduTwS9ktgJt5jfJFncU56FJyBa-T-u5uJKTmwexfMMguBZcEkoJbiJmIJLoctCacWZ-sMcjAoFSAcL7NR5Uzb8zGWtSNkxR6I9g0cevAtVhc1Jcaqd3lNU',
                      width: double.infinity, height: double.infinity, fit: BoxFit.cover, opacity: const AlwaysStoppedAnimation(0.5),
                    ),
                  ),
                  _mapPin(0.4, 0.4, 'WINDHOEK CENTRAL - ALERT', MTCTheme.alertRed, isAlert: true),
                  _mapPin(0.2, 0.5, 'ETOSHA NODE', MTCTheme.safeGreen),
                  _mapPin(0.6, 0.3, 'WALVIS BAY NODE', MTCTheme.mtcBlue),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              children: [
                _bentoMetric('1.2M+', 'THREATS NEUTRALIZED', Icons.security_update_good, MTCTheme.mtcBlue),
                const SizedBox(width: 24),
                _bentoMetric('42ms', 'AVG RESPONSE LATENCY', Icons.speed, MTCTheme.safeGreen),
                const SizedBox(width: 24),
                _bentoMetric('99.98%', 'FILTRATION ACCURACY', Icons.query_stats, MTCTheme.mtcBlue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapPin(double x, double y, String label, Color color, {bool isAlert = false}) {
    return Positioned(
      top: 400 * y, left: 800 * x,
      child: Column(
        children: [
          Container(
            width: 12, height: 12, 
            decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
          ).animate(onPlay: (c) => isAlert ? c.repeat() : null).scale(duration: 1.seconds, begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2)),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4), border: Border.all(color: color.withValues(alpha: 0.3))),
            child: Text(label, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _bentoMetric(String val, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: MTCTheme.primaryNavy, borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withValues(alpha: 0.1))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(val, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                Text(label, style: const TextStyle(fontSize: 8, color: Colors.white24, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _glassPanel({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(color: MTCTheme.primaryNavy.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.bold, color: MTCTheme.mtcBlue, letterSpacing: 2)),
                const Icon(Icons.more_vert, size: 14, color: Colors.white24),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
