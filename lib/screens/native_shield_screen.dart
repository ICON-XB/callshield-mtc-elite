import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class NativeShieldScreen extends StatelessWidget {
  const NativeShieldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MTCTheme.primaryNavy,
      appBar: AppBar(
        title: Text('Native OS Shield', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: MTCTheme.primaryNavy,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 30),
              _buildTechnicalHeader(),
              const SizedBox(height: 50),
              _buildOrbitalScanner(),
              const SizedBox(height: 50),
              _buildKernelStatusGrid(),
              const SizedBox(height: 40),
              _buildTelemetryStream(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTechnicalHeader() {
    return Column(
      children: [
        const Text('SYSTEM LEVEL PROTECTION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: MTCTheme.mtcBlue, letterSpacing: 4)),
        const Text('Kernel Shield', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: MTCTheme.safeGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: const Text('HARDWARE INTERCEPTION ACTIVE', style: TextStyle(color: MTCTheme.safeGreen, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildOrbitalScanner() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(width: 280, height: 280, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withValues(alpha: 0.05)))).animate(onPlay: (c) => c.repeat()).scale(duration: 2.seconds, begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2)),
        Container(width: 220, height: 220, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: MTCTheme.mtcBlue.withValues(alpha: 0.1)))).animate(onPlay: (c) => c.repeat()).rotate(duration: 10.seconds),
        Container(
          width: 180, height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [MTCTheme.mtcBlue.withValues(alpha: 0.2), Colors.transparent]),
          ),
          child: const Center(child: Icon(Icons.bolt, color: MTCTheme.mtcBlue, size: 60)),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(duration: 3.seconds),
      ],
    );
  }

  Widget _buildKernelStatusGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: 1.5,
      children: [
        _statusCard('KERNEL VERSION', 'SEC-3.4.2-A', MTCTheme.mtcBlue),
        _statusCard('SIGNAL LATENCY', '14ms', MTCTheme.safeGreen),
        _statusCard('HW INTERCEPTS', '14,204', MTCTheme.mtcBlue),
        _statusCard('PRIVATE KEY', 'VERIFIED', MTCTheme.safeGreen),
      ],
    );
  }

  Widget _statusCard(String label, String val, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: MTCTheme.surfaceGray, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 8, color: Colors.white24, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 5),
          Text(val, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildTelemetryStream() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withValues(alpha: 0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('HW_INTERCEPT_STREAM', style: TextStyle(fontSize: 9, color: MTCTheme.mtcBlue, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          _logLine('Handshaking with telephony.service...'),
          _logLine('MTC Private Key decrypted (AES-256)...'),
          _logLine('CallScreeningService: ATTACHED'),
          _logLine('Monitoring vector V_NAM_01...'),
          const Text('_', style: TextStyle(color: MTCTheme.mtcBlue)).animate(onPlay: (c) => c.repeat()).fade(),
        ],
      ),
    );
  }

  Widget _logLine(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text('> $text', style: GoogleFonts.spaceGrotesk(fontSize: 10, color: Colors.white38)),
    );
  }
}
