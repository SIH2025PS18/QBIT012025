import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Service to monitor network connectivity status
class ConnectivityService extends ChangeNotifier {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  bool _isConnected = false;
  bool _isWifiConnected = false;
  bool _isMobileConnected = false;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];

  /// Whether device is connected to internet
  bool get isConnected => _isConnected;

  /// Whether device is connected via WiFi
  bool get isWifiConnected => _isWifiConnected;

  /// Whether device is connected via mobile data
  bool get isMobileConnected => _isMobileConnected;

  /// Current connection status
  List<ConnectivityResult> get connectionStatus => _connectionStatus;

  /// Whether device has a strong connection (WiFi or good mobile signal)
  bool get hasStrongConnection => _isWifiConnected;

  /// Whether device has limited connection (mobile data only)
  bool get hasLimitedConnection => _isMobileConnected && !_isWifiConnected;

  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    try {
      // Get initial connectivity status
      _connectionStatus = await _connectivity.checkConnectivity();
      _updateConnectionStatus(_connectionStatus);

      // Listen for connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _updateConnectionStatus,
        onError: (error) {
          debugPrint('Connectivity monitoring error: $error');
        },
      );

      debugPrint('ConnectivityService initialized. Status: $_connectionStatus');
    } catch (e) {
      debugPrint('Failed to initialize ConnectivityService: $e');
      // Set default offline state
      _updateConnectionStatus([ConnectivityResult.none]);
    }
  }

  /// Update connection status and notify listeners
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    _connectionStatus = results;

    // Check for different connection types
    _isWifiConnected = results.contains(ConnectivityResult.wifi);
    _isMobileConnected = results.contains(ConnectivityResult.mobile);
    _isConnected = _isWifiConnected || _isMobileConnected;

    // Log connection changes
    debugPrint('Connectivity changed: $_connectionStatus');
    debugPrint(
      'Connected: $_isConnected, WiFi: $_isWifiConnected, Mobile: $_isMobileConnected',
    );

    // Notify listeners about connectivity changes
    notifyListeners();
  }

  /// Check if device can sync large data (photos, documents)
  bool get canSyncLargeData => _isWifiConnected;

  /// Check if device can sync basic data (text, small updates)
  bool get canSyncBasicData => _isConnected;

  /// Get connection type description
  String get connectionTypeDescription {
    if (_isWifiConnected && _isMobileConnected) {
      return 'WiFi + Mobile';
    } else if (_isWifiConnected) {
      return 'WiFi';
    } else if (_isMobileConnected) {
      return 'Mobile Data';
    } else {
      return 'Offline';
    }
  }

  /// Wait for internet connection with timeout
  Future<bool> waitForConnection({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (_isConnected) return true;

    final completer = Completer<bool>();
    StreamSubscription? subscription;

    // Set up timeout
    final timer = Timer(timeout, () {
      subscription?.cancel();
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    });

    // Listen for connection
    subscription = _connectivity.onConnectivityChanged.listen((results) {
      final hasConnection =
          results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.mobile);

      if (hasConnection) {
        timer.cancel();
        subscription?.cancel();
        if (!completer.isCompleted) {
          completer.complete(true);
        }
      }
    });

    return completer.future;
  }

  /// Dispose of resources
  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}

/// Extension to get connection quality
extension ConnectivityQuality on ConnectivityService {
  /// Get connection quality enum
  ConnectionQuality get connectionQuality {
    if (!isConnected) return ConnectionQuality.none;
    if (isWifiConnected) return ConnectionQuality.excellent;
    if (isMobileConnected) return ConnectionQuality.good;
    return ConnectionQuality.poor;
  }
}

/// Enum for connection quality
enum ConnectionQuality {
  none, // No connection
  poor, // Very slow connection
  good, // Mobile data connection
  excellent, // WiFi connection
}

/// Extension methods for ConnectionQuality
extension ConnectionQualityExtension on ConnectionQuality {
  /// Get display name for connection quality
  String get displayName {
    switch (this) {
      case ConnectionQuality.none:
        return 'No Connection';
      case ConnectionQuality.poor:
        return 'Poor Connection';
      case ConnectionQuality.good:
        return 'Good Connection';
      case ConnectionQuality.excellent:
        return 'Excellent Connection';
    }
  }

  /// Get icon name for connection quality
  String get iconName {
    switch (this) {
      case ConnectionQuality.none:
        return 'wifi_off';
      case ConnectionQuality.poor:
        return 'signal_cellular_1_bar';
      case ConnectionQuality.good:
        return 'signal_cellular_4_bar';
      case ConnectionQuality.excellent:
        return 'wifi';
    }
  }

  /// Whether this quality can handle large file uploads
  bool get canHandleLargeFiles {
    return this == ConnectionQuality.excellent;
  }

  /// Whether this quality can handle basic sync operations
  bool get canHandleBasicSync {
    return this != ConnectionQuality.none;
  }
}
