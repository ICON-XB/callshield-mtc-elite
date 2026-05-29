import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// CallShield Design System — MTC Brand + Stitch Fintech Aesthetic
/// 
/// Primary: MTC Chambray Blue (#2B5384)
/// Accent: Stitch Teal (#00C9A7) for verified/success states
/// Built for CRAN compliance and MTC white-label readiness.
class MTCTheme {
  // ─── MTC Official Brand Palette (Stitch Dark Theme) ───
  static const Color primaryBlue = Color(0xFF2B5384);   // MTC Chambray Blue
  static const Color accentTeal = Color(0xFF00C9A7);     // Stitch-inspired success
  static const Color safeGreen = Color(0xFF00C9A7);      // Alias for verified states
  static const Color alertRed = Color(0xFFE74C3C);       // Danger / Scam
  static const Color warningAmber = Color(0xFFF39C12);   // Suspicious
  static const Color lowRiskBlue = Color(0xFF3498DB);    // Low risk / info
  
  static const Color primaryNavy = Color(0xFF0F172A);    // Deep Dark Blue (Slate 900) - Background
  static const Color surfaceGray = Color(0xFF1E293B);    // Slate 800 - Cards/Surfaces
  static const Color textMain = Colors.white;            // White text
  static const Color textSecondary = Colors.white70;     // Muted text

  // ─── Backward-compatible aliases ───
  static const Color mtcBlue = primaryBlue;
  static const Color background = primaryNavy;           // Global background is now navy
  static const Color glassWhite = Color(0x1AFFFFFF);

  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.dark, // Crucial: sets default text to white
      scaffoldBackgroundColor: background,
      primaryColor: primaryBlue,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: accentTeal,
        error: alertRed,
        surface: surfaceGray,
        onSurface: textMain,
      ),
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: textMain, fontSize: 32),
        titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: textMain, fontSize: 20),
        bodyLarge: GoogleFonts.outfit(color: textMain, fontSize: 16),
        bodyMedium: GoogleFonts.outfit(color: textSecondary, fontSize: 14),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: textMain),
        titleTextStyle: GoogleFonts.outfit(color: textMain, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      cardTheme: CardThemeData(
        color: surfaceGray,
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      dividerColor: Colors.white12,
    );
  }

  static ThemeData get dark => light; // Both are the dark theme now
}
