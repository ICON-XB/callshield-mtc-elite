import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import '../database/local/database_helper.dart';

class AppLockScreen extends StatefulWidget {
  final VoidCallback onUnlock;

  const AppLockScreen({super.key, required this.onUnlock});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  String _enteredPin = '';
  String _storedPin = '';
  bool _useBiometrics = true;
  bool _isPinMode = false;
  bool _isScanning = false;
  bool _scanSuccess = false;
  String _statusMessage = 'Touch the fingerprint sensor to unlock';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSettingsAndInitAuth();
  }

  Future<void> _loadSettingsAndInitAuth() async {
    final pin = await DatabaseHelper.instance.getSetting('security_pin');
    final useBioStr = await DatabaseHelper.instance.getSetting('use_biometric');

    setState(() {
      _storedPin = pin ?? '1234';
      _useBiometrics = useBioStr != 'false';
      _isPinMode = !_useBiometrics;
    });

    if (_useBiometrics) {
      _startSimulatedScan();
    }
  }

  void _startSimulatedScan() {
    if (_isScanning || _scanSuccess) return;

    setState(() {
      _isScanning = true;
      _statusMessage = 'Scanning fingerprint...';
      _errorMessage = '';
    });

    // Simulate standard biometric sensor read delay (1.2s)
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;

      setState(() {
        _isScanning = false;
        _scanSuccess = true;
        _statusMessage = 'Identity Verified';
      });

      // Navigate after success check animation
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          widget.onUnlock();
        }
      });
    });
  }

  void _onNumberPressed(int number) {
    setState(() {
      _errorMessage = '';
      if (_enteredPin.length < 4) {
        _enteredPin += number.toString();
      }
    });

    if (_enteredPin.length == 4) {
      _verifyPin();
    }
  }

  void _onDeletePressed() {
    setState(() {
      _errorMessage = '';
      if (_enteredPin.isNotEmpty) {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      }
    });
  }

  void _verifyPin() {
    if (_enteredPin == _storedPin) {
      widget.onUnlock();
    } else {
      setState(() {
        _errorMessage = 'Incorrect Security PIN';
        _enteredPin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MTCTheme.primaryNavy,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _isPinMode ? _buildPinLayout() : _buildFingerprintLayout(),
        ),
      ),
    );
  }

  Widget _buildFingerprintLayout() {
    return Column(
      key: const ValueKey('fingerprint_layout'),
      children: [
        const Spacer(flex: 2),

        // Brand Shield / Lock Icon Header
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield_rounded,
                color: MTCTheme.primaryBlue, size: 24),
            const SizedBox(width: 8),
            Text(
              'CALLSHIELD ELITE',
              style: GoogleFonts.outfit(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 3,
              ),
            ),
          ],
        ).animate().fadeIn(duration: 400.ms),

        const Spacer(flex: 1),

        // Animated Fingerprint Scan Area
        GestureDetector(
          onTap: _startSimulatedScan,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulse circles under the fingerprint
              if (_isScanning) ...[
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: MTCTheme.accentTeal.withValues(alpha: 0.2),
                        width: 2),
                  ),
                )
                    .animate(onPlay: (c) => c.repeat())
                    .scale(end: const Offset(1.5, 1.5), duration: 1200.ms)
                    .fadeOut(duration: 1200.ms),
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: MTCTheme.accentTeal.withValues(alpha: 0.4),
                        width: 1),
                  ),
                )
                    .animate(onPlay: (c) => c.repeat())
                    .scale(
                        end: const Offset(1.2, 1.2),
                        duration: 1200.ms,
                        delay: 400.ms)
                    .fadeOut(duration: 1200.ms),
              ],

              // Scanner container
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: _scanSuccess
                      ? MTCTheme.safeGreen.withValues(alpha: 0.1)
                      : MTCTheme.surfaceGray,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _scanSuccess
                        ? MTCTheme.safeGreen
                        : (_isScanning ? MTCTheme.accentTeal : Colors.white10),
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Icon(
                    _scanSuccess
                        ? Icons.check_circle_outline_rounded
                        : Icons.fingerprint_rounded,
                    color: _scanSuccess
                        ? MTCTheme.safeGreen
                        : (_isScanning ? MTCTheme.accentTeal : Colors.white60),
                    size: 64,
                  ),
                ),
              )
                  .animate(target: _scanSuccess ? 1 : 0)
                  .shimmer(duration: 1.seconds, color: MTCTheme.accentTeal),
            ],
          ),
        ),

        const SizedBox(height: 35),

        Text(
          _statusMessage,
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            color: _scanSuccess ? MTCTheme.safeGreen : Colors.white54,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),

        const Spacer(flex: 2),

        // Fallback to PIN
        TextButton(
          onPressed: () {
            setState(() {
              _isPinMode = true;
            });
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(
            'USE SECURITY PIN',
            style: GoogleFonts.outfit(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.5,
            ),
          ),
        ).animate().fadeIn(delay: 400.ms),

        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildPinLayout() {
    return Column(
      key: const ValueKey('pin_layout'),
      children: [
        const Spacer(),

        // Header
        Text(
          'Enter Security PIN',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Enter your 4-digit PIN code to unlock the app.',
          style: GoogleFonts.outfit(
            color: Colors.white54,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 35),

        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            final active = index < _enteredPin.length;
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
          const SizedBox(height: 20),
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

        // PIN Pad
        _buildKeyboard(),

        // Switch back to Biometrics
        if (_useBiometrics) ...[
          const SizedBox(height: 20),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _isPinMode = false;
                _scanSuccess = false;
              });
              _startSimulatedScan();
            },
            icon: const Icon(Icons.fingerprint_rounded,
                color: MTCTheme.accentTeal, size: 18),
            label: Text(
              'USE FINGERPRINT UNLOCK',
              style: GoogleFonts.outfit(
                color: MTCTheme.accentTeal,
                fontWeight: FontWeight.bold,
                fontSize: 11,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],

        const Spacer(),
      ],
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
