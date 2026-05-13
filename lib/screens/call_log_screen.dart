import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

import '../widgets/dial_pad.dart';

class CallLogScreen extends StatelessWidget {
  const CallLogScreen({Key? key}) : super(key: key);

  void _openDialer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DialPadOverlay(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MTCTheme.primaryNavy,
      appBar: AppBar(
        title: const Text('Calls'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDialer(context),
        backgroundColor: MTCTheme.primaryBlue,
        child: const Icon(Icons.dialpad_rounded, color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildCallItem('Deon Kayele', '081 476 2464', '2 mins ago', Icons.call_made, MTCTheme.safeGreen, isSafe: true),
          _buildCallItem('MTC Support', '081 949', '1 hour ago', Icons.call_received, MTCTheme.safeGreen, isSafe: true),
          _buildCallItem('Potential Spam', '081 772 1029', '3 hours ago', Icons.call_received, MTCTheme.alertRed, isSafe: false),
          _buildCallItem('Unknown', '081 223 4455', 'Yesterday', Icons.call_missed, Colors.orange, isSafe: false),
          _buildCallItem('Sarah Namene', '081 123 4567', 'Yesterday', Icons.call_made, MTCTheme.safeGreen, isSafe: true),
          _buildCallItem('John Booysen', '081 772 1029', '2 days ago', Icons.call_received, MTCTheme.safeGreen, isSafe: true),
        ],
      ),
    );
  }

  Widget _buildCallItem(String name, String number, String time, IconData direction, Color statusColor, {bool isSafe = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: MTCTheme.surfaceGray,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: MTCTheme.primaryNavy,
              radius: 25,
              child: Text(name[0], style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(color: MTCTheme.surfaceGray, shape: BoxShape.circle),
                child: Icon(isSafe ? Icons.verified : Icons.warning_rounded, color: statusColor, size: 14),
              ),
            ),
          ],
        ),
        title: Text(name, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        subtitle: Row(
          children: [
            Icon(direction, size: 12, color: Colors.white30),
            const SizedBox(width: 4),
            Text(time, style: const TextStyle(fontSize: 12, color: Colors.white54)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.info_outline_rounded, color: Colors.white30),
          onPressed: () {},
        ),
      ),
    );
  }
}
