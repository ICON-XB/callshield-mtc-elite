import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import 'otp_verification_screen.dart';


class IdentitySyncScreen extends StatefulWidget {
  final VoidCallback onSyncComplete;
  const IdentitySyncScreen({super.key, required this.onSyncComplete});

  @override
  State<IdentitySyncScreen> createState() => _IdentitySyncScreenState();
}

class _IdentitySyncScreenState extends State<IdentitySyncScreen> {
  bool _isSyncing = false;
  bool _syncFinished = false;
  final TextEditingController _phoneController = TextEditingController();
  
  Map<String, String>? _syncedProfile;

  final Map<String, Map<String, String>> _mtcDatabase = {
    '0814762464': {
      'name': 'Deon',
      'surname': 'Kayele',
      'role': 'Elite System Architect',
      'photo': 'https://images.unsplash.com/photo-1519085185758-2ed980ba33b0?w=400',
    },
    '0811234567': {
      'name': 'Sarah',
      'surname': 'Namene',
      'role': 'Security Specialist',
      'photo': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
    },
  };

  void _startSync() async {
    if (_phoneController.text.isEmpty) return;
    
    setState(() => _isSyncing = true);
    
    await Future.delayed(2.seconds);
    
    final cleaned = _phoneController.text.replaceAll(' ', '');
    _syncedProfile = _mtcDatabase[cleaned] ?? {
      'name': 'Guest',
      'surname': 'User',
      'role': 'Standard Profile',
      'photo': 'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=400',
    };

    await Future.delayed(2.seconds); 
    setState(() => _syncFinished = true);
    await Future.delayed(3.seconds); 
    
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(
            phoneNumber: _phoneController.text,
            onSyncComplete: widget.onSyncComplete,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MTCTheme.primaryNavy,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_syncFinished) _buildLogo(),
              const SizedBox(height: 50),
              _buildDynamicContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: MTCTheme.primaryBlue.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.security, color: MTCTheme.primaryBlue, size: 60),
        ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 3.seconds),
        const SizedBox(height: 25),
        Text('IDENTITY SYNC', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 4, color: MTCTheme.textMain)),
        Text('MTC NATIONAL REGISTRY', style: GoogleFonts.outfit(fontSize: 10, color: MTCTheme.textSecondary, letterSpacing: 2, fontWeight: FontWeight.bold)),
      ],
    ).animate().fadeIn().slideY(begin: -0.1);
  }

  Widget _buildDynamicContent() {
    if (_syncFinished) return _buildProfileReveal();
    if (_isSyncing) return _buildSyncingProgress();
    return _buildInputForm();
  }

  bool _consentGiven = false;

  Widget _buildInputForm() {
    return Column(
      children: [
        const Text('Enter your authorized MTC number to synchronize your profile.', 
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 40),
        Container(
          decoration: BoxDecoration(
            color: MTCTheme.surfaceGray,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white12),
          ),
          child: TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 4, color: Colors.white),
            decoration: InputDecoration(
              hintText: '081 XXX XXXX',
              hintStyle: const TextStyle(color: Colors.white24),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // --- Privacy Consent Flow ---
        Row(
          children: [
            Checkbox(
              value: _consentGiven,
              activeColor: MTCTheme.accentTeal,
              checkColor: MTCTheme.primaryNavy,
              side: const BorderSide(color: Colors.white54),
              onChanged: (v) => setState(() => _consentGiven = v ?? false),
            ),
            const Expanded(
              child: Text(
                'I consent to the processing of my data in accordance with the Namibian Data Protection Act and POPIA guidelines.',
                style: TextStyle(fontSize: 10, color: MTCTheme.textSecondary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _consentGiven ? _startSync : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: MTCTheme.accentTeal,
            disabledBackgroundColor: MTCTheme.surfaceGray,
            foregroundColor: MTCTheme.primaryNavy,
            minimumSize: const Size(double.infinity, 70),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: _consentGiven ? 10 : 0,
            shadowColor: MTCTheme.accentTeal.withValues(alpha: 0.3),
          ),
          child: const Text('ACTIVATE SHIELD', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        ),
      ],
    );
  }


  Widget _buildSyncingProgress() {
    return Column(
      children: [
        const CircularProgressIndicator(color: MTCTheme.primaryBlue, strokeWidth: 3),
        const SizedBox(height: 40),
        Text('FETCHING IDENTITY...', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: MTCTheme.primaryBlue, letterSpacing: 2)),
      ],
    );
  }

  Widget _buildProfileReveal() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: MTCTheme.safeGreen, width: 3),
            boxShadow: [BoxShadow(color: MTCTheme.safeGreen.withValues(alpha: 0.2), blurRadius: 30)],
          ),
          child: CircleAvatar(
            radius: 70,
            backgroundImage: NetworkImage(_syncedProfile!['photo']!),
          ),
        ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
        const SizedBox(height: 30),
        Text('VERIFICATION SUCCESS', style: GoogleFonts.outfit(color: MTCTheme.safeGreen, fontWeight: FontWeight.bold, letterSpacing: 4, fontSize: 12)),
        const SizedBox(height: 10),
        Text('${_syncedProfile!['name']} ${_syncedProfile!['surname']}', style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: MTCTheme.textMain)),
        Text(_syncedProfile!['role']!.toUpperCase(), style: GoogleFonts.outfit(color: MTCTheme.textSecondary, letterSpacing: 2, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    ).animate().fadeIn();
  }
}
