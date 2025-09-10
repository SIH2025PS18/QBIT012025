import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../models/video_consultation.dart';
import '../services/connectivity_service.dart';

/// Service for managing video consultations, queue, and waiting room
class VideoConsultationService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  final ConnectivityService _connectivityService;
  final Uuid _uuid = const Uuid();

  // Current state
  VideoConsultation? _currentConsultation;
  List<VideoConsultation> _consultationQueue = [];
  List<VideoConsultation> _activeConsultations = [];
  QueuePosition? _currentQueuePosition;
  bool _isInWaitingRoom = false;

  // Stream controllers for real-time updates
  final StreamController<VideoConsultation?> _consultationStreamController =
      StreamController<VideoConsultation?>.broadcast();
  final StreamController<List<VideoConsultation>> _queueStreamController =
      StreamController<List<VideoConsultation>>.broadcast();
  final StreamController<QueuePosition?> _queuePositionStreamController =
      StreamController<QueuePosition?>.broadcast();

  Timer? _queueUpdateTimer;
  Timer? _waitTimeUpdateTimer;

  VideoConsultationService(this._connectivityService) {
    _initializeService();
  }

  // Getters
  VideoConsultation? get currentConsultation => _currentConsultation;
  List<VideoConsultation> get consultationQueue =>
      List.unmodifiable(_consultationQueue);
  List<VideoConsultation> get activeConsultations =>
      List.unmodifiable(_activeConsultations);
  QueuePosition? get currentQueuePosition => _currentQueuePosition;
  bool get isInWaitingRoom => _isInWaitingRoom;

  // Streams for real-time updates
  Stream<VideoConsultation?> get consultationStream =>
      _consultationStreamController.stream;
  Stream<List<VideoConsultation>> get queueStream =>
      _queueStreamController.stream;
  Stream<QueuePosition?> get queuePositionStream =>
      _queuePositionStreamController.stream;

  void _initializeService() {
    // Start periodic updates for queue management
    _queueUpdateTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _updateQueuePositions(),
    );

    // Start wait time updates
    _waitTimeUpdateTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _updateWaitTimes(),
    );
  }

  /// Create a new video consultation
  Future<VideoConsultation> createConsultation({
    required String appointmentId,
    required String patientId,
    required String doctorId,
    required String patientName,
    required String doctorName,
    String? patientAvatarUrl,
    String? doctorAvatarUrl,
    required DateTime scheduledAt,
    QueuePriority priority = QueuePriority.normal,
  }) async {
    try {
      final consultation = VideoConsultation.create(
        appointmentId: appointmentId,
        patientId: patientId,
        doctorId: doctorId,
        patientName: patientName,
        doctorName: doctorName,
        patientAvatarUrl: patientAvatarUrl,
        doctorAvatarUrl: doctorAvatarUrl,
        scheduledAt: scheduledAt,
        priority: priority,
      );

      // Save to Supabase
      if (_connectivityService.isConnected) {
        await _supabase
            .from('video_consultations')
            .insert(consultation.toJson());
      }

      return consultation;
    } catch (e) {
      debugPrint('Error creating consultation: $e');
      rethrow;
    }
  }

  /// Join consultation queue
  Future<void> joinQueue(String consultationId) async {
    try {
      final consultation = await getConsultation(consultationId);
      if (consultation == null) {
        throw Exception('Consultation not found');
      }

      // Update consultation status
      final updatedConsultation = consultation.copyWith(
        status: ConsultationStatus.inQueue,
        updatedAt: DateTime.now(),
      );

      // Calculate queue position
      final position = await _calculateQueuePosition(updatedConsultation);
      final queuePosition = QueuePosition(
        position: position,
        totalInQueue: _consultationQueue.length + 1,
        estimatedWaitTime: _calculateEstimatedWaitTime(
          position,
          updatedConsultation.priority,
        ),
        priority: updatedConsultation.priority,
      );

      // Add to queue
      _consultationQueue.add(
        updatedConsultation.copyWith(queuePosition: queuePosition),
      );
      _consultationQueue.sort(_compareByPriorityAndTime);

      // Update current consultation if it's ours
      if (_currentConsultation?.id == consultationId) {
        _currentConsultation = updatedConsultation.copyWith(
          queuePosition: queuePosition,
        );
        _currentQueuePosition = queuePosition;
        _consultationStreamController.add(_currentConsultation);
        _queuePositionStreamController.add(_currentQueuePosition);
      }

      // Save to Supabase
      if (_connectivityService.isConnected) {
        await _supabase
            .from('video_consultations')
            .update(updatedConsultation.toJson())
            .eq('id', consultationId);
      }

      _queueStreamController.add(_consultationQueue);
      notifyListeners();
    } catch (e) {
      debugPrint('Error joining queue: $e');
      rethrow;
    }
  }

  /// Enter waiting room
  Future<void> enterWaitingRoom(String consultationId) async {
    try {
      final consultation = await getConsultation(consultationId);
      if (consultation == null) {
        throw Exception('Consultation not found');
      }

      // Update consultation status
      final updatedConsultation = consultation.copyWith(
        status: ConsultationStatus.waitingRoom,
        updatedAt: DateTime.now(),
      );

      _currentConsultation = updatedConsultation;
      _isInWaitingRoom = true;

      // Save to Supabase
      if (_connectivityService.isConnected) {
        await _supabase
            .from('video_consultations')
            .update(updatedConsultation.toJson())
            .eq('id', consultationId);
      }

      _consultationStreamController.add(_currentConsultation);
      notifyListeners();
    } catch (e) {
      debugPrint('Error entering waiting room: $e');
      rethrow;
    }
  }

  /// Start consultation
  Future<void> startConsultation(String consultationId) async {
    try {
      final consultation = await getConsultation(consultationId);
      if (consultation == null) {
        throw Exception('Consultation not found');
      }

      final now = DateTime.now();
      final roomId = _uuid.v4();
      final sessionToken = _generateSessionToken();

      // Update consultation status
      final updatedConsultation = consultation.copyWith(
        status: ConsultationStatus.inProgress,
        startedAt: now,
        roomId: roomId,
        sessionToken: sessionToken,
        updatedAt: now,
      );

      // Remove from queue if it was there
      _consultationQueue.removeWhere((c) => c.id == consultationId);
      _activeConsultations.add(updatedConsultation);

      // Update current consultation
      _currentConsultation = updatedConsultation;
      _isInWaitingRoom = false;
      _currentQueuePosition = null;

      // Save to Supabase
      if (_connectivityService.isConnected) {
        await _supabase
            .from('video_consultations')
            .update(updatedConsultation.toJson())
            .eq('id', consultationId);
      }

      _consultationStreamController.add(_currentConsultation);
      _queueStreamController.add(_consultationQueue);
      _queuePositionStreamController.add(null);
      notifyListeners();
    } catch (e) {
      debugPrint('Error starting consultation: $e');
      rethrow;
    }
  }

  /// End consultation
  Future<void> endConsultation(
    String consultationId, {
    ConsultationRating? rating,
    String? feedback,
    String? prescription,
  }) async {
    try {
      final consultation = await getConsultation(consultationId);
      if (consultation == null) {
        throw Exception('Consultation not found');
      }

      final now = DateTime.now();
      final duration = consultation.startedAt != null
          ? now.difference(consultation.startedAt!)
          : null;

      // Update consultation status
      final updatedConsultation = consultation.copyWith(
        status: ConsultationStatus.completed,
        endedAt: now,
        duration: duration,
        rating: rating,
        feedback: feedback,
        prescription: prescription,
        updatedAt: now,
      );

      // Remove from active consultations
      _activeConsultations.removeWhere((c) => c.id == consultationId);

      // Clear current consultation if it's ours
      if (_currentConsultation?.id == consultationId) {
        _currentConsultation = null;
        _isInWaitingRoom = false;
        _currentQueuePosition = null;
      }

      // Save to Supabase
      if (_connectivityService.isConnected) {
        await _supabase
            .from('video_consultations')
            .update(updatedConsultation.toJson())
            .eq('id', consultationId);
      }

      _consultationStreamController.add(_currentConsultation);
      _queuePositionStreamController.add(null);
      notifyListeners();
    } catch (e) {
      debugPrint('Error ending consultation: $e');
      rethrow;
    }
  }

  /// Cancel consultation
  Future<void> cancelConsultation(String consultationId) async {
    try {
      final consultation = await getConsultation(consultationId);
      if (consultation == null) {
        throw Exception('Consultation not found');
      }

      // Update consultation status
      final updatedConsultation = consultation.copyWith(
        status: ConsultationStatus.cancelled,
        updatedAt: DateTime.now(),
      );

      // Remove from queue and active consultations
      _consultationQueue.removeWhere((c) => c.id == consultationId);
      _activeConsultations.removeWhere((c) => c.id == consultationId);

      // Clear current consultation if it's ours
      if (_currentConsultation?.id == consultationId) {
        _currentConsultation = null;
        _isInWaitingRoom = false;
        _currentQueuePosition = null;
      }

      // Save to Supabase
      if (_connectivityService.isConnected) {
        await _supabase
            .from('video_consultations')
            .update(updatedConsultation.toJson())
            .eq('id', consultationId);
      }

      _consultationStreamController.add(_currentConsultation);
      _queueStreamController.add(_consultationQueue);
      _queuePositionStreamController.add(null);
      notifyListeners();
    } catch (e) {
      debugPrint('Error cancelling consultation: $e');
      rethrow;
    }
  }

  /// Get consultation by ID
  Future<VideoConsultation?> getConsultation(String consultationId) async {
    try {
      // Check current consultation first
      if (_currentConsultation?.id == consultationId) {
        return _currentConsultation;
      }

      // Check queue
      final queueConsultation = _consultationQueue
          .where((c) => c.id == consultationId)
          .firstOrNull;
      if (queueConsultation != null) {
        return queueConsultation;
      }

      // Check active consultations
      final activeConsultation = _activeConsultations
          .where((c) => c.id == consultationId)
          .firstOrNull;
      if (activeConsultation != null) {
        return activeConsultation;
      }

      // Fetch from Supabase
      if (_connectivityService.isConnected) {
        final response = await _supabase
            .from('video_consultations')
            .select()
            .eq('id', consultationId)
            .maybeSingle();

        if (response != null) {
          return VideoConsultation.fromJson(response);
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error getting consultation: $e');
      return null;
    }
  }

  /// Get consultations for a user
  Future<List<VideoConsultation>> getUserConsultations(String userId) async {
    try {
      if (!_connectivityService.isConnected) {
        // Return local data when offline
        return [
          ..._consultationQueue.where(
            (c) => c.patientId == userId || c.doctorId == userId,
          ),
          ..._activeConsultations.where(
            (c) => c.patientId == userId || c.doctorId == userId,
          ),
        ];
      }

      final response = await _supabase
          .from('video_consultations')
          .select()
          .or('patient_id.eq.$userId,doctor_id.eq.$userId')
          .order('scheduled_at', ascending: false);

      return response
          .map<VideoConsultation>((json) => VideoConsultation.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error getting user consultations: $e');
      return [];
    }
  }

  /// Update queue positions for all consultations
  Future<void> _updateQueuePositions() async {
    try {
      if (_consultationQueue.isEmpty) return;

      // Sort queue by priority and time
      _consultationQueue.sort(_compareByPriorityAndTime);

      // Update positions
      for (int i = 0; i < _consultationQueue.length; i++) {
        final consultation = _consultationQueue[i];
        final newPosition = QueuePosition(
          position: i + 1,
          totalInQueue: _consultationQueue.length,
          estimatedWaitTime: _calculateEstimatedWaitTime(
            i + 1,
            consultation.priority,
          ),
          priority: consultation.priority,
        );

        _consultationQueue[i] = consultation.copyWith(
          queuePosition: newPosition,
        );

        // Update current position if it's our consultation
        if (_currentConsultation?.id == consultation.id) {
          _currentQueuePosition = newPosition;
          _queuePositionStreamController.add(_currentQueuePosition);
        }
      }

      _queueStreamController.add(_consultationQueue);
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating queue positions: $e');
    }
  }

  /// Update wait times
  void _updateWaitTimes() {
    // This would be called periodically to update estimated wait times
    // based on average consultation durations, doctor availability, etc.
    _updateQueuePositions();
  }

  /// Calculate queue position for new consultation
  Future<int> _calculateQueuePosition(VideoConsultation consultation) async {
    final sortedQueue = [..._consultationQueue];
    sortedQueue.add(consultation);
    sortedQueue.sort(_compareByPriorityAndTime);

    return sortedQueue.indexWhere((c) => c.id == consultation.id) + 1;
  }

  /// Calculate estimated wait time
  Duration _calculateEstimatedWaitTime(int position, QueuePriority priority) {
    // Base wait time per position (adjustable based on real data)
    const baseWaitMinutes = 15;

    // Priority multiplier
    final priorityMultiplier = switch (priority) {
      QueuePriority.emergency => 0.1,
      QueuePriority.urgent => 0.3,
      QueuePriority.high => 0.7,
      QueuePriority.normal => 1.0,
      QueuePriority.low => 1.5,
    };

    final estimatedMinutes = (position * baseWaitMinutes * priorityMultiplier)
        .ceil();
    return Duration(minutes: max(1, estimatedMinutes));
  }

  /// Compare consultations by priority and time for queue sorting
  int _compareByPriorityAndTime(VideoConsultation a, VideoConsultation b) {
    // First sort by priority (higher priority first)
    final priorityComparison = b.priority.priorityValue.compareTo(
      a.priority.priorityValue,
    );
    if (priorityComparison != 0) {
      return priorityComparison;
    }

    // Then sort by scheduled time (earlier first)
    return a.scheduledAt.compareTo(b.scheduledAt);
  }

  /// Generate session token for video consultation
  String _generateSessionToken() {
    return _uuid.v4().replaceAll('-', '');
  }

  /// Add participant to consultation
  Future<void> addParticipant({
    required String consultationId,
    required String userId,
    required String name,
    required ParticipantRole role,
    String? avatarUrl,
  }) async {
    try {
      final consultation = await getConsultation(consultationId);
      if (consultation == null) {
        throw Exception('Consultation not found');
      }

      final participant = ConsultationParticipant(
        id: _uuid.v4(),
        userId: userId,
        name: name,
        role: role,
        avatarUrl: avatarUrl,
        isConnected: true,
        joinedAt: DateTime.now(),
      );

      final updatedParticipants = [...consultation.participants, participant];
      final updatedConsultation = consultation.copyWith(
        participants: updatedParticipants,
        updatedAt: DateTime.now(),
      );

      // Update local state
      _updateConsultationInLists(updatedConsultation);

      // Save to Supabase
      if (_connectivityService.isConnected) {
        await _supabase
            .from('video_consultations')
            .update(updatedConsultation.toJson())
            .eq('id', consultationId);
      }

      _consultationStreamController.add(_currentConsultation);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding participant: $e');
      rethrow;
    }
  }

  /// Update participant status
  Future<void> updateParticipant({
    required String consultationId,
    required String participantId,
    bool? isConnected,
    bool? isMuted,
    bool? isVideoEnabled,
  }) async {
    try {
      final consultation = await getConsultation(consultationId);
      if (consultation == null) {
        throw Exception('Consultation not found');
      }

      final updatedParticipants = consultation.participants.map((participant) {
        if (participant.id == participantId) {
          return participant.copyWith(
            isConnected: isConnected ?? participant.isConnected,
            isMuted: isMuted ?? participant.isMuted,
            isVideoEnabled: isVideoEnabled ?? participant.isVideoEnabled,
          );
        }
        return participant;
      }).toList();

      final updatedConsultation = consultation.copyWith(
        participants: updatedParticipants,
        updatedAt: DateTime.now(),
      );

      // Update local state
      _updateConsultationInLists(updatedConsultation);

      // Save to Supabase
      if (_connectivityService.isConnected) {
        await _supabase
            .from('video_consultations')
            .update(updatedConsultation.toJson())
            .eq('id', consultationId);
      }

      _consultationStreamController.add(_currentConsultation);
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating participant: $e');
      rethrow;
    }
  }

  /// Update consultation in all lists
  void _updateConsultationInLists(VideoConsultation updatedConsultation) {
    // Update current consultation
    if (_currentConsultation?.id == updatedConsultation.id) {
      _currentConsultation = updatedConsultation;
    }

    // Update in queue
    final queueIndex = _consultationQueue.indexWhere(
      (c) => c.id == updatedConsultation.id,
    );
    if (queueIndex != -1) {
      _consultationQueue[queueIndex] = updatedConsultation;
    }

    // Update in active consultations
    final activeIndex = _activeConsultations.indexWhere(
      (c) => c.id == updatedConsultation.id,
    );
    if (activeIndex != -1) {
      _activeConsultations[activeIndex] = updatedConsultation;
    }
  }

  /// Get doctor's queue
  Future<List<VideoConsultation>> getDoctorQueue(String doctorId) async {
    try {
      if (!_connectivityService.isConnected) {
        return _consultationQueue.where((c) => c.doctorId == doctorId).toList();
      }

      final response = await _supabase
          .from('video_consultations')
          .select()
          .eq('doctor_id', doctorId)
          .inFilter('status', [
            ConsultationStatus.inQueue.name,
            ConsultationStatus.waitingRoom.name,
          ])
          .order('created_at', ascending: true);

      return response
          .map<VideoConsultation>((json) => VideoConsultation.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error getting doctor queue: $e');
      return [];
    }
  }

  @override
  void dispose() {
    _queueUpdateTimer?.cancel();
    _waitTimeUpdateTimer?.cancel();
    _consultationStreamController.close();
    _queueStreamController.close();
    _queuePositionStreamController.close();
    super.dispose();
  }
}
