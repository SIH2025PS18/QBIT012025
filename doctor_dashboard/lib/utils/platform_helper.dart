import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class PlatformHelper {
  static bool get isWeb => kIsWeb;
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  static bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

  static bool get supportsAgora => !kIsWeb; // Agora has issues on web
}
