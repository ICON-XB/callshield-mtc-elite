import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MTCTheme.primaryNavy,
      appBar: AppBar(
        title: Text('Global Analytics', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
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
              _buildLiveStatusHero(),
              const SizedBox(height: 30),
              _buildRegionalTelemetry(),
              const SizedBox(height: 30),
              _buildStatsGrid(),
              const SizedBox(height: 30),
              _buildIntelligenceList(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveStatusHero() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: MTCTheme.primaryNavy.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MTCTheme.mtcBlue.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('THREAT LEVEL', style: GoogleFonts.spaceGrotesk(fontSize: 10, color: Colors.white24, fontWeight: FontWeight.bold, letterSpacing: 2)),
              Row(
                children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: MTCTheme.safeGreen, shape: BoxShape.circle)).animate(onPlay: (c) => c.repeat()).fade(duration: 1.seconds),
                  const SizedBox(width: 8),
                  const Text('LIVE FEED', style: TextStyle(color: MTCTheme.safeGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text('MINIMAL RISK', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: MTCTheme.mtcBlue)),
          const Text('99.98% Traffic Sterilized', style: TextStyle(color: Colors.white24, fontSize: 12)),
          const SizedBox(height: 30),
          _buildMockChart(),
        ],
      ),
    );
  }

  Widget _buildMockChart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _bar(0.4), _bar(0.6), _bar(0.85), _bar(0.5), _bar(0.7, color: MTCTheme.safeGreen), _bar(0.95),
      ],
    );
  }

  Widget _bar(double h, {Color color = MTCTheme.mtcBlue}) {
    return Container(
      width: 40, height: 80 * h,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      ),
      child: Stack(
        children: [
          // Accent Border Simulation
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(height: 2, color: color.withValues(alpha: 0.5)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(color: color.withValues(alpha: 0.2), height: 40 * h),
          ),
        ],
      ),
    ).animate().scaleY(begin: 0, duration: 1.seconds, curve: Curves.easeOut);
  }

  Widget _buildRegionalTelemetry() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('REGIONAL TELEMETRY', style: GoogleFonts.spaceGrotesk(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
            Text('NAMIBIA_HQ', style: GoogleFonts.spaceGrotesk(fontSize: 10, color: MTCTheme.mtcBlue, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAitrFt2ZisjMgR62Qx9sqOfmlMrANUr3HFUPxmhk-PmHx4xVLuLU4h6FCqoSwo-Hita6gRhuvxhqxVDT-niCKt0MFJn8cSi5bBF5jqhRx6U4wg7jqy24kSwyHOoCJMszgPA88JYWS4vQOQf_5dOEtBPpFoNvx6Anad9G5USI1v2YE_AB3qnLOhu-0ue5Q7sQwxfWA0Bm9A0sTjeM8CzXoIXNX74pAN3EWFPD4Vz0NSmFqjJ7IQUKlp_tUj3zrdWd4OhiMhDw0mGbY'),
              fit: BoxFit.cover,
              opacity: 0.4,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 100, left: 80,
                child: Column(
                  children: [
                    Container(width: 12, height: 12, decoration: const BoxDecoration(color: MTCTheme.safeGreen, shape: BoxShape.circle)).animate(onPlay: (c) => c.repeat()).scale(duration: 2.seconds),
                    const SizedBox(height: 5),
                    const Text('WINDHOEK: SECURE', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, backgroundColor: Colors.black)),
                  ],
                ),
              ),
              Positioned(
                bottom: 20, left: 20,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _legendItem('STABLE', MTCTheme.safeGreen),
                      _legendItem('MITIGATING', MTCTheme.alertRed),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        _statsCard('BLOCKED ATTACKS', '14.2K', 0.72, MTCTheme.mtcBlue, Icons.shield),
        const SizedBox(width: 20),
        _statsCard('LATENCY MTC', '12ms', 0.15, MTCTheme.safeGreen, Icons.speed),
      ],
    );
  }

  Widget _statsCard(String label, String val, double progress, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: MTCTheme.surfaceGray, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 9, color: Colors.white24, fontWeight: FontWeight.bold)),
            Text(val, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: progress, backgroundColor: Colors.white10, color: color, minHeight: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildIntelligenceList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('RECENT INTELLIGENCE', style: GoogleFonts.spaceGrotesk(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
        const SizedBox(height: 15),
        _intelItem('VoIP Scrubber Active', 'Protocol validation: 100% pass', MTCTheme.mtcBlue, '04:12', Icons.verified_user),
        _intelItem('Gateway Synced', 'Northern Hub parity achieved', MTCTheme.safeGreen, '03:55', Icons.hub),
      ],
    );
  }

  Widget _intelItem(String title, String sub, Color color, String time, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: MTCTheme.surfaceGray,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white12), // Use uniform border
      ),
      child: Stack(
        children: [
          // Accent Side
          Positioned(
            left: 0, top: 0, bottom: 0,
            child: Container(width: 2, color: color),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color, size: 18),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text(sub, style: const TextStyle(fontSize: 10, color: Colors.white24)),
                      ],
                    ),
                  ],
                ),
                Text(time, style: GoogleFonts.spaceGrotesk(fontSize: 9, color: MTCTheme.mtcBlue)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
