import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../models/caller/lookup_result.dart';

/// Real-time incoming call overlay widget
class IncomingCallOverlay extends StatefulWidget {
  final LookupResult caller;
  final VoidCallback onAnswer;
  final VoidCallback onReject;

  const IncomingCallOverlay({
    super.key,
    required this.caller,
    required this.onAnswer,
    required this.onReject,
  });

  @override
  State<IncomingCallOverlay> createState() => _IncomingCallOverlayState();
}

class _IncomingCallOverlayState extends State<IncomingCallOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Full screen background
        GestureDetector(
          onTap: widget.onReject,
          child: Container(
            color: Colors.black.withValues(alpha: 0.6),
          ),
        ),
        // Call card in center
        Center(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: MTCTheme.primaryNavy,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: widget.caller.riskLevel.color.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Risk level badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: widget.caller.riskLevel.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: widget.caller.riskLevel.color,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.caller.riskLevel.displayName.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: widget.caller.riskLevel.color,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Large caller name
                Text(
                  widget.caller.name,
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Phone number
                Text(
                  widget.caller.phoneNumber,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),

                // Network info
                Text(
                  widget.caller.network,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: MTCTheme.accentTeal,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 24),

                // Threat description
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.caller.riskLevel.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.caller.riskLevel.description,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: widget.caller.riskLevel.color,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    // Reject button
                    Expanded(
                      child: GestureDetector(
                        onTap: widget.onReject,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.2),
                            border: Border.all(color: Colors.red, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.call_end_rounded,
                            color: Colors.red,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Answer button
                    Expanded(
                      child: GestureDetector(
                        onTap: widget.onAnswer,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: MTCTheme.safeGreen.withValues(alpha: 0.2),
                            border: Border.all(
                              color: MTCTheme.safeGreen,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.call_rounded,
                            color: MTCTheme.safeGreen,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
