import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import '../models/lookup_result.dart';
import '../providers/lookup_provider.dart';

class SimulationScreen extends ConsumerStatefulWidget {
  const SimulationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends ConsumerState<SimulationScreen> {
  final TextEditingController _testPhone = TextEditingController(text: '0817721029');

  @override
  Widget build(BuildContext context) {
    final currentCallState = ref.watch(currentCallProvider);

    return Scaffold(
      backgroundColor: MTCTheme.primaryNavy,
      appBar: AppBar(
        title: Text('Test Shield', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: MTCTheme.primaryNavy,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 30),
            Text('SIMULATE THREATS', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: MTCTheme.textSecondary, letterSpacing: 1.5)),
            const SizedBox(height: 15),
            _buildTestInput(),
            const SizedBox(height: 20),
            _buildActionButtons(),
            const SizedBox(height: 30),
            if (currentCallState.value != null) _buildActiveSimulation(currentCallState.value!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MTCTheme.surfaceGray,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 20)],
      ),
      child: Column(
        children: [
          const Icon(Icons.bolt, color: MTCTheme.accentTeal, size: 40),
          const SizedBox(height: 15),
          Text('Lab Mode', style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Text('Use this screen to test how CallShield handles incoming signals before deploying to the kernel.', 
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTestInput() {
    return Container(
      decoration: BoxDecoration(color: MTCTheme.surfaceGray, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white12)),
      child: TextField(
        controller: _testPhone,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Enter number to test...',
          hintStyle: const TextStyle(color: Colors.white30),
          prefixIcon: const Icon(Icons.phone_android, color: MTCTheme.primaryBlue),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          filled: true,
          fillColor: MTCTheme.surfaceGray,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _simButton('Test Call', Icons.call, Colors.green, () {
            ref.read(currentCallProvider.notifier).simulateIncomingCall(_testPhone.text);
          }),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _simButton('Test SMS', Icons.message, Colors.orange, () {
            // SMS simulation logic
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Simulating SMS Threat Detection...'))
            );
          }),
        ),
      ],
    );
  }

  Widget _simButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: MTCTheme.surfaceGray,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 10),
            Text(label, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveSimulation(LookupResult res) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('LIVE DETECTION', style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: MTCTheme.textSecondary, letterSpacing: 1.5)),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: res.riskLevel.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: res.riskLevel.color.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(res.riskLevel.icon, color: res.riskLevel.color, size: 40),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(res.riskLevel.displayName, style: TextStyle(color: res.riskLevel.color, fontWeight: FontWeight.bold)),
                    Text('Detected ${res.phoneNumber} on ${res.network} network.', style: const TextStyle(fontSize: 12, color: Colors.white54)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => ref.read(currentCallProvider.notifier).simulateIncomingCall(''),
                style: ElevatedButton.styleFrom(backgroundColor: res.riskLevel.color, shape: const CircleBorder()),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
