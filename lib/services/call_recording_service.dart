import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../models/call_recording.dart';

/// Service for managing call recordings
class CallRecordingService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Uuid _uuid = const Uuid();

  bool _isRecording = false;
  String? _currentRecordingId;
  DateTime? _recordingStartTime;
  List<CallRecording> _recordings = [];

  // Getters
  bool get isRecording => _isRecording;
  String? get currentRecordingId => _currentRecordingId;
  DateTime? get recordingStartTime => _recordingStartTime;
  List<CallRecording> get recordings => List.unmodifiable(_recordings);

  /// Start recording a consultation
  Future<String?> startRecording({
    required String consultationId,
    required String doctorId,
    required String patientId,
    bool requiresConsent = true,
  }) async {
    try {
      if (_isRecording) {
        throw Exception('Recording already in progress');
      }

      final recordingId = _uuid.v4();
      final now = DateTime.now();

      // Create recording record in database
      final recordingData = {
        'id': recordingId,
        'consultation_id': consultationId,
        'doctor_id': doctorId,
        'patient_id': patientId,
        'started_at': now.toIso8601String(),
        'status': 'recording',
        'requires_consent': requiresConsent,
        'file_path': null,
        'file_size': null,
        'duration_seconds': null,
        'created_at': now.toIso8601String(),
      };

      await _supabase.from('call_recordings').insert(recordingData);

      _isRecording = true;
      _currentRecordingId = recordingId;
      _recordingStartTime = now;

      notifyListeners();

      debugPrint('Call recording started: $recordingId');
      return recordingId;
    } catch (e) {
      debugPrint('Failed to start recording: $e');
      return null;
    }
  }

  /// Stop recording
  Future<bool> stopRecording() async {
    try {
      if (!_isRecording || _currentRecordingId == null) {
        throw Exception('No recording in progress');
      }

      final endTime = DateTime.now();
      final duration = endTime.difference(_recordingStartTime!);

      // Update recording record
      await _supabase
          .from('call_recordings')
          .update({
            'ended_at': endTime.toIso8601String(),
            'status': 'completed',
            'duration_seconds': duration.inSeconds,
          })
          .eq('id', _currentRecordingId!);

      _isRecording = false;
      _currentRecordingId = null;
      _recordingStartTime = null;

      notifyListeners();

      debugPrint(
        'Call recording stopped. Duration: ${duration.inMinutes} minutes',
      );
      return true;
    } catch (e) {
      debugPrint('Failed to stop recording: $e');
      return false;
    }
  }

  /// Cancel recording
  Future<bool> cancelRecording() async {
    try {
      if (!_isRecording || _currentRecordingId == null) {
        return true;
      }

      // Mark recording as cancelled
      await _supabase
          .from('call_recordings')
          .update({
            'status': 'cancelled',
            'ended_at': DateTime.now().toIso8601String(),
          })
          .eq('id', _currentRecordingId!);

      _isRecording = false;
      _currentRecordingId = null;
      _recordingStartTime = null;

      notifyListeners();

      debugPrint('Call recording cancelled');
      return true;
    } catch (e) {
      debugPrint('Failed to cancel recording: $e');
      return false;
    }
  }

  /// Get recordings for a consultation
  Future<List<CallRecording>> getConsultationRecordings(
    String consultationId,
  ) async {
    try {
      final response = await _supabase
          .from('call_recordings')
          .select()
          .eq('consultation_id', consultationId)
          .order('created_at', ascending: false);

      final recordings = (response as List)
          .map((data) => CallRecording.fromJson(data))
          .toList();

      return recordings;
    } catch (e) {
      debugPrint('Failed to get recordings: $e');
      return [];
    }
  }

  /// Get doctor's recordings
  Future<List<CallRecording>> getDoctorRecordings(String doctorId) async {
    try {
      final response = await _supabase
          .from('call_recordings')
          .select()
          .eq('doctor_id', doctorId)
          .order('created_at', ascending: false);

      final recordings = (response as List)
          .map((data) => CallRecording.fromJson(data))
          .toList();

      _recordings = recordings;
      notifyListeners();

      return recordings;
    } catch (e) {
      debugPrint('Failed to get doctor recordings: $e');
      return [];
    }
  }

  /// Delete recording
  Future<bool> deleteRecording(String recordingId) async {
    try {
      // Mark as deleted instead of actually deleting for compliance
      await _supabase
          .from('call_recordings')
          .update({
            'status': 'deleted',
            'deleted_at': DateTime.now().toIso8601String(),
          })
          .eq('id', recordingId);

      // Remove from local list
      _recordings.removeWhere((r) => r.id == recordingId);
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('Failed to delete recording: $e');
      return false;
    }
  }

  /// Update recording consent status
  Future<bool> updateConsentStatus(String recordingId, bool hasConsent) async {
    try {
      await _supabase
          .from('call_recordings')
          .update({'patient_consent': hasConsent})
          .eq('id', recordingId);

      // Update local recording if exists
      final index = _recordings.indexWhere((r) => r.id == recordingId);
      if (index != -1) {
        _recordings[index] = _recordings[index].copyWith(
          patientConsent: hasConsent,
        );
        notifyListeners();
      }

      return true;
    } catch (e) {
      debugPrint('Failed to update consent: $e');
      return false;
    }
  }

  /// Get recording duration formatted
  String getFormattedDuration() {
    if (!_isRecording || _recordingStartTime == null) {
      return '00:00';
    }

    final duration = DateTime.now().difference(_recordingStartTime!);
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    // Stop recording if still active
    if (_isRecording) {
      stopRecording();
    }
    super.dispose();
  }
}
