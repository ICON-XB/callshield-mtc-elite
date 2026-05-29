import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import '../database/local/database_helper.dart';

class AppLockSetupScreen extends StatefulWidget {
  final VoidCallback onSyncComplete;

  const AppLockSetupScreen({super.key, required this.onSyncComplete});

  @override
  State<AppLockSetupScreen> createState() => _AppLockSetupScreenState();
}

class _AppLockSetupScreenState extends State<AppLockSetupScreen> {
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  bool _useBiometrics = true;
  String _errorMessage = '';

  void _onNumberPressed(int number) {
    setState(() {
      _errorMessage = '';
      if (!_isConfirming) {
        if (_pin.length < 4) {
          _pin += number.toString();
        }
      } else {
        if (_confirmPin.length < 4) {
          _confirmPin += number.toString();
        }
      }
    });

    if (!_isConfirming && _pin.length == 4) {
      // Transition to confirmation phase after a small delay
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _isConfirming = true;
          });
        }
      });
    } else if (_isConfirming && _confirmPin.length == 4) {
      _verifyAndSave();
    }
  }

  void _onDeletePressed() {
    setState(() {
      _errorMessage = '';
      if (!_isConfirming) {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      } else {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        } else {
          _isConfirming = false;
        }
      }
    });
  }

  Future<void> _verifyAndSave() async {
    if (_pin == _confirmPin) {
      // Pin matches, save to database helper
      await DatabaseHelper.instance.saveSetting('is_synced', 'true');
      await DatabaseHelper.instance.saveSetting('security_pin', _pin);
      await DatabaseHelper.instance
          .saveSetting('use_biometric', _useBiometrics ? 'true' : 'false');
      await DatabaseHelper.instance
          .saveSetting('app_lock_delay', '0'); // Immediately lock by default

      // Complete flow
      widget.onSyncComplete();
    } else {
      setState(() {
        _errorMessage = 'PINs do not match. Please try again.';
        _confirmPin = '';
        _pin = '';
        _isConfirming = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MTCTheme.primaryNavy,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            // Icon & Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: MTCTheme.primaryBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.fingerprint_rounded,
                  color: MTCTheme.accentTeal, size: 48),
            ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 25),

            Text(
              _isConfirming ? 'Confirm Security PIN' : 'Create Security PIN',
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _isConfirming
                  ? 'Re-enter your 4-digit PIN to confirm.'
                  : 'Choose a 4-digit PIN to lock your CallShield app.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),

            // PIN Indicator Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final active = _isConfirming
                    ? index < _confirmPin.length
                    : index < _pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: active ? MTCTheme.accentTeal : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: active ? MTCTheme.accentTeal : Colors.white24,
                      width: 2,
                    ),
                    boxShadow: active
                        ? [
                            BoxShadow(
                              color: MTCTheme.accentTeal.withValues(alpha: 0.5),
                              blurRadius: 10,
                            )
                          ]
                        : null,
                  ),
                );
              }),
            ),

            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 15),
              Text(
                _errorMessage,
                style: GoogleFonts.outfit(
                  color: MTCTheme.alertRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ).animate().shake(),
            ],

            const Spacer(),

            // Biometrics Toggle Card
            if (!_isConfirming)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MTCTheme.surfaceGray,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.fingerprint_rounded,
                        color: MTCTheme.primaryBlue, size: 24),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enable Biometrics',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Use fingerprint if supported by device',
                            style: GoogleFonts.outfit(
                              color: Colors.white30,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _useBiometrics,
                      activeThumbColor: MTCTheme.accentTeal,
                      activeTrackColor:
                          MTCTheme.accentTeal.withValues(alpha: 0.2),
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.white10,
                      onChanged: (val) {
                        setState(() {
                          _useBiometrics = val;
                        });
                      },
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms),

            const SizedBox(height: 30),

            // Number Keyboard Pad
            _buildKeyboard(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyboard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [1, 2, 3].map((n) => _buildKey(n)).toList(),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [4, 5, 6].map((n) => _buildKey(n)).toList(),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [7, 8, 9].map((n) => _buildKey(n)).toList(),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 70, height: 70), // Spacer left
              _buildKey(0),
              _buildDeleteKey(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKey(int number) {
    return GestureDetector(
      onTap: () => _onNumberPressed(number),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: MTCTheme.surfaceGray,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: GoogleFonts.outfit(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteKey() {
    return GestureDetector(
      onTap: _onDeletePressed,
      child: Container(
        width: 70,
        height: 70,
        color: Colors.transparent,
        child: const Center(
          child:
              Icon(Icons.backspace_outlined, color: Colors.white54, size: 22),
        ),
      ),
    );
  }
}
