import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import 'app_lock_setup_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback onSyncComplete;
  
  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.onSyncComplete,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late String _currentOtp;
  int _secondsRemaining = 60;
  Timer? _timer;
  bool _isExpired = false;
  bool _showSmsNotification = false;
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    _generateAndSendOtp();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _generateAndSendOtp() {
    final random = Random();
    _currentOtp = (100000 + random.nextInt(900000)).toString();
    _secondsRemaining = 60;
    _isExpired = false;
    
    for (var controller in _controllers) {
      controller.clear();
    }

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _isExpired = true;
          _timer?.cancel();
        });
      }
    });

    // Trigger simulated incoming SMS notification
    setState(() {
      _showSmsNotification = false;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showSmsNotification = true;
        });
      }
    });

    // Automatically hide SMS notification after 6 seconds
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          _showSmsNotification = false;
        });
      }
    });
  }

  void _verifyOtp() {
    if (_isExpired) return;

    final enteredOtp = _controllers.map((c) => c.text).join();
    if (enteredOtp == _currentOtp) {
      _timer?.cancel();
      
      // Navigate to App Lock Setup
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AppLockSetupScreen(
            onSyncComplete: widget.onSyncComplete,
          ),
        ),
      );
    } else {
      // Clear fields and show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid OTP code. Please check your SMS and try again.', style: GoogleFonts.outfit()),
          backgroundColor: MTCTheme.alertRed,
        ),
      );
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MTCTheme.primaryNavy,
      body: Stack(
        children: [
          // Main Body
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: MTCTheme.primaryBlue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mark_email_read_outlined, color: MTCTheme.accentTeal, size: 50),
                  ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                  const SizedBox(height: 30),
                  Text(
                    'Verification Code',
                    style: GoogleFonts.outfit(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'We sent a 2FA verification code to\n${widget.phoneNumber}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      color: Colors.white54,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // OTP input boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 48,
                        height: 58,
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          enabled: !_isExpired,
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: MTCTheme.surfaceGray,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.white10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: MTCTheme.accentTeal, width: 2),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              if (index < 5) {
                                _focusNodes[index + 1].requestFocus();
                              } else {
                                _focusNodes[index].unfocus();
                                _verifyOtp();
                              }
                            } else {
                              if (index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }
                            }
                          },
                        ),
                      );
                    }),
                  ),
                  
                  const SizedBox(height: 35),
                  
                  // Countdown Timer
                  if (!_isExpired)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.timer_outlined, color: Colors.white30, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'OTP expires in 0:${_secondsRemaining.toString().padLeft(2, '0')}',
                          style: GoogleFonts.outfit(
                            color: Colors.white54,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        Text(
                          'OTP code has expired.',
                          style: GoogleFonts.outfit(
                            color: MTCTheme.alertRed,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextButton.icon(
                          onPressed: _generateAndSendOtp,
                          icon: const Icon(Icons.refresh_rounded, color: MTCTheme.accentTeal),
                          label: Text(
                            'RESEND CODE VIA SMS',
                            style: GoogleFonts.outfit(
                              color: MTCTheme.accentTeal,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              letterSpacing: 1.2,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            backgroundColor: MTCTheme.accentTeal.withValues(alpha: 0.1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
          
          // Simulated SMS Alert Notification at the top
          if (_showSmsNotification)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 15,
              right: 15,
              child: GestureDetector(
                onTap: () {
                  // Copy to clipboard simulation
                  for (int i = 0; i < _currentOtp.length; i++) {
                    _controllers[i].text = _currentOtp[i];
                  }
                  _focusNodes[5].requestFocus();
                  setState(() {
                    _showSmsNotification = false;
                  });
                  _verifyOtp();
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: MTCTheme.primaryBlue.withValues(alpha: 0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(80),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: MTCTheme.primaryBlue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.sms_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'MTC Secure OTP',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  'Just now',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white30,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Your CallShield authentication code is: $_currentOtp. Tap to auto-fill.',
                              style: GoogleFonts.outfit(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().slideY(begin: -2.0, end: 0, duration: 600.ms, curve: Curves.easeOutBack),
            ),
        ],
      ),
    );
  }
}
