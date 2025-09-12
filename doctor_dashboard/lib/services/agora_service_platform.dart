// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/foundation.dart';

// Conditional imports for different platforms
import '../services/agora_service_stub.dart'
    if (dart.library.io) '../services/agora_service.dart'
    if (dart.library.html) '../services/agora_service_web.dart';

export '../services/agora_service_stub.dart'
    if (dart.library.io) '../services/agora_service.dart'
    if (dart.library.html) '../services/agora_service_web.dart';
