import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class ResultCard extends StatelessWidget {
  final String title;
  final String status;
  final Color statusColor;
  final String ownerName;

  const ResultCard({
    super.key, 
    required this.title, 
    required this.status, 
    required this.statusColor,
    required this.ownerName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: MTCTheme.surfaceGray,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: statusColor.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 8))],
        border: Border.all(color: statusColor.withValues(alpha: 0.1), width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: MTCTheme.primaryBlue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: MTCTheme.primaryBlue.withValues(alpha: 0.31)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.storage_rounded, color: MTCTheme.primaryBlue, size: 12),
                const SizedBox(width: 8),
                Text(
                  'SOURCE: OFFICIAL MTC REGISTER',
                  style: GoogleFonts.outfit(fontSize: 9, fontWeight: FontWeight.bold, color: MTCTheme.primaryBlue, letterSpacing: 1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(
              status == 'Safe' ? Icons.verified_rounded : Icons.warning_rounded, 
              color: statusColor, 
              size: 48
            ),
          ),
          const SizedBox(height: 20),
          Text(
            status.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 20, 
              fontWeight: FontWeight.bold, 
              color: statusColor,
              letterSpacing: 0.5
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title, 
            style: GoogleFonts.outfit(
              fontSize: 28, 
              fontWeight: FontWeight.w900, 
              color: MTCTheme.textMain
            )
          ),
          const SizedBox(height: 12),
          Text(
            ownerName, 
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 16, 
              fontWeight: FontWeight.w500, 
              color: MTCTheme.textSecondary
            )
          ),
          const SizedBox(height: 20),
          const Divider(color: MTCTheme.surfaceGray, thickness: 1.5),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.security_rounded, color: MTCTheme.textSecondary, size: 14),
              const SizedBox(width: 8),
              Text(
                'MTC National Database Verified', 
                style: GoogleFonts.outfit(fontSize: 12, color: MTCTheme.textSecondary, fontWeight: FontWeight.w500)
              ),
            ],
          ),
        ],
      ),
    );
  }
}
