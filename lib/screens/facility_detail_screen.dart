import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/medical_facility.dart';

class FacilityDetailScreen extends StatefulWidget {
  final MedicalFacility facility;

  const FacilityDetailScreen({Key? key, required this.facility})
    : super(key: key);

  @override
  State<FacilityDetailScreen> createState() => _FacilityDetailScreenState();
}

class _FacilityDetailScreenState extends State<FacilityDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar with facility image and basic info
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFF2E7D32),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF2E7D32),
                      const Color(0xFF2E7D32).withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Facility name and type
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.facility.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            _buildTypeChip(),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Address
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white70,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                widget.facility.address,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Status and rating
                        Row(
                          children: [
                            _buildStatusBadge(),
                            const Spacer(),
                            if (widget.facility.rating != null)
                              _buildRatingInfo(),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Quick action buttons
                        Row(
                          children: [
                            _buildActionButton(
                              Icons.phone,
                              'Call',
                              () => _makeCall(),
                            ),
                            const SizedBox(width: 12),
                            _buildActionButton(
                              Icons.directions,
                              'Directions',
                              () => _openDirections(),
                            ),
                            const SizedBox(width: 12),
                            _buildActionButton(
                              Icons.share,
                              'Share',
                              () => _shareLocation(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Tab Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF2E7D32),
                labelColor: const Color(0xFF2E7D32),
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Equipment'),
                  Tab(text: 'Services'),
                  Tab(text: 'Reviews'),
                ],
              ),
            ),
          ),

          // Tab content
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildEquipmentTab(),
                _buildServicesTab(),
                _buildReviewsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip() {
    IconData icon;

    switch (widget.facility.type) {
      case 'hospital':
        icon = Icons.local_hospital;
        break;
      case 'clinic':
        icon = Icons.medical_services;
        break;
      case 'lab':
        icon = Icons.science;
        break;
      default:
        icon = Icons.medical_services;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            widget.facility.type.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    final isOpen = widget.facility.operatingHours.isOpenNow();
    final isOperational = widget.facility.status.isOperational;
    final acceptingPatients = widget.facility.status.acceptingPatients;

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (isOperational && acceptingPatients && isOpen) {
      statusColor = Colors.green;
      statusText = 'OPEN & ACCEPTING PATIENTS';
      statusIcon = Icons.check_circle;
    } else if (isOperational && !isOpen) {
      statusColor = Colors.orange;
      statusText = 'CLOSED';
      statusIcon = Icons.access_time;
    } else if (!acceptingPatients) {
      statusColor = Colors.red;
      statusText = 'NOT ACCEPTING PATIENTS';
      statusIcon = Icons.block;
    } else {
      statusColor = Colors.grey;
      statusText = 'STATUS UNKNOWN';
      statusIcon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 14, color: statusColor),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 16, color: Colors.amber),
          const SizedBox(width: 4),
          Text(
            '${widget.facility.rating!.toStringAsFixed(1)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (widget.facility.reviewCount != null)
            Text(
              ' (${widget.facility.reviewCount})',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.2),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contact Information
          _buildSectionCard('Contact Information', Icons.contact_phone, [
            _buildInfoRow(Icons.phone, 'Phone', widget.facility.phoneNumber),
            if (widget.facility.email != null)
              _buildInfoRow(Icons.email, 'Email', widget.facility.email!),
            if (widget.facility.website != null)
              _buildInfoRow(Icons.web, 'Website', widget.facility.website!),
            if (widget.facility.emergencyNumber != null)
              _buildInfoRow(
                Icons.emergency,
                'Emergency',
                widget.facility.emergencyNumber!,
              ),
          ]),

          const SizedBox(height: 16),

          // Operating Hours
          _buildSectionCard('Operating Hours', Icons.access_time, [
            if (widget.facility.operatingHours.is24Hours)
              _buildInfoRow(Icons.schedule, 'Hours', '24/7 - Always Open')
            else
              ..._buildOperatingHoursRows(),
          ]),

          const SizedBox(height: 16),

          // Specialties
          if (widget.facility.specialties.isNotEmpty)
            _buildSectionCard('Specialties', Icons.medical_services, [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.facility.specialties.map((specialty) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      specialty,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ]),

          const SizedBox(height: 16),

          // Last Updated
          _buildSectionCard('Information', Icons.info, [
            _buildInfoRow(
              Icons.update,
              'Last Updated',
              widget.facility.getLastUpdatedText(),
            ),
            _buildInfoRow(
              Icons.wifi,
              'Connection Status',
              widget.facility.isOnline ? 'Online' : 'Offline',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildEquipmentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Critical Care Equipment
          _buildSectionCard('Critical Care', Icons.monitor_heart, [
            _buildEquipmentStatus(
              'ICU Beds',
              Icons.airline_seat_flat,
              '${widget.facility.equipment.icuStatus.availableBeds}/${widget.facility.equipment.icuStatus.totalBeds} available',
              widget.facility.equipment.icuStatus.isAvailable,
            ),
            _buildEquipmentStatus(
              'Ventilators',
              Icons.air,
              '${widget.facility.equipment.ventilatorStatus.availableVentilators}/${widget.facility.equipment.ventilatorStatus.totalVentilators} available',
              widget.facility.equipment.ventilatorStatus.isAvailable,
            ),
            _buildEquipmentStatus(
              'Oxygen Supply',
              Icons.opacity,
              '${widget.facility.equipment.oxygenStatus.percentage}% - ${widget.facility.equipment.oxygenStatus.level}',
              widget.facility.equipment.oxygenStatus.isAvailable,
            ),
          ]),

          const SizedBox(height: 16),

          // Diagnostic Equipment
          if (widget.facility.equipment.diagnosticEquipment.isNotEmpty)
            _buildSectionCard(
              'Diagnostic Equipment',
              Icons.biotech,
              widget.facility.equipment.diagnosticEquipment.entries.map((
                entry,
              ) {
                final equipment = entry.value;
                return _buildEquipmentStatus(
                  equipment.name,
                  Icons.medical_services,
                  equipment.isAvailable
                      ? equipment.queueLength > 0
                            ? 'Available - Queue: ${equipment.queueLength}'
                            : 'Available'
                      : 'Not Available',
                  equipment.isAvailable,
                );
              }).toList(),
            ),

          const SizedBox(height: 16),

          // Blood Bank
          if (widget.facility.bloodBank != null) _buildBloodBankSection(),
        ],
      ),
    );
  }

  Widget _buildServicesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Test Costs
          if (widget.facility.testCosts.isNotEmpty)
            _buildSectionCard(
              'Test Costs',
              Icons.science,
              widget.facility.testCosts.map((test) {
                return _buildCostItem(
                  test.testName,
                  test.category,
                  test.costRange,
                  test.isAvailable,
                );
              }).toList(),
            ),

          const SizedBox(height: 16),

          // Procedure Costs
          if (widget.facility.procedureCosts.isNotEmpty)
            _buildSectionCard(
              'Procedure Costs',
              Icons.medical_services,
              widget.facility.procedureCosts.map((procedure) {
                return _buildCostItem(
                  procedure.procedureName,
                  procedure.category,
                  procedure.costRange,
                  procedure.isAvailable,
                  duration: procedure.duration,
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(Icons.star_border, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Reviews Coming Soon',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Patient reviews and ratings will be available here',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF2E7D32), size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOperatingHoursRows() {
    final schedule = widget.facility.operatingHours.schedule;
    final days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];

    return days.map((day) {
      final daySchedule = schedule[day];
      if (daySchedule == null) {
        return _buildInfoRow(
          Icons.schedule,
          day.substring(0, 1).toUpperCase() + day.substring(1),
          'Not specified',
        );
      }

      String hours;
      if (!daySchedule.isOpen) {
        hours = 'Closed';
      } else {
        hours =
            '${_formatTime(daySchedule.openTime)} - ${_formatTime(daySchedule.closeTime)}';
      }

      return _buildInfoRow(
        Icons.schedule,
        day.substring(0, 1).toUpperCase() + day.substring(1),
        hours,
      );
    }).toList();
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Widget _buildEquipmentStatus(
    String name,
    IconData icon,
    String status,
    bool isAvailable,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: isAvailable ? Colors.green : Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: 14,
              color: isAvailable ? Colors.green : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodBankSection() {
    return _buildSectionCard('Blood Bank', Icons.bloodtype, [
      if (widget.facility.bloodBank!.isOperational) ...[
        Text(
          'Available Blood Types',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        ...widget.facility.bloodBank!.bloodStock.entries.map((entry) {
          final bloodType = entry.value;
          Color statusColor;
          switch (bloodType.status) {
            case 'good':
              statusColor = Colors.green;
              break;
            case 'moderate':
              statusColor = Colors.orange;
              break;
            case 'low':
              statusColor = Colors.red;
              break;
            case 'critical':
              statusColor = Colors.red[800]!;
              break;
            default:
              statusColor = Colors.grey;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.red[300]!),
                  ),
                  child: Center(
                    child: Text(
                      bloodType.bloodType,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${bloodType.unitsAvailable} units',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    bloodType.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        if (widget.facility.bloodBank!.emergencyContact != null) ...[
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.emergency,
            'Emergency Contact',
            widget.facility.bloodBank!.emergencyContact!,
          ),
        ],
      ] else
        Text(
          'Blood bank currently not operational',
          style: TextStyle(
            fontSize: 14,
            color: Colors.red[600],
            fontStyle: FontStyle.italic,
          ),
        ),
    ]);
  }

  Widget _buildCostItem(
    String name,
    String category,
    String cost,
    bool isAvailable, {
    String? duration,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.grey[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isAvailable ? Colors.grey[200]! : Colors.red[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                cost,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isAvailable ? const Color(0xFF2E7D32) : Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  category,
                  style: TextStyle(fontSize: 10, color: Colors.blue[700]),
                ),
              ),
              if (duration != null) ...[
                const SizedBox(width: 8),
                Text(
                  duration,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
              const Spacer(),
              if (!isAvailable)
                Text(
                  'Not Available',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _makeCall() async {
    final Uri uri = Uri(scheme: 'tel', path: widget.facility.phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _openDirections() async {
    final Uri uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${widget.facility.latitude},${widget.facility.longitude}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _shareLocation() {
    // Implementation for sharing location
    print('Sharing location: ${widget.facility.name}');
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
