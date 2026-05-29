import 'package:flutter/foundation.dart';

/// Detects SIM spoofing, VoIP calls, and masked numbers
class SpoofDetectionService {
  /// Detects potential SIM spoofing attempts
  static bool isSpoofedNumber(String phoneNumber, String reportedCarrier) {
    final carrier = _getCarrier(phoneNumber);

    // Mismatch between prefix and reported carrier = potential spoof
    if (carrier != reportedCarrier && reportedCarrier != 'Unknown Network') {
      debugPrint(
          '⚠️ SPOOF DETECTED: Prefix suggests $carrier but reported as $reportedCarrier');
      return true;
    }

    return false;
  }

  /// Detects private/masked numbers
  static bool isPrivateNumber(String phoneNumber) {
    final patterns = [
      RegExp(r'^(\*|#|00)'),
      RegExp(r'(private|masked|withheld|restricted)', caseSensitive: false),
      RegExp(r'^\*\d{1,3}#'), // Hidden numbers
    ];

    return patterns.any((p) => p.hasMatch(phoneNumber));
  }

  /// Detects likely VoIP calls
  static bool isLikelyVoIP(String phoneNumber) {
    final voipPatterns = [
      RegExp(
          r'^\+?1(201|203|206|212|213|215|301|302|303|305|307|310|312|314|323|330|334|336|347|360|404|408|412|415|423|424|503|504|510|512|513|515|517|541|602|603|605|606|609|610|612|614|615|617|619|623|626|630|650|702|703|704|706|707|708|712|713|714|719|720|727|734|760|770|773|775|781|785|801|802|803|805|806|810|812|813|815|816|817|818|828|830|831|832|843|845|847|848|850|857|858|860|862|864|865|870|901|903|904|906|907|908|909|910|912|913|914|915|916|917|918|919|920|925|928|931|936|940|941|945|949|951|952|954|956|970|971|972|973|975|978|979|980|985|986|201|202|203|205|206|207|208|209|210|212|213|214|215|216|217|218|219|220|223|224|225|226|227|228|229|230|231|232|233|234|235|236|237|238|239|240|242|243|244|245|246|248|249|250|251|252|253|254|255|256|257|258|259|260|261|262|263|264|265|266|267|268|269|270|271|272|274|275|276|278|279|280|281|282|283|284|285|286|287|288|289|290|291|292|293|294|295|296|297|298|299|300|301|302|303|304|305|306|307|308|309|310|311|312|313|314|315|316|317|318|319|320|321|322|323|324|325|326|327|328|329|330|331|332|333|334|335|336|337|338|339|340|341|342|343|344|345|346|347|348|349|350)',
          caseSensitive: false),
      RegExp(r'\b(skype|hangouts|whatsapp|viber|telegram)\b',
          caseSensitive: false),
    ];

    return voipPatterns.any((p) => p.hasMatch(phoneNumber));
  }

  static String _getCarrier(String phoneNumber) {
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    const carriers = {
      '081': 'MTC',
      '084': 'MTC',
      '088': 'MTC',
      '082': 'Telecom Namibia',
      '086': 'Telecom Namibia',
      '083': 'TN Mobile',
      '085': 'Paratus',
      '087': 'Paratus',
    };

    if (cleaned.length >= 3) {
      return carriers[cleaned.substring(0, 3)] ?? 'Unknown';
    }

    return 'Unknown';
  }
}
