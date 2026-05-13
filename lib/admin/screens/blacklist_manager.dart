import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class BlacklistManager extends StatefulWidget {
  const BlacklistManager({super.key});

  @override
  State<BlacklistManager> createState() => _BlacklistManagerState();
}

class _BlacklistManagerState extends State<BlacklistManager> {
  final List<Map<String, String>> _blacklist = [
    {'phone': '0800 666 666', 'reason': 'Verified Scam Bot', 'added': '2026-05-01'},
    {'phone': '081 554 3210', 'reason': 'Identity Theft Attempt', 'added': '2026-04-30'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070A),
      body: Row(
        children: [
          _buildSidebar(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildAddForm(),
                  const SizedBox(height: 40),
                  _buildBlacklistTable(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
     return Container(
      width: 280,
      color: MTCTheme.primaryNavy,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CALLSHIELD', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: MTCTheme.mtcBlue, letterSpacing: 2)),
          const Text('ADMIN CONSOLE', style: TextStyle(fontSize: 10, color: Colors.white24, letterSpacing: 1)),
          const SizedBox(height: 60),
          _sidebarItem(Icons.dashboard, 'Overview', onTap: () => Navigator.pop(context)),
          _sidebarItem(Icons.gpp_maybe, 'Blacklist Manager', isActive: true),
          _sidebarItem(Icons.people, 'User Intelligence'),
          _sidebarItem(Icons.hub, 'Network Nodes'),
          const Spacer(),
          _sidebarItem(Icons.logout, 'Sign Out'),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String label, {bool isActive = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: isActive ? MTCTheme.mtcBlue.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: isActive ? MTCTheme.mtcBlue : Colors.white24, size: 20),
            const SizedBox(width: 20),
            Text(label, style: TextStyle(color: isActive ? Colors.white : Colors.white24, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Global Blacklist Manager', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        Text('Add or remove numbers from the network-wide shield', style: TextStyle(color: Colors.white24)),
      ],
    );
  }

  Widget _buildAddForm() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(color: MTCTheme.primaryNavy, borderRadius: BorderRadius.circular(25)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter Phone Number...',
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: MTCTheme.alertRed, minimumSize: const Size(200, 60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
            child: const Text('ADD TO GLOBAL SHIELD'),
          ),
        ],
      ),
    );
  }

  Widget _buildBlacklistTable() {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: MTCTheme.primaryNavy, borderRadius: BorderRadius.circular(25)),
        child: SingleChildScrollView(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('NUMBER')),
              DataColumn(label: Text('REASON')),
              DataColumn(label: Text('DATE ADDED')),
              DataColumn(label: Text('STATUS')),
            ],
            rows: _blacklist.map((item) => DataRow(cells: [
              DataCell(Text(item['phone']!)),
              DataCell(Text(item['reason']!)),
              DataCell(Text(item['added']!)),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: MTCTheme.safeGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(5)),
                  child: const Text('ACTIVE', style: TextStyle(color: MTCTheme.safeGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            ])).toList(),
          ),
        ),
      ),
    );
  }
}
