import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import '../database/local/database_helper.dart';
import 'app_lock_setup_screen.dart';
import 'smart_rules_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _realTimeProtection = true;
  bool _autoBlock = true;
  bool _identifySms = false;

  bool _appLockEnabled = true;
  bool _useBiometrics = true;
  String _lockDelay = '0'; // '0' = Immediately, '1' = 1 min, '10' = 10 min

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final isSynced = await DatabaseHelper.instance.getSetting('is_synced');
    final useBio = await DatabaseHelper.instance.getSetting('use_biometric');
    final delay = await DatabaseHelper.instance.getSetting('app_lock_delay');

    if (mounted) {
      setState(() {
        _appLockEnabled = isSynced == 'true';
        _useBiometrics = useBio != 'false';
        _lockDelay = delay ?? '0';
      });
    }
  }

  Future<void> _toggleAppLock(bool value) async {
    setState(() {
      _appLockEnabled = value;
    });
    if (value) {
      // Direct them to PIN / Lock setup
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AppLockSetupScreen(
            onSyncComplete: () {
              Navigator.pop(context); // Go back to settings
              _loadSettings();
            },
          ),
        ),
      );
    } else {
      await DatabaseHelper.instance.saveSetting('is_synced', 'false');
      _loadSettings();
    }
  }

  Future<void> _toggleBiometrics(bool value) async {
    setState(() {
      _useBiometrics = value;
    });
    await DatabaseHelper.instance
        .saveSetting('use_biometric', value ? 'true' : 'false');
  }

  Future<void> _changeLockDelay(String? delayValue) async {
    if (delayValue == null) return;
    setState(() {
      _lockDelay = delayValue;
    });
    await DatabaseHelper.instance.saveSetting('app_lock_delay', delayValue);
  }

  void _changePin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppLockSetupScreen(
          onSyncComplete: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Security PIN updated successfully.',
                    style: GoogleFonts.outfit()),
                backgroundColor: MTCTheme.safeGreen,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [MTCTheme.primaryNavy, Color(0xFF05070A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            children: [
              const SizedBox(height: 30),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildSectionHeader('PREMIUM ACCOUNT'),
              _buildPremiumCard(),
              const SizedBox(height: 30),
              _buildSectionHeader('APP LOCK SECURITY'),
              _settingToggle('Enable App Lock', _appLockEnabled,
                  Icons.lock_outline, _toggleAppLock),
              if (_appLockEnabled) ...[
                _settingToggle('Use Fingerprint/Biometrics', _useBiometrics,
                    Icons.fingerprint, _toggleBiometrics),
                _buildLockDelayTile(),
                _settingActionTile(
                    'Change Security PIN', Icons.password_rounded, _changePin),
              ],
              const SizedBox(height: 30),
              _buildSectionHeader('THREAT PROTECTION'),
              _settingToggle(
                  'Real-time Verification',
                  _realTimeProtection,
                  Icons.security,
                  (v) => setState(() => _realTimeProtection = v)),
              _settingToggle('Auto-Block Spam Database', _autoBlock,
                  Icons.block, (v) => setState(() => _autoBlock = v)),
              _settingToggle('SMS Spam Filtering Engine', _identifySms,
                  Icons.message, (v) => setState(() => _identifySms = v)),
              _settingActionTile(
                'Smart Rules',
                Icons.rule_folder,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SmartRulesScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildSectionHeader('SUPPORT & LEGAL'),
              _settingLink('MTC Privacy Policy', Icons.description),
              _settingLink('Contact MTC Security Support', Icons.support_agent),
              const SizedBox(height: 50),
              const Center(
                child: Text(
                  'Version 3.0.0 (Elite Build)',
                  style: TextStyle(color: Colors.white10, fontSize: 10),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: Colors.white70, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 5),
            Text(
              'Settings',
              style: GoogleFonts.outfit(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 5),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white24,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildPremiumCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient:
            const LinearGradient(colors: [MTCTheme.mtcBlue, Color(0xFF00D2FF)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white24,
            child: Icon(Icons.star, color: Colors.white),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ELITE MEMBER',
                style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Colors.white),
              ),
              Text(
                'Deon Kayele',
                style: GoogleFonts.outfit(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'ACTIVE',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingToggle(
      String title, bool val, IconData icon, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: SwitchListTile(
        value: val,
        onChanged: onChanged,
        secondary: Icon(icon, color: MTCTheme.mtcBlue, size: 20),
        title: Text(title,
            style: GoogleFonts.outfit(fontSize: 14, color: Colors.white)),
        activeThumbColor: MTCTheme.accentTeal,
        activeTrackColor: MTCTheme.accentTeal.withValues(alpha: 0.2),
        inactiveThumbColor: Colors.grey,
        inactiveTrackColor: Colors.white10,
      ),
    );
  }

  Widget _settingActionTile(String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        leading: Icon(icon, color: MTCTheme.mtcBlue, size: 20),
        title: Text(title,
            style: GoogleFonts.outfit(fontSize: 14, color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios,
            color: Colors.white30, size: 12),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLockDelayTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, color: MTCTheme.mtcBlue, size: 20),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              'Lock Automatically',
              style: GoogleFonts.outfit(fontSize: 14, color: Colors.white),
            ),
          ),
          DropdownButton<String>(
            value: _lockDelay,
            dropdownColor: MTCTheme.primaryNavy,
            underline: Container(),
            style: GoogleFonts.outfit(
                color: MTCTheme.accentTeal,
                fontSize: 13,
                fontWeight: FontWeight.bold),
            items: const [
              DropdownMenuItem(value: '0', child: Text('Immediately')),
              DropdownMenuItem(value: '1', child: Text('After 1 minute')),
              DropdownMenuItem(value: '10', child: Text('After 10 minutes')),
            ],
            onChanged: _changeLockDelay,
          ),
        ],
      ),
    );
  }

  Widget _settingLink(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.white24, size: 20),
      title: Text(title,
          style: GoogleFonts.outfit(fontSize: 14, color: Colors.white)),
      trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.white10, size: 12),
      onTap: () {},
    );
  }
}
