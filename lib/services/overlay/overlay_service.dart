import 'package:flutter/material.dart';
import '../../models/caller/lookup_result.dart';

/// Manages real-time call overlays on incoming calls
class OverlayService {
  static OverlayEntry? _overlayEntry;
  static bool _isOverlayActive = false;

  /// Shows incoming call overlay
  static void showIncomingCallOverlay(
    BuildContext context,
    LookupResult caller,
    VoidCallback onAnswer,
    VoidCallback onReject,
  ) {
    if (_isOverlayActive) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => _buildCallOverlay(
        caller,
        onAnswer,
        onReject,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isOverlayActive = true;
  }

  /// Hides the overlay
  static void hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isOverlayActive = false;
  }

  static Widget _buildCallOverlay(
    LookupResult caller,
    VoidCallback onAnswer,
    VoidCallback onReject,
  ) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: caller.riskLevel.color.withValues(alpha: 0.95),
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Incoming Call',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                caller.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                caller.phoneNumber,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                caller.riskLevel.displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: onReject,
                    icon: const Icon(Icons.call_end),
                    label: const Text('Reject'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: onAnswer,
                    icon: const Icon(Icons.call),
                    label: const Text('Answer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static bool get isOverlayActive => _isOverlayActive;
}
