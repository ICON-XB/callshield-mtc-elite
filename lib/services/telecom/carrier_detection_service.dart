/// Multi-carrier detection service for Namibian telecom operators
/// Supports: MTC, Telecom Namibia, Paratus, and international detection
class CarrierDetectionService {
  static const Map<String, String> prefixRegistry = {
    // MTC Namibia
    '081': 'MTC',
    '084': 'MTC',
    '088': 'MTC',

    // Telecom Namibia
    '082': 'Telecom Namibia',
    '086': 'Telecom Namibia',
    '083': 'TN Mobile',

    // Paratus Telecom
    '085': 'Paratus Telecom',
    '087': 'Paratus Telecom',

    // Landlines
    '061': 'Windhoek Landline',
    '064': 'Coastal Landline',
    '065': 'Northern Landline',
    '066': 'Kavango Landline',
    '067': 'Otjozondjupa Landline',
  };

  /// Detects carrier from phone number
  static String detectCarrier(String phoneNumber) {
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');

    // Handle international numbers
    if (cleaned.startsWith('+264')) {
      return detectCarrier(cleaned.substring(3)); // Remove +264
    }

    if (cleaned.startsWith('00264')) {
      return detectCarrier(cleaned.substring(5)); // Remove 00264
    }

    // Check first 3 digits
    if (cleaned.length >= 3) {
      final prefix3 = cleaned.substring(0, 3);
      if (prefixRegistry.containsKey(prefix3)) {
        return prefixRegistry[prefix3]!;
      }
    }

    // Check first 2 digits
    if (cleaned.length >= 2) {
      final prefix2 = cleaned.substring(0, 2);
      if (prefixRegistry.containsKey(prefix2)) {
        return prefixRegistry[prefix2]!;
      }
    }

    // International detection
    if (cleaned.startsWith('+') || cleaned.startsWith('00')) {
      return 'International';
    }

    return 'Unknown Network';
  }

  /// Validates if number is valid Namibian format
  static bool isValidNamibianNumber(String phoneNumber) {
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');

    // Local format: 081234567 (9 digits)
    if (!cleaned.startsWith('+') && cleaned.length == 9) {
      return prefixRegistry.containsKey(cleaned.substring(0, 3));
    }

    // International format: +264812345678
    if (cleaned.startsWith('+264') && cleaned.length == 13) {
      final localPart = cleaned.substring(4); // Remove +264
      return prefixRegistry.containsKey(localPart.substring(0, 2));
    }

    return false;
  }

  /// Normalizes phone number to standard format
  static String normalizeNumber(String phoneNumber) {
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');

    if (cleaned.startsWith('00264')) {
      return '+264${cleaned.substring(5)}';
    }

    if (cleaned.startsWith('264')) {
      return '+$cleaned';
    }

    if (cleaned.startsWith('+264')) {
      return cleaned;
    }

    if (cleaned.length == 9 && !cleaned.startsWith('0')) {
      return '+264$cleaned';
    }

    if (cleaned.length == 9) {
      return '+264${cleaned.substring(1)}';
    }

    return cleaned;
  }
}
