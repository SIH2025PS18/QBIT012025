import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_theme.dart';
import '../models/video_consultation.dart';
import '../services/video_consultation_service.dart';
import '../generated/l10n/app_localizations.dart';
import '../widgets/sync_status_widget.dart';
import 'video_consultation_screen.dart';

/// Queue management screen for healthcare providers
class QueueManagementScreen extends StatefulWidget {
  final String doctorId;

  const QueueManagementScreen({super.key, required this.doctorId});

  @override
  State<QueueManagementScreen> createState() => _QueueManagementScreenState();
}

class _QueueManagementScreenState extends State<QueueManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  VideoConsultationService? _consultationService;

  List<VideoConsultation> _queuedConsultations = [];
  List<VideoConsultation> _activeConsultations = [];
  List<VideoConsultation> _completedConsultations = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  void _initializeData() async {
    _consultationService = Provider.of<VideoConsultationService>(
      context,
      listen: false,
    );
    await _loadDoctorQueue();
  }

  Future<void> _loadDoctorQueue() async {
    try {
      final allConsultations = await _consultationService!.getDoctorQueue(
        widget.doctorId,
      );

      if (mounted) {
        setState(() {
          _queuedConsultations = allConsultations
              .where(
                (c) =>
                    c.status == ConsultationStatus.inQueue ||
                    c.status == ConsultationStatus.waitingRoom,
              )
              .toList();

          _activeConsultations = allConsultations
              .where((c) => c.status == ConsultationStatus.inProgress)
              .toList();

          _completedConsultations = allConsultations
              .where((c) => c.isCompleted)
              .toList();
        });
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to load queue: $e');
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.queueManagement),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDoctorQueue,
          ),
          const SyncStatusWidget(showAsButton: true),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            _buildTabWithBadge(
              icon: Icons.queue,
              text: l10n.queue,
              count: _queuedConsultations.length,
            ),
            _buildTabWithBadge(
              icon: Icons.video_call,
              text: l10n.active,
              count: _activeConsultations.length,
            ),
            _buildTabWithBadge(
              icon: Icons.check_circle,
              text: l10n.completed,
              count: _completedConsultations.length,
            ),
          ],
        ),
      ),
      body: Consumer<VideoConsultationService>(
        builder: (context, consultationService, child) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildQueueTab(l10n, consultationService),
              _buildActiveTab(l10n, consultationService),
              _buildCompletedTab(l10n, consultationService),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQueueStatistics(context),
        icon: const Icon(Icons.analytics),
        label: Text(l10n.statistics),
      ),
    );
  }

  Widget _buildTabWithBadge({
    required IconData icon,
    required String text,
    required int count,
  }) {
    return Tab(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(icon), const SizedBox(height: 4), Text(text)],
          ),
          if (count > 0)
            Positioned(
              right: -8,
              top: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQueueTab(
    AppLocalizations l10n,
    VideoConsultationService service,
  ) {
    if (_queuedConsultations.isEmpty) {
      return _buildEmptyState(
        icon: Icons.queue,
        title: l10n.noPatients,
        subtitle: 'No patients waiting in queue',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDoctorQueue,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: _queuedConsultations.length,
        itemBuilder: (context, index) {
          final consultation = _queuedConsultations[index];
          return _buildConsultationCard(consultation, l10n, service);
        },
      ),
    );
  }

  Widget _buildActiveTab(
    AppLocalizations l10n,
    VideoConsultationService service,
  ) {
    if (_activeConsultations.isEmpty) {
      return _buildEmptyState(
        icon: Icons.video_call_outlined,
        title: 'No Active Consultations',
        subtitle: 'No consultations currently in progress',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDoctorQueue,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: _activeConsultations.length,
        itemBuilder: (context, index) {
          final consultation = _activeConsultations[index];
          return _buildConsultationCard(
            consultation,
            l10n,
            service,
            isActive: true,
          );
        },
      ),
    );
  }

  Widget _buildCompletedTab(
    AppLocalizations l10n,
    VideoConsultationService service,
  ) {
    if (_completedConsultations.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle_outline,
        title: 'No Completed Consultations',
        subtitle: 'No consultations completed today',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDoctorQueue,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: _completedConsultations.length,
        itemBuilder: (context, index) {
          final consultation = _completedConsultations[index];
          return _buildConsultationCard(
            consultation,
            l10n,
            service,
            isCompleted: true,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: AppColors.textSecondary.withOpacity(0.5)),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: AppTextStyles.h4.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            subtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationCard(
    VideoConsultation consultation,
    AppLocalizations l10n,
    VideoConsultationService service, {
    bool isActive = false,
    bool isCompleted = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: isActive
              ? AppColors.success.withOpacity(0.3)
              : isCompleted
              ? AppColors.textSecondary.withOpacity(0.2)
              : _getPriorityColor(consultation.priority).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient info header
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: consultation.patientAvatarUrl != null
                      ? NetworkImage(consultation.patientAvatarUrl!)
                      : null,
                  child: consultation.patientAvatarUrl == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(consultation.patientName, style: AppTextStyles.h5),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        consultation.status.displayName,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: _getStatusColor(consultation.status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isCompleted && consultation.queuePosition != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      '#${consultation.queuePosition!.position}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // Action buttons
            if (!isCompleted)
              Row(
                children: [
                  if (!isActive)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _startConsultation(consultation, service),
                        icon: const Icon(Icons.video_call),
                        label: Text(l10n.startConsultation),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  if (isActive) ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _joinActiveConsultation(consultation),
                        icon: const Icon(Icons.join_inner),
                        label: Text(l10n.joinCall),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    OutlinedButton.icon(
                      onPressed: () =>
                          _endConsultation(consultation, service, l10n),
                      icon: const Icon(Icons.call_end),
                      label: Text(l10n.endCall),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  Color _getPriorityColor(QueuePriority priority) {
    switch (priority) {
      case QueuePriority.emergency:
        return Colors.red[700]!;
      case QueuePriority.urgent:
        return Colors.red;
      case QueuePriority.high:
        return Colors.orange;
      case QueuePriority.normal:
        return AppColors.textSecondary;
      case QueuePriority.low:
        return Colors.grey;
    }
  }

  Color _getStatusColor(ConsultationStatus status) {
    switch (status) {
      case ConsultationStatus.inProgress:
        return AppColors.success;
      case ConsultationStatus.inQueue:
        return AppColors.primary;
      case ConsultationStatus.waitingRoom:
        return AppColors.warning;
      case ConsultationStatus.completed:
        return AppColors.success;
      case ConsultationStatus.cancelled:
        return AppColors.warning;
      case ConsultationStatus.noShow:
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  // Action methods
  void _startConsultation(
    VideoConsultation consultation,
    VideoConsultationService service,
  ) async {
    try {
      await service.startConsultation(consultation.id);
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VideoConsultationScreen(
              userId: widget.doctorId,
              isDoctor: true,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to start consultation: $e');
      }
    }
  }

  void _joinActiveConsultation(VideoConsultation consultation) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoConsultationScreen(
          userId: widget.doctorId,
          isDoctor: true,
        ),
      ),
    );
  }

  void _endConsultation(
    VideoConsultation consultation,
    VideoConsultationService service,
    AppLocalizations l10n,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.endConsultation),
        content: Text(l10n.confirmEndConsultation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.endCall),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        await service.endConsultation(consultation.id);
        await _loadDoctorQueue();
      } catch (e) {
        if (mounted) {
          _showErrorSnackBar('Failed to end consultation: $e');
        }
      }
    }
  }

  void _showQueueStatistics(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.queueStatistics),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatRow('In Queue', _queuedConsultations.length),
            _buildStatRow('Active', _activeConsultations.length),
            _buildStatRow('Completed Today', _completedConsultations.length),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(
            value.toString(),
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }
}
