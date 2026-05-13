import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinished;
  const SplashScreen({super.key, required this.onFinished});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), widget.onFinished);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MTCTheme.primaryNavy,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Container
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: MTCTheme.primaryBlue.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shield_rounded, color: MTCTheme.primaryBlue, size: 80),
            ).animate()
             .scale(duration: 800.ms, curve: Curves.elasticOut)
             .shimmer(delay: 1.seconds, duration: 2.seconds),
            
            const SizedBox(height: 25),
            
            // App Name
            Text(
              'CallShield',
              style: GoogleFonts.outfit(
                color: MTCTheme.textMain,
                fontWeight: FontWeight.bold,
                fontSize: 36,
                letterSpacing: -1,
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
            
            const SizedBox(height: 5),
            
            // Powered by MTC
            Text(
              'Powered by MTC',
              style: GoogleFonts.outfit(
                color: MTCTheme.primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ).animate().fadeIn(delay: 800.ms),
            
            const SizedBox(height: 80),
            
            // Minimalist Loader
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(MTCTheme.primaryBlue),
              ),
            ).animate().fadeIn(delay: 1.5.seconds),
          ],
        ),
      ),
    );
  }
}
