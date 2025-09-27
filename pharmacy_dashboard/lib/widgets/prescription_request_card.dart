import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/prescription_request.dart';

class PrescriptionRequestCard extends StatefulWidget {
  final PrescriptionRequest request;
  final Function(
    String response,
    String? notes,
    double? cost,
    List<Map<String, dynamic>>? medicineAvailability,
  )
  onResponse;

  const PrescriptionRequestCard({
    super.key,
    required this.request,
    required this.onResponse,
  });

  @override
  State<PrescriptionRequestCard> createState() =>
      _PrescriptionRequestCardState();
}

class _PrescriptionRequestCardState extends State<PrescriptionRequestCard>
    with TickerProviderStateMixin {
  late AnimationController _timerController;
  bool _isExpanded = false;
  bool _isResponding = false;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  void _initializeTimer() {
    final timeRemaining = widget.request.timeRemaining;
    final totalDuration = const Duration(
      minutes: 15,
    ); // Assuming 15-minute window
    final elapsedDuration = totalDuration - timeRemaining;

    _timerController = AnimationController(
      duration: totalDuration,
      vsync: this,
    );

    if (timeRemaining > Duration.zero) {
      _timerController.value =
          elapsedDuration.inMilliseconds / totalDuration.inMilliseconds;
      _timerController.forward();
    } else {
      _timerController.value = 1.0; // Expired
    }
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urgency = _getUrgencyLevel();
    final urgencyColor = _getUrgencyColor(urgency);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: urgency == 'critical' ? 6 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: urgency == 'critical'
            ? BorderSide(color: urgencyColor, width: 2)
            : BorderSide.none,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(urgencyColor, urgency),
          _buildContent(),
          if (_isExpanded) _buildExpandedContent(),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildHeader(Color urgencyColor, String urgency) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: urgencyColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: 20,
                child: Text(
                  widget.request.patientName.isNotEmpty
                      ? widget.request.patientName[0].toUpperCase()
                      : 'P',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.request.patientName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Dr. ${widget.request.doctorName}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              _buildUrgencyChip(urgency, urgencyColor),
            ],
          ),
          const SizedBox(height: 12),
          _buildTimerIndicator(),
        ],
      ),
    );
  }

  Widget _buildUrgencyChip(String urgency, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        urgency.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTimerIndicator() {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.timer_outlined,
              size: 16,
              color: _getUrgencyColor(_getUrgencyLevel()),
            ),
            const SizedBox(width: 4),
            Text(
              _getTimeRemainingText(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _getUrgencyColor(_getUrgencyLevel()),
              ),
            ),
            const Spacer(),
            Text(
              'Requested: ${_formatTime(widget.request.requestedAt)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _timerController,
          builder: (context, child) {
            return LinearProgressIndicator(
              value: _timerController.value,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getUrgencyColor(_getUrgencyLevel()),
              ),
              minHeight: 4,
            );
          },
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${widget.request.medicines.length} medicines prescribed',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildMedicinePreview(),
          if (widget.request.patientLocation != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  widget.request.patientLocation!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                if (widget.request.distanceFromPharmacy != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    '• ${widget.request.distanceFromPharmacy!.toStringAsFixed(1)} km away',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMedicinePreview() {
    final displayMedicines = widget.request.medicines.take(2).toList();

    return Column(
      children: [
        ...displayMedicines.map(
          (medicine) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${medicine.name} - ${medicine.dosage} (Qty: ${medicine.quantity})',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.request.medicines.length > 2)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '... and ${widget.request.medicines.length - 2} more',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildExpandedContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const Text(
            'Full Prescription:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ...widget.request.medicines.map(
            (medicine) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('Dosage: ${medicine.dosage}'),
                      const SizedBox(width: 16),
                      Text('Quantity: ${medicine.quantity}'),
                    ],
                  ),
                  if (medicine.instructions != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Instructions: ${medicine.instructions}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    if (widget.request.isExpired) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.timer_off, color: Colors.red[600]),
              const SizedBox(width: 8),
              const Text(
                'Request Expired',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Response (choose one):',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          if (_isResponding)
            const Center(child: CircularProgressIndicator())
          else
            Row(
              children: [
                Expanded(
                  child: _buildQuickResponseButton(
                    label: 'All Available',
                    color: Colors.green,
                    icon: Icons.check_circle_outline,
                    onPressed: () => _showResponseDialog('all_available'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildQuickResponseButton(
                    label: 'Some Available',
                    color: Colors.orange,
                    icon: Icons.edit_note,
                    onPressed: () => _showResponseDialog('some_available'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildQuickResponseButton(
                    label: 'Unavailable',
                    color: Colors.red,
                    icon: Icons.cancel_outlined,
                    onPressed: () => _showResponseDialog('unavailable'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildQuickResponseButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showResponseDialog(String responseType) {
    showDialog(
      context: context,
      builder: (context) => ResponseDialog(
        responseType: responseType,
        request: widget.request,
        onConfirm: (notes, cost, medicineAvailability) {
          _handleResponse(responseType, notes, cost, medicineAvailability);
        },
      ),
    );
  }

  Future<void> _handleResponse(
    String responseType,
    String? notes,
    double? cost,
    List<Map<String, dynamic>>? medicineAvailability,
  ) async {
    setState(() {
      _isResponding = true;
    });

    try {
      widget.onResponse(responseType, notes, cost, medicineAvailability);
    } finally {
      if (mounted) {
        setState(() {
          _isResponding = false;
        });
      }
    }
  }

  String _getUrgencyLevel() {
    final timeRemaining = widget.request.timeRemaining;

    if (timeRemaining == Duration.zero) return 'expired';
    if (timeRemaining.inMinutes <= 2) return 'critical';
    if (timeRemaining.inMinutes <= 5) return 'high';
    if (timeRemaining.inMinutes <= 10) return 'medium';

    return 'normal';
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.amber;
      case 'normal':
        return Colors.green;
      case 'expired':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  String _getTimeRemainingText() {
    if (widget.request.isExpired) return 'Expired';

    final remaining = widget.request.timeRemaining;

    if (remaining.inMinutes < 60) {
      return '${remaining.inMinutes}m ${remaining.inSeconds % 60}s remaining';
    } else {
      return '${remaining.inHours}h ${remaining.inMinutes % 60}m remaining';
    }
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('MMM dd, HH:mm').format(dateTime);
  }
}

// Response Dialog for detailed responses
class ResponseDialog extends StatefulWidget {
  final String responseType;
  final PrescriptionRequest request;
  final Function(
    String? notes,
    double? cost,
    List<Map<String, dynamic>>? medicineAvailability,
  )
  onConfirm;

  const ResponseDialog({
    super.key,
    required this.responseType,
    required this.request,
    required this.onConfirm,
  });

  @override
  State<ResponseDialog> createState() => _ResponseDialogState();
}

class _ResponseDialogState extends State<ResponseDialog> {
  final _notesController = TextEditingController();
  final _costController = TextEditingController();
  final List<Map<String, dynamic>> _medicineAvailability = [];

  @override
  void initState() {
    super.initState();

    // Initialize medicine availability for "some available" responses
    if (widget.responseType == 'some_available') {
      for (final medicine in widget.request.medicines) {
        _medicineAvailability.add({
          'name': medicine.name,
          'available': true,
          'notes': '',
        });
      }
    }

    // Set default notes based on response type
    switch (widget.responseType) {
      case 'all_available':
        _notesController.text =
            'All medicines are available. Ready for pickup/delivery.';
        break;
      case 'unavailable':
        _notesController.text =
            'Sorry, the requested medicines are currently unavailable.';
        break;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_getDialogTitle()),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notes field
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'Add any additional information...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            // Cost estimate (for available responses)
            if (widget.responseType != 'unavailable') ...[
              TextField(
                controller: _costController,
                decoration: const InputDecoration(
                  labelText: 'Estimated Cost (₹)',
                  hintText: 'Enter total cost',
                  border: OutlineInputBorder(),
                  prefixText: '₹ ',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
            ],

            // Medicine availability (for some available responses)
            if (widget.responseType == 'some_available') ...[
              const Text(
                'Medicine Availability:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ..._medicineAvailability.asMap().entries.map((entry) {
                final index = entry.key;
                final medicine = entry.value;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicine['name'],
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                title: const Text('Available'),
                                value: medicine['available'],
                                onChanged: (value) {
                                  setState(() {
                                    _medicineAvailability[index]['available'] =
                                        value ?? false;
                                  });
                                },
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                        if (!medicine['available'])
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Reason/Alternative',
                              hintText:
                                  'Why unavailable or suggest alternative',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              _medicineAvailability[index]['notes'] = value;
                            },
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: _getButtonColor(),
            foregroundColor: Colors.white,
          ),
          child: const Text('Send Response'),
        ),
      ],
    );
  }

  String _getDialogTitle() {
    switch (widget.responseType) {
      case 'all_available':
        return 'All Medicines Available';
      case 'some_available':
        return 'Partial Availability';
      case 'unavailable':
        return 'Not Available';
      default:
        return 'Respond to Request';
    }
  }

  Color _getButtonColor() {
    switch (widget.responseType) {
      case 'all_available':
        return Colors.green;
      case 'some_available':
        return Colors.orange;
      case 'unavailable':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  void _handleConfirm() {
    final notes = _notesController.text.trim().isEmpty
        ? null
        : _notesController.text.trim();
    final cost = _costController.text.trim().isEmpty
        ? null
        : double.tryParse(_costController.text.trim());

    List<Map<String, dynamic>>? medicineAvailability;
    if (widget.responseType == 'some_available') {
      medicineAvailability = _medicineAvailability;
    }

    widget.onConfirm(notes, cost, medicineAvailability);
    Navigator.pop(context);
  }
}
