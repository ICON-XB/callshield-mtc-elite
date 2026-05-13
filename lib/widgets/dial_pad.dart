import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class DialPadOverlay extends StatefulWidget {
  const DialPadOverlay({Key? key}) : super(key: key);

  @override
  State<DialPadOverlay> createState() => _DialPadOverlayState();
}

class _DialPadOverlayState extends State<DialPadOverlay> {
  String _input = '';

  void _addDigit(String d) {
    setState(() {
      if (_input.length < 15) _input += d;
    });
  }

  void _removeDigit() {
    setState(() {
      if (_input.isNotEmpty) _input = _input.substring(0, _input.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 30),
          Text(
            _input.isEmpty ? 'Enter Number' : _input,
            style: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: _input.isEmpty ? Colors.grey[300] : MTCTheme.textMain),
          ),
          const SizedBox(height: 10),
          if (_input.isNotEmpty) 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified_user, color: MTCTheme.safeGreen, size: 14),
                const SizedBox(width: 5),
                Text('VERIFYING WITH MTC REGISTRY...', style: GoogleFonts.outfit(fontSize: 10, color: MTCTheme.primaryBlue, fontWeight: FontWeight.bold)),
              ],
            ),
          const Spacer(),
          _buildKeypad(),
          const SizedBox(height: 30),
          _buildCallActions(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        _keyRow(['1', '2', '3']),
        _keyRow(['4', '5', '6']),
        _keyRow(['7', '8', '9']),
        _keyRow(['*', '0', '#']),
      ],
    );
  }

  Widget _keyRow(List<String> keys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: keys.map((k) => _keyBtn(k)).toList(),
      ),
    );
  }

  Widget _keyBtn(String k) {
    return GestureDetector(
      onTap: () => _addDigit(k),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(color: MTCTheme.surfaceGray, shape: BoxShape.circle),
        child: Center(
          child: Text(k, style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  Widget _buildCallActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(width: 70), // Spacer
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(color: MTCTheme.safeGreen, shape: BoxShape.circle),
            child: const Icon(Icons.call, color: Colors.white, size: 36),
          ),
        ),
        GestureDetector(
          onTap: _removeDigit,
          child: Container(
            width: 70,
            height: 70,
            child: const Icon(Icons.backspace_outlined, color: Colors.grey, size: 24),
          ),
        ),
      ],
    );
  }
}
