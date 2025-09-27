import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_theme_provider.dart';
import '../widgets/sidebar.dart';

class BulkReportsScreen extends StatefulWidget {
  const BulkReportsScreen({Key? key}) : super(key: key);

  @override
  State<BulkReportsScreen> createState() => _BulkReportsScreenState();
}

class _BulkReportsScreenState extends State<BulkReportsScreen> {
  String _selectedReportType = 'patients';

  final Map<String, String> _reportTypes = {
    'patients': 'Patient Reports',
    'doctors': 'Doctor Reports',
    'appointments': 'Appointment Reports',
    'community': 'Community Health Reports',
    'financial': 'Financial Reports',
    'inventory': 'Drug Inventory Reports',
    'custom': 'Custom Reports',
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.primaryBackgroundColor,
          body: Row(
            children: [
              const AdminSidebar(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: themeProvider.cardBackgroundColor,
                        border: Border(
                          bottom: BorderSide(
                            color: themeProvider.borderColor,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.analytics,
                            color: themeProvider.accentColor,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Bulk Reports',
                            style: TextStyle(
                              color: themeProvider.primaryTextColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          // Theme toggle
                          Row(
                            children: [
                              Icon(
                                Icons.light_mode,
                                color: themeProvider.secondaryTextColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Switch(
                                value: themeProvider.isDarkMode,
                                onChanged: (_) => themeProvider.toggleTheme(),
                                activeColor: themeProvider.accentColor,
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.dark_mode,
                                color: themeProvider.secondaryTextColor,
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Main Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Report Type Selection
                            Container(
                              width: 280,
                              decoration: BoxDecoration(
                                color: themeProvider.cardBackgroundColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: themeProvider.borderColor,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      'Report Categories',
                                      style: TextStyle(
                                        color: themeProvider.primaryTextColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const Divider(height: 1),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: _reportTypes.length,
                                      itemBuilder: (context, index) {
                                        final key =
                                            _reportTypes.keys.elementAt(index);
                                        final value = _reportTypes[key]!;
                                        final isSelected =
                                            _selectedReportType == key;

                                        return ListTile(
                                          leading: Icon(
                                            _getReportIcon(key),
                                            color: isSelected
                                                ? themeProvider.accentColor
                                                : themeProvider
                                                    .secondaryTextColor,
                                          ),
                                          title: Text(
                                            value,
                                            style: TextStyle(
                                              color: isSelected
                                                  ? themeProvider.accentColor
                                                  : themeProvider
                                                      .primaryTextColor,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                          selected: isSelected,
                                          selectedTileColor: themeProvider
                                              .accentColor
                                              .withOpacity(0.1),
                                          onTap: () {
                                            setState(() {
                                              _selectedReportType = key;
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 24),

                            // Report Content
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: themeProvider.cardBackgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: themeProvider.borderColor,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Report Header
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Row(
                                        children: [
                                          Icon(
                                            _getReportIcon(_selectedReportType),
                                            color: themeProvider.accentColor,
                                            size: 24,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            _reportTypes[_selectedReportType]!,
                                            style: TextStyle(
                                              color: themeProvider
                                                  .primaryTextColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Spacer(),
                                          ElevatedButton.icon(
                                            onPressed: () => _generateReport(),
                                            icon: const Icon(Icons.download),
                                            label:
                                                const Text('Generate Report'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  themeProvider.accentColor,
                                              foregroundColor: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(height: 1),

                                    // Report Configuration
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: _buildReportConfiguration(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getReportIcon(String type) {
    switch (type) {
      case 'patients':
        return Icons.people;
      case 'doctors':
        return Icons.local_hospital;
      case 'appointments':
        return Icons.calendar_month;
      case 'community':
        return Icons.public;
      case 'financial':
        return Icons.monetization_on;
      case 'inventory':
        return Icons.inventory;
      case 'custom':
        return Icons.tune;
      default:
        return Icons.description;
    }
  }

  Widget _buildReportConfiguration() {
    return Consumer<AdminThemeProvider>(
      builder: (context, themeProvider, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Range Selection
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start Date',
                          style: TextStyle(
                            color: themeProvider.primaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: themeProvider.borderColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: themeProvider.secondaryTextColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '21/08/2025',
                                style: TextStyle(
                                  color: themeProvider.primaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'End Date',
                          style: TextStyle(
                            color: themeProvider.primaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: themeProvider.borderColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: themeProvider.secondaryTextColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '21/09/2025',
                                style: TextStyle(
                                  color: themeProvider.primaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Report Format
              Text(
                'Report Format',
                style: TextStyle(
                  color: themeProvider.primaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildFormatOption('PDF', Icons.picture_as_pdf, true),
                  const SizedBox(width: 12),
                  _buildFormatOption('Excel', Icons.table_chart, false),
                  const SizedBox(width: 12),
                  _buildFormatOption('CSV', Icons.description, false),
                ],
              ),

              const SizedBox(height: 24),

              // Report Metrics
              Text(
                'Report Metrics',
                style: TextStyle(
                  color: themeProvider.primaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              ..._getReportMetrics(),

              const SizedBox(height: 32),

              // Preview
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: themeProvider.secondaryBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: themeProvider.borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.preview,
                          color: themeProvider.accentColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Report Preview',
                          style: TextStyle(
                            color: themeProvider.primaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This report will include data from 21/08/2025 to 21/09/2025 with the selected metrics.',
                      style: TextStyle(
                        color: themeProvider.secondaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormatOption(String format, IconData icon, bool isSelected) {
    return Consumer<AdminThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? themeProvider.accentColor.withOpacity(0.1)
                : themeProvider.secondaryBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? themeProvider.accentColor
                  : themeProvider.borderColor,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? themeProvider.accentColor
                    : themeProvider.secondaryTextColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                format,
                style: TextStyle(
                  color: isSelected
                      ? themeProvider.accentColor
                      : themeProvider.primaryTextColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _getReportMetrics() {
    final metrics = _getMetricsForReportType(_selectedReportType);
    return metrics
        .map((metric) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Consumer<AdminThemeProvider>(
                builder: (context, themeProvider, child) {
                  return CheckboxListTile(
                    value: true,
                    onChanged: (value) {},
                    title: Text(
                      metric,
                      style: TextStyle(
                        color: themeProvider.primaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                    activeColor: themeProvider.accentColor,
                    contentPadding: EdgeInsets.zero,
                  );
                },
              ),
            ))
        .toList();
  }

  List<String> _getMetricsForReportType(String type) {
    switch (type) {
      case 'patients':
        return [
          'Total Patient Count',
          'New Registrations',
          'Age Demographics',
          'Gender Distribution',
          'Medical History Summary',
          'Appointment Frequency',
        ];
      case 'doctors':
        return [
          'Doctor Count by Specialty',
          'Consultation Statistics',
          'Average Rating',
          'Availability Hours',
          'Patient Load',
          'Performance Metrics',
        ];
      case 'appointments':
        return [
          'Total Appointments',
          'Completed vs Cancelled',
          'Peak Hours Analysis',
          'Average Duration',
          'No-show Rate',
          'Rescheduling Patterns',
        ];
      case 'community':
        return [
          'Vaccination Coverage',
          'Disease Prevention Programs',
          'Health Screening Participation',
          'Emergency Response Times',
          'Community Health Index',
          'Public Health Initiatives',
        ];
      case 'financial':
        return [
          'Treatment Costs',
          'Government Subsidies',
          'Resource Allocation',
          'Budget Utilization',
          'Cost per Patient',
          'Funding Sources',
        ];
      case 'inventory':
        return [
          'Medicine Stock Levels',
          'Expiry Tracking',
          'Supply Chain Analysis',
          'Procurement Patterns',
          'Wastage Reports',
          'Distribution Metrics',
        ];
      case 'custom':
        return [
          'Custom Metric 1',
          'Custom Metric 2',
          'Custom Metric 3',
          'Data Export Options',
          'Advanced Filters',
          'Custom Date Ranges',
        ];
      default:
        return [];
    }
  }

  void _generateReport() {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Consumer<AdminThemeProvider>(
        builder: (context, themeProvider, child) {
          return AlertDialog(
            backgroundColor: themeProvider.cardBackgroundColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: themeProvider.accentColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'Generating ${_reportTypes[_selectedReportType]} Report...',
                  style: TextStyle(
                    color: themeProvider.primaryTextColor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    // Simulate report generation
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop();

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => Consumer<AdminThemeProvider>(
          builder: (context, themeProvider, child) {
            return AlertDialog(
              backgroundColor: themeProvider.cardBackgroundColor,
              title: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Report Generated',
                    style: TextStyle(
                      color: themeProvider.primaryTextColor,
                    ),
                  ),
                ],
              ),
              content: Text(
                'Your ${_reportTypes[_selectedReportType]} report has been generated successfully and is ready for download.',
                style: TextStyle(
                  color: themeProvider.secondaryTextColor,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: themeProvider.accentColor,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }
}
