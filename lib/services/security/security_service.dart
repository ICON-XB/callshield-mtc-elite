import '../../models/caller/lookup_result.dart';

/// Security and encryption utilities
class SecurityService {
  /// Hashes a phone number for storage (prevents plaintext storage)
  static String hashPhoneNumber(String phoneNumber) {
    // Simple hash (in production, use crypto package)
    return phoneNumber
        .split('')
        .fold(0, (acc, char) => acc + char.codeUnitAt(0))
        .toString();
  }

  /// Masks phone number for display (e.g., 081234567 -> 081****67)
  static String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length < 6) return phoneNumber;

    final start = phoneNumber.substring(0, 3);
    final end = phoneNumber.substring(phoneNumber.length - 2);
    final masked = '*' * (phoneNumber.length - 5);

    return '$start$masked$end';
  }

  /// Validates phone number format
  static bool isValidPhoneFormat(String phoneNumber) {
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');

    // Must be between 9-15 digits
    if (cleaned.length < 9 || cleaned.length > 15) {
      return false;
    }

    // Cannot be all same digits
    if (cleaned.split('').toSet().length == 1) {
      return false;
    }

    return true;
  }

  /// Encrypts sensitive lookup result data
  static String encryptLookupData(LookupResult result) {
    // In production: use crypto package
    // This is a placeholder
    return 'encrypted_${result.phoneNumber}_${result.name}';
  }

  /// Decrypts lookup result data
  static String decryptLookupData(String encrypted) {
    // In production: use crypto package
    return encrypted.replaceFirst('encrypted_', '');
  }

  /// Checks if data access is authorized
  static bool isAccessAuthorized(String userId, String permission) {
    // Placeholder for access control
    return true;
  }
}
