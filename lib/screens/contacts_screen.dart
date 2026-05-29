import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MTCTheme.primaryNavy,
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(icon: const Icon(Icons.person_add_alt_1_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildMyProfile(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionHeader('MY VERIFIED CIRCLE'),
                _contactItem('Sarah Namene', 'Security Specialist', MTCTheme.safeGreen),
                _contactItem('John Booysen', 'Elite Admin', MTCTheme.safeGreen),
                _contactItem('MTC Support', 'Official Service', MTCTheme.primaryBlue),
                const SizedBox(height: 20),
                _buildSectionHeader('ALL CONTACTS'),
                _contactItem('Alice Johnson', 'Mobile', Colors.white30),
                _contactItem('Bob Miller', 'Work', Colors.white30),
                _contactItem('Charlie Davis', 'Home', Colors.white30),
                _contactItem('David Wilson', 'Mobile', Colors.white30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyProfile() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: MTCTheme.surfaceGray,
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1519085185758-2ed980ba33b0?w=400'),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Deon Kayele', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                const Text('Elite System Architect', style: TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.qr_code_2_rounded, color: MTCTheme.primaryBlue),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(title, style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: MTCTheme.textSecondary, letterSpacing: 1.5)),
    );
  }

  Widget _contactItem(String name, String sub, Color badgeColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: MTCTheme.surfaceGray,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: MTCTheme.primaryNavy,
          child: Text(name[0], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        title: Text(name, style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.white)),
        subtitle: Text(sub, style: const TextStyle(fontSize: 12, color: Colors.white54)),
        trailing: Icon(Icons.verified_rounded, color: badgeColor, size: 18),
      ),
    );
  }
}
