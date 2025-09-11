import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/call_recording.dart';
import '../services/connectivity_service.dart';
import '../config/api_config.dart';

/// Service for managing call recordings
class CallRecordingService extends ChangeNotifier {
  static final CallRecordingService _instance =
      CallRecordingService._internal();
  factory CallRecordingService() => _instance;
  CallRecordingService._internal();

  final ConnectivityService _connectivityService = ConnectivityService();
  final Uuid _uuid = const Uuid();

  // Backend API configuration
  static const String _baseUrl = 'http://localhost:5001/api';

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    // Add auth token if available
  };

  // Current recording state
  CallRecording? _currentRecording;
  List<CallRecording> _recordingHistory = [];
  DateTime? _recordingStartTime;
  bool _isRecording = false;

  // Getters
  CallRecording? get currentRecording => _currentRecording;
  List<CallRecording> get recordingHistory =>
      List.unmodifiable(_recordingHistory);
  DateTime? get recordingStartTime => _recordingStartTime;
  bool get isRecording => _isRecording;

  /// Start recording a consultation
  Future<String?> startRecording({
    required String consultationId,
    required String patientId,
    required String doctorId,
    bool requiresConsent = true,
  }) async {
    try {
      if (_isRecording) {
        throw Exception('A recording is already in progress');
      }

      final recordingId = _uuid.v4();
      final now = DateTime.now();

      // Create recording record
      final recording = CallRecording(
        id: recordingId,
        consultationId: consultationId,
        doctorId: doctorId,
        patientId: patientId,
        startedAt: now,
        status: RecordingStatus.recording,
        requiresConsent: requiresConsent,
        createdAt: now,
      );

      // Save to backend if connected
      if (_connectivityService.isConnected) {
        final response = await http.post(
          Uri.parse('$_baseUrl/recordings'),
          headers: _headers,
          body: jsonEncode(recording.toJson()),
        );

        if (response.statusCode != 200 && response.statusCode != 201) {
          throw Exception('Failed to start recording: ${response.body}');
        }
      }

      // Update local state
      _currentRecording = recording;
      _recordingStartTime = now;
      _isRecording = true;
      notifyListeners();

      debugPrint('Recording started: $recordingId');
      return recordingId;
    } catch (e) {
      debugPrint('Error starting recording: $e');
      return null;
    }
  }

  /// Stop current recording
  Future<bool> stopRecording() async {
    try {
      if (!_isRecording || _currentRecording == null) {
        debugPrint('No active recording to stop');
        return false;
      }

      final now = DateTime.now();
      final duration = _recordingStartTime != null
          ? now.difference(_recordingStartTime!)
          : null;

      // Update recording status
      final updatedRecording = _currentRecording!.copyWith(
        endedAt: now,
        status: RecordingStatus.completed,
        durationSeconds: duration?.inSeconds,
      );

      // Save to backend if connected
      if (_connectivityService.isConnected) {
        final response = await http.put(
          Uri.parse('$_baseUrl/recordings/${_currentRecording!.id}'),
          headers: _headers,
          body: jsonEncode(updatedRecording.toJson()),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to update recording: ${response.body}');
        }
      }

      // Update local state
      _recordingHistory.insert(0, updatedRecording);
      _currentRecording = null;
      _recordingStartTime = null;
      _isRecording = false;
      notifyListeners();

      debugPrint('Recording stopped: ${updatedRecording.id}');
      return true;
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      return false;
    }
  }

  /// Cancel current recording
  Future<bool> cancelRecording() async {
    try {
      if (!_isRecording || _currentRecording == null) {
        debugPrint('No active recording to cancel');
        return false;
      }

      final now = DateTime.now();

      // Update recording status
      final updatedRecording = _currentRecording!.copyWith(
        endedAt: now,
        status: RecordingStatus.cancelled,
      );

      // Save to backend if connected
      if (_connectivityService.isConnected) {
        final response = await http.put(
          Uri.parse('$_baseUrl/recordings/${_currentRecording!.id}'),
          headers: _headers,
          body: jsonEncode(updatedRecording.toJson()),
        );

        if (response.statusCode != 200) {
          debugPrint('Failed to update recording on server');
        }
      }

      // Update local state
      _currentRecording = null;
      _recordingStartTime = null;
      _isRecording = false;
      notifyListeners();

      debugPrint('Recording cancelled: ${updatedRecording.id}');
      return true;
    } catch (e) {
      debugPrint('Error cancelling recording: $e');
      return false;
    }
  }

  /// Update patient consent for recording
  Future<bool> updatePatientConsent({
    required String recordingId,
    required bool consent,
  }) async {
    try {
      // Update current recording if it matches
      if (_currentRecording?.id == recordingId) {
        _currentRecording = _currentRecording!.copyWith(
          patientConsent: consent,
        );
        notifyListeners();
      }

      // Save to backend if connected
      if (_connectivityService.isConnected) {
        final response = await http.patch(
          Uri.parse('$_baseUrl/recordings/$recordingId/consent'),
          headers: _headers,
          body: jsonEncode({'patientConsent': consent}),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to update consent: ${response.body}');
        }
      }

      debugPrint(
        'Patient consent updated for recording: $recordingId, consent: $consent',
      );
      return true;
    } catch (e) {
      debugPrint('Error updating patient consent: $e');
      return false;
    }
  }

  /// Get recording by ID
  Future<CallRecording?> getRecording(String recordingId) async {
    try {
      // Check current recording first
      if (_currentRecording?.id == recordingId) {
        return _currentRecording;
      }

      // Check history
      final historyRecording = _recordingHistory
          .where((r) => r.id == recordingId)
          .firstOrNull;
      if (historyRecording != null) {
        return historyRecording;
      }

      // Fetch from backend if connected
      if (_connectivityService.isConnected) {
        final response = await http.get(
          Uri.parse('$_baseUrl/recordings/$recordingId'),
          headers: _headers,
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return CallRecording.fromJson(data);
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error getting recording: $e');
      return null;
    }
  }

  /// Get recordings for a consultation
  Future<List<CallRecording>> getConsultationRecordings(
    String consultationId,
  ) async {
    try {
      if (!_connectivityService.isConnected) {
        // Return local data when offline
        return _recordingHistory
            .where((r) => r.consultationId == consultationId)
            .toList();
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/recordings/consultation/$consultationId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['recordings'] as List)
            .map<CallRecording>((json) => CallRecording.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error getting consultation recordings: $e');
      return [];
    }
  }

  /// Get recordings for a user (doctor or patient)
  Future<List<CallRecording>> getUserRecordings(String userId) async {
    try {
      if (!_connectivityService.isConnected) {
        // Return local data when offline
        return _recordingHistory
            .where((r) => r.doctorId == userId || r.patientId == userId)
            .toList();
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/recordings/user/$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['recordings'] as List)
            .map<CallRecording>((json) => CallRecording.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('Error getting user recordings: $e');
      return [];
    }
  }

  /// Delete a recording
  Future<bool> deleteRecording(String recordingId) async {
    try {
      // Remove from local state
      _recordingHistory.removeWhere((r) => r.id == recordingId);

      // Cancel if it's the current recording
      if (_currentRecording?.id == recordingId) {
        await cancelRecording();
      }

      // Delete from backend if connected
      if (_connectivityService.isConnected) {
        final response = await http.delete(
          Uri.parse('$_baseUrl/recordings/$recordingId'),
          headers: _headers,
        );

        if (response.statusCode != 200 && response.statusCode != 204) {
          throw Exception('Failed to delete recording: ${response.body}');
        }
      }

      notifyListeners();
      debugPrint('Recording deleted: $recordingId');
      return true;
    } catch (e) {
      debugPrint('Error deleting recording: $e');
      return false;
    }
  }

  /// Get recording file path for playback
  Future<String?> getRecordingFilePath(String recordingId) async {
    try {
      final recording = await getRecording(recordingId);
      if (recording?.filePath != null) {
        // Check if file exists locally
        final file = File(recording!.filePath!);
        if (await file.exists()) {
          return recording.filePath;
        }
      }

      // Download from backend if not available locally
      if (_connectivityService.isConnected) {
        final response = await http.get(
          Uri.parse('$_baseUrl/recordings/$recordingId/download'),
          headers: _headers,
        );

        if (response.statusCode == 200) {
          // Save file locally
          final documentsDir = await getApplicationDocumentsDirectory();
          final recordingsDir = Directory('${documentsDir.path}/recordings');
          if (!await recordingsDir.exists()) {
            await recordingsDir.create(recursive: true);
          }

          final filePath = '${recordingsDir.path}/$recordingId.mp4';
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          return filePath;
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error getting recording file path: $e');
      return null;
    }
  }

  /// Get current recording duration
  Duration getCurrentRecordingDuration() {
    if (!_isRecording || _recordingStartTime == null) {
      return Duration.zero;
    }

    return DateTime.now().difference(_recordingStartTime!);
  }

  /// Check if consent is required for current recording
  bool get requiresConsent => _currentRecording?.requiresConsent ?? false;

  /// Check if patient has given consent
  bool get hasPatientConsent => _currentRecording?.patientConsent ?? false;

  /// Load recording history
  Future<void> loadRecordingHistory() async {
    try {
      // This would typically load from local database or backend
      // For now, we'll keep the current in-memory state
      debugPrint(
        'Recording history loaded: ${_recordingHistory.length} recordings',
      );
    } catch (e) {
      debugPrint('Error loading recording history: $e');
    }
  }

  /// Clear all local recording data
  void clearLocalData() {
    _currentRecording = null;
    _recordingHistory.clear();
    _recordingStartTime = null;
    _isRecording = false;
    notifyListeners();
    debugPrint('Local recording data cleared');
  }
}
