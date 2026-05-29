import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../models/premium/premium_model.dart';

/// Premium tier selection card widget
class PremiumTierCard extends StatelessWidget {
  final PremiumModel model;
  final bool isCurrentTier;
  final VoidCallback onSelect;

  const PremiumTierCard({
    super.key,
    required this.model,
    required this.isCurrentTier,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: MTCTheme.surfaceGray,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCurrentTier ? MTCTheme.accentTeal : Colors.white10,
            width: isCurrentTier ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  model.tierName,
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (isCurrentTier)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: MTCTheme.accentTeal.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: MTCTheme.accentTeal),
                    ),
                    child: Text(
                      'CURRENT',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: MTCTheme.accentTeal,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              model.description,
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              model.monthlyPrice == 0
                  ? 'FREE'
                  : 'N\$${model.monthlyPrice}/month',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: MTCTheme.accentTeal,
              ),
            ),
            const SizedBox(height: 16),
            ...model.features.map((feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_rounded,
                        color: MTCTheme.accentTeal,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        feature,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 12),
            if (!isCurrentTier)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onSelect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MTCTheme.accentTeal,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'UPGRADE',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
