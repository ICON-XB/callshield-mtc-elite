import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class NativeShieldScreen extends StatefulWidget {
  const NativeShieldScreen({super.key});

  @override
  State<NativeShieldScreen> createState() => _NativeShieldScreenState();
}

class _NativeShieldScreenState extends State<NativeShieldScreen> {
  final List<String> _logs = [
    'Handshaking with telephony.service...',
    'MTC Private Key decrypted (AES-256)...',
    'CallScreeningService: ATTACHED',
    'Monitoring vector V_NAM_01...',
  ];
  
  final List<String> _simulatedLogsPool = [
    'Scan incoming call from +264 81 772 1029 -> Check MTC registry',
    'Registry result: Number NOT registered -> Flagged SUSPICIOUS',
    'Telephony Hook: SMS from "+264 81 002 9911" intercepted',
    'Content scan: Phishing text detected -> Rerouted to Local Quarantine',
    'Registry check: +264 81 476 2464 -> Verified Match: Deon Kayele [ELITE]',
    'VoIP verification handshake completed -> 0 packets lost',
    'Sync threat database: Windhoek central hub -> Synced OK',
    'Telemetry update: 14,204 spam numbers cached locally',
    'Blocked call from spoofed caller ID: +264 81 999 1234',
    'Intercepted SMS text containing: "FNB Security alert, click..." -> Flagged SCAM',
    'Safe sender verified: +264 81 123 4567 (Sarah Namene)',
  ];

  Timer? _timer;
  final Random _random = Random();
  int _interceptCount = 14204;

  @override
  void initState() {
    super.initState();
    _startTelemetryFeed();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTelemetryFeed() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      
      final newLog = _simulatedLogsPool[_random.nextInt(_simulatedLogsPool.length)];
      final timeStr = DateTime.now().toIso8601String().substring(11, 19);
      
      setState(() {
        _logs.add('[$timeStr] $newLog');
        if (_logs.length > 7) {
          _logs.removeAt(0); // Keep logs scroll clean
        }
        if (newLog.contains('Blocked') || newLog.contains('Flagged')) {
          _interceptCount++;
        }
      });
    });
  }

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
        const Text('Kernel Shield', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white)),
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
        _statusCard('HW INTERCEPTS', _interceptCount.toString(), MTCTheme.mtcBlue),
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
          ..._logs.map((log) => _logLine(log)),
          const SizedBox(height: 5),
          const Text('_', style: TextStyle(color: MTCTheme.mtcBlue)).animate(onPlay: (c) => c.repeat()).fade(),
        ],
      ),
    );
  }

  Widget _logLine(String text) {
    Color textColor = Colors.white38;
    if (text.contains('Blocked') || text.contains('Flagged SCAM') || text.contains('SUSPICIOUS')) {
      textColor = MTCTheme.alertRed;
    } else if (text.contains('Verified Match') || text.contains('SAFE') || text.contains('OK')) {
      textColor = MTCTheme.safeGreen;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text('> $text', style: GoogleFonts.spaceGrotesk(fontSize: 10, color: textColor)),
    );
  }
}
