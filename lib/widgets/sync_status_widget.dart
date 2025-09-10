import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/connectivity_service.dart';
import '../services/sync_service.dart';
import '../generated/l10n/app_localizations.dart';

/// Widget to display sync status and connectivity information
class SyncStatusWidget extends StatelessWidget {
  final bool showDetails;
  final bool showAsButton;

  const SyncStatusWidget({
    super.key,
    this.showDetails = false,
    this.showAsButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<ConnectivityService, SyncService>(
      builder: (context, connectivity, sync, child) {
        if (showAsButton) {
          return _buildSyncButton(context, connectivity, sync);
        } else {
          return _buildSyncIndicator(context, connectivity, sync);
        }
      },
    );
  }

  /// Build sync button
  Widget _buildSyncButton(
    BuildContext context,
    ConnectivityService connectivity,
    SyncService sync,
  ) {
    return IconButton(
      icon: _getSyncIcon(sync.syncStatus),
      tooltip: _getSyncTooltip(context, connectivity, sync),
      onPressed: connectivity.isConnected && !sync.isSyncing
          ? () => sync.syncNow()
          : null,
    );
  }

  /// Build sync indicator
  Widget _buildSyncIndicator(
    BuildContext context,
    ConnectivityService connectivity,
    SyncService sync,
  ) {
    if (!showDetails && sync.syncStatus == SyncStatus.synced) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _getSyncColor(sync.syncStatus).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getSyncColor(sync.syncStatus).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 16, height: 16, child: _getSyncIcon(sync.syncStatus)),
          const SizedBox(width: 8),
          Text(
            _getSyncStatusText(context, connectivity, sync),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _getSyncColor(sync.syncStatus),
            ),
          ),
          if (showDetails && sync.pendingSyncCount > 0) ...[
            const SizedBox(width: 4),
            Text(
              '(${sync.pendingSyncCount})',
              style: TextStyle(
                fontSize: 10,
                color: _getSyncColor(sync.syncStatus).withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Get sync icon based on status
  Widget _getSyncIcon(SyncStatus status) {
    switch (status) {
      case SyncStatus.synced:
        return const Icon(Icons.check_circle, color: Colors.green, size: 16);
      case SyncStatus.syncing:
        return const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        );
      case SyncStatus.pendingSync:
        return const Icon(Icons.sync_problem, color: Colors.orange, size: 16);
      case SyncStatus.offline:
        return const Icon(Icons.wifi_off, color: Colors.grey, size: 16);
      case SyncStatus.error:
        return const Icon(Icons.error_outline, color: Colors.red, size: 16);
    }
  }

  /// Get sync color based on status
  Color _getSyncColor(SyncStatus status) {
    switch (status) {
      case SyncStatus.synced:
        return Colors.green;
      case SyncStatus.syncing:
        return Colors.blue;
      case SyncStatus.pendingSync:
        return Colors.orange;
      case SyncStatus.offline:
        return Colors.grey;
      case SyncStatus.error:
        return Colors.red;
    }
  }

  /// Get sync status text
  String _getSyncStatusText(
    BuildContext context,
    ConnectivityService connectivity,
    SyncService sync,
  ) {
    final l10n = AppLocalizations.of(context)!;

    switch (sync.syncStatus) {
      case SyncStatus.synced:
        return l10n.synced;
      case SyncStatus.syncing:
        return l10n.syncing;
      case SyncStatus.pendingSync:
        return l10n.pendingSync;
      case SyncStatus.offline:
        return l10n.offline;
      case SyncStatus.error:
        return l10n.syncError;
    }
  }

  /// Get sync tooltip
  String _getSyncTooltip(
    BuildContext context,
    ConnectivityService connectivity,
    SyncService sync,
  ) {
    final l10n = AppLocalizations.of(context)!;

    if (!connectivity.isConnected) {
      return l10n.noInternetConnection;
    }

    if (sync.isSyncing) {
      return l10n.syncInProgress;
    }

    if (sync.pendingSyncCount > 0) {
      return l10n.tapToSync;
    }

    if (sync.lastSyncError != null) {
      return l10n.syncFailed;
    }

    return l10n.tapToRefresh;
  }
}

/// Detailed sync status dialog
class SyncStatusDialog extends StatelessWidget {
  const SyncStatusDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const SyncStatusDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer2<ConnectivityService, SyncService>(
      builder: (context, connectivity, sync, child) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.sync, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(l10n.syncStatus),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Connection status
              _buildStatusRow(
                l10n.connectionStatus,
                connectivity.connectionTypeDescription,
                connectivity.isConnected ? Icons.wifi : Icons.wifi_off,
                connectivity.isConnected ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 12),

              // Sync status
              _buildStatusRow(
                l10n.syncStatus,
                sync.syncStatus.displayName,
                _getStatusIcon(sync.syncStatus),
                _getStatusColor(sync.syncStatus),
              ),

              if (sync.pendingSyncCount > 0) ...[
                const SizedBox(height: 12),
                _buildStatusRow(
                  l10n.pendingChanges,
                  '${sync.pendingSyncCount} items',
                  Icons.pending_actions,
                  Colors.orange,
                ),
              ],

              if (sync.lastSyncTime != null) ...[
                const SizedBox(height: 12),
                _buildStatusRow(
                  l10n.lastSync,
                  _formatDateTime(sync.lastSyncTime!),
                  Icons.schedule,
                  Colors.grey,
                ),
              ],

              if (sync.lastSyncError != null) ...[
                const SizedBox(height: 12),
                _buildStatusRow(
                  l10n.error,
                  sync.lastSyncError!,
                  Icons.error,
                  Colors.red,
                ),
              ],
            ],
          ),
          actions: [
            if (connectivity.isConnected && !sync.isSyncing)
              TextButton.icon(
                onPressed: () {
                  sync.syncNow();
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.sync),
                label: Text(l10n.syncNow),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.close),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getStatusIcon(SyncStatus status) {
    switch (status) {
      case SyncStatus.synced:
        return Icons.check_circle;
      case SyncStatus.syncing:
        return Icons.sync;
      case SyncStatus.pendingSync:
        return Icons.sync_problem;
      case SyncStatus.offline:
        return Icons.wifi_off;
      case SyncStatus.error:
        return Icons.error;
    }
  }

  Color _getStatusColor(SyncStatus status) {
    switch (status) {
      case SyncStatus.synced:
        return Colors.green;
      case SyncStatus.syncing:
        return Colors.blue;
      case SyncStatus.pendingSync:
        return Colors.orange;
      case SyncStatus.offline:
        return Colors.grey;
      case SyncStatus.error:
        return Colors.red;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

/// Connectivity indicator for app bar
class ConnectivityIndicator extends StatelessWidget {
  const ConnectivityIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityService>(
      builder: (context, connectivity, child) {
        if (connectivity.isConnected) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 14, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                AppLocalizations.of(context)!.offline,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
