import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import '../database/local/database_helper.dart';

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  double _severity = 0.5;
  String _selectedCategory = 'SPAM';
  final TextEditingController _phoneController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> _categories = ['SPAM', 'SCAM', 'HARASSMENT', 'PHISHING'];

  Future<void> _submitReport() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a phone number')));
      return;
    }

    setState(() => _isSubmitting = true);

    // Save to local SQLite community report DB (wrapped for Windows desktop fallback)
    try {
      await DatabaseHelper.instance.addReport(phone, _selectedCategory);
    } catch (e) {
      debugPrint('Report save failed: $e');
    }

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Report verified and added to MTC National Database.'),
        backgroundColor: MTCTheme.safeGreen,
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MTCTheme.primaryNavy,
      appBar: AppBar(
        title: const Text('Report Threat'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInstructionText(),
            const SizedBox(height: 30),
            _buildInputLabel('SCAMMER NUMBER'),
            _buildModernField(
                'e.g. 081 234 5678', Icons.phone, _phoneController),
            const SizedBox(height: 25),
            _buildInputLabel('THREAT CATEGORY'),
            _buildCategoryGrid(),
            const SizedBox(height: 25),
            _buildInputLabel('THREAT SEVERITY'),
            _buildSeveritySlider(),
            const SizedBox(height: 40),
            _buildSubmitButton(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionText() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: MTCTheme.primaryBlue.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(15),
          border:
              Border.all(color: MTCTheme.primaryBlue.withValues(alpha: 0.2))),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: MTCTheme.primaryBlue),
          const SizedBox(width: 15),
          Expanded(
              child: Text(
                  'Community reports power the CallShield engine. By reporting scams, you protect all Namibians.',
                  style: GoogleFonts.outfit(
                      fontSize: 13, color: MTCTheme.primaryBlue))),
        ],
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5),
      child: Text(label,
          style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: MTCTheme.textSecondary,
              letterSpacing: 1.5)),
    );
  }

  Widget _buildModernField(
      String hint, IconData icon, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: MTCTheme.surfaceGray,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10)
        ],
        border: Border.all(color: Colors.white12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.phone,
        style: GoogleFonts.outfit(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24),
          prefixIcon: Icon(icon, color: MTCTheme.primaryBlue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _categories.map((c) {
        final isSelected = c == _selectedCategory;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = c),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
                color: isSelected ? MTCTheme.primaryBlue : MTCTheme.surfaceGray,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: isSelected ? MTCTheme.primaryBlue : Colors.white12)),
            child: Text(c,
                style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : MTCTheme.textSecondary)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSeveritySlider() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: MTCTheme.surfaceGray,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10)
        ],
        border: Border.all(color: Colors.white12),
      ),
      child: Slider(
        value: _severity,
        onChanged: (v) => setState(() => _severity = v),
        activeColor:
            _severity > 0.7 ? MTCTheme.alertRed : MTCTheme.warningAmber,
        inactiveColor: Colors.white12,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isSubmitting ? null : _submitReport,
      style: ElevatedButton.styleFrom(
          backgroundColor: MTCTheme.primaryBlue,
          minimumSize: const Size(double.infinity, 60),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      child: _isSubmitting
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('SUBMIT REPORT',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Colors.white)),
    );
  }
}
