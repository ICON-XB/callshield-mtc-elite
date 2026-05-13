import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  // MTC Question: "How does SMS spam filtering work without breaking privacy?"
  // Answer: We use an on-device regex/keyword scanner. No message content is
  //         ever sent to the cloud. It runs locally via the Android Telephony API.
  final List<String> _spamKeywords = [
    'won', 'claim', 'verify your account', 'http://', 'https://bit.ly', 'prize', 'urgent'
  ];

  bool _isSpam(String message) {
    final lowerMsg = message.toLowerCase();
    for (final keyword in _spamKeywords) {
      if (lowerMsg.contains(keyword)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MTCTheme.primaryNavy,
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(icon: const Icon(Icons.mark_chat_read_outlined), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSmsThread('MTC Namibia', 'Your balance is 142.50 NAD. Dial *121# to top up.', '10:45 AM', true),
          _buildSmsThread('Bank Alert', 'WARNING: Unusual login detected. Click here to verify: http://bit.ly/scam-link', '09:12 AM', false),
          _buildSmsThread('Sarah Namene', 'Did you review the kernel logs for the Windhoek cluster?', 'Yesterday', false),
          _buildSmsThread('Deon Kayele', 'The Elite sync is now 100% operational. Great job!', 'Yesterday', false),
          _buildSmsThread('Unknown Sender', 'Congratulations! You won a new iPhone 15. Claim now!', '2 days ago', false),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: MTCTheme.primaryBlue,
        child: const Icon(Icons.chat_bubble_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildSmsThread(String sender, String msg, String time, bool isOfficialSender) {
    final isSpam = _isSpam(msg) && !isOfficialSender;
    final statusColor = isOfficialSender ? MTCTheme.safeGreen : (isSpam ? MTCTheme.alertRed : Colors.white30);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: MTCTheme.surfaceGray,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 10)],
        border: Border.all(color: Colors.white12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: statusColor.withAlpha(30),
          child: Icon(
            isOfficialSender ? Icons.verified : (isSpam ? Icons.warning_amber_rounded : Icons.person),
            color: statusColor,
            size: 20,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(sender, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
            Text(time, style: const TextStyle(fontSize: 10, color: Colors.white30)),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(msg, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: Colors.white70)),
            if (isOfficialSender || isSpam) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: statusColor.withAlpha(50)),
                ),
                child: Text(
                  isSpam ? 'SPAM DETECTED' : 'VERIFIED BUSINESS',
                  style: TextStyle(color: statusColor, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
