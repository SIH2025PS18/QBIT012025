import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pharmacy.dart';
import '../providers/pharmacy_provider.dart';
import '../widgets/sidebar.dart';

class PharmacyManagementScreen extends StatefulWidget {
  const PharmacyManagementScreen({Key? key}) : super(key: key);

  @override
  State<PharmacyManagementScreen> createState() =>
      _PharmacyManagementScreenState();
}

class _PharmacyManagementScreenState extends State<PharmacyManagementScreen> {
  String _searchQuery = '';
  String _selectedState = 'All';
  bool _showVerifiedOnly = false;

  final List<String> _states = [
    'All',
    'Delhi',
    'Haryana',
    'Rajasthan',
    'Punjab',
    'Uttar Pradesh',
    'Maharashtra',
    'Karnataka',
    'Tamil Nadu',
    'West Bengal',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PharmacyProvider>(context, listen: false).loadPharmacies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: Row(
        children: [
          const AdminSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                _buildFilters(),
                Expanded(child: _buildPharmacyList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1D29),
        border: Border(bottom: BorderSide(color: Color(0xFF2A2D3A), width: 1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_pharmacy, color: Colors.white, size: 28),
          const SizedBox(width: 16),
          const Text(
            'Government Pharmacy Management',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () => _showAddPharmacyDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Add New Pharmacy'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B9D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF1A1D29),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search pharmacies by name, location, or license...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF2A2D3A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 150,
            child: DropdownButtonFormField<String>(
              value: _selectedState,
              onChanged: (value) => setState(() => _selectedState = value!),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF2A2D3A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              dropdownColor: const Color(0xFF2A2D3A),
              items: _states.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child:
                      Text(state, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              Checkbox(
                value: _showVerifiedOnly,
                onChanged: (value) =>
                    setState(() => _showVerifiedOnly = value!),
                fillColor: MaterialStateProperty.all(const Color(0xFFFF6B9D)),
              ),
              const Text(
                'Verified Only',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPharmacyList() {
    return Consumer<PharmacyProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF6B9D)),
          );
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error: ${provider.error}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.loadPharmacies(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final filteredPharmacies = _filterPharmacies(provider.pharmacies);

        if (filteredPharmacies.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_pharmacy, color: Colors.white54, size: 48),
                SizedBox(height: 16),
                Text(
                  'No pharmacies found',
                  style: TextStyle(color: Colors.white54, fontSize: 18),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredPharmacies.length,
          itemBuilder: (context, index) {
            return _buildPharmacyCard(filteredPharmacies[index]);
          },
        );
      },
    );
  }

  List<Pharmacy> _filterPharmacies(List<Pharmacy> pharmacies) {
    return pharmacies.where((pharmacy) {
      final matchesSearch = _searchQuery.isEmpty ||
          pharmacy.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          pharmacy.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          pharmacy.licenseNumber
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          pharmacy.city.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesState =
          _selectedState == 'All' || pharmacy.state == _selectedState;
      final matchesVerification = !_showVerifiedOnly || pharmacy.isVerified;

      return matchesSearch && matchesState && matchesVerification;
    }).toList();
  }

  Widget _buildPharmacyCard(Pharmacy pharmacy) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFF1A1D29),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B9D).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_pharmacy,
                    color: Color(0xFFFF6B9D),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              pharmacy.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _buildStatusChip(pharmacy),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Owner: ${pharmacy.ownerName}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(Icons.location_on,
                      '${pharmacy.address}, ${pharmacy.city}, ${pharmacy.state} - ${pharmacy.pincode}'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(Icons.phone, pharmacy.phone),
                ),
                Expanded(
                  child: _buildInfoItem(Icons.email, pharmacy.email),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                      Icons.badge, 'License: ${pharmacy.licenseNumber}'),
                ),
                Expanded(
                  child: _buildInfoItem(
                      Icons.access_time, pharmacy.operatingHours),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: pharmacy.services.map((service) {
                return Chip(
                  label: Text(
                    service,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: const Color(0xFF2A2D3A),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Rating: ${pharmacy.rating}/5.0',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(width: 16),
                Text(
                  'Orders: ${pharmacy.totalOrders}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const Spacer(),
                _buildActionButtons(pharmacy),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(Pharmacy pharmacy) {
    Color chipColor;
    String chipText;

    if (!pharmacy.isActive) {
      chipColor = Colors.red;
      chipText = 'Inactive';
    } else if (!pharmacy.isVerified) {
      chipColor = Colors.orange;
      chipText = 'Pending Verification';
    } else {
      chipColor = Colors.green;
      chipText = 'Verified';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor, width: 1),
      ),
      child: Text(
        chipText,
        style: TextStyle(
            color: chipColor, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Pharmacy pharmacy) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!pharmacy.isVerified)
          IconButton(
            onPressed: () => _toggleVerification(pharmacy),
            icon: const Icon(Icons.verified, color: Colors.green),
            tooltip: 'Verify Pharmacy',
          ),
        IconButton(
          onPressed: () => _editPharmacy(pharmacy),
          icon: const Icon(Icons.edit, color: Colors.blue),
          tooltip: 'Edit Pharmacy',
        ),
        IconButton(
          onPressed: () => _toggleStatus(pharmacy),
          icon: Icon(
            pharmacy.isActive ? Icons.block : Icons.check_circle,
            color: pharmacy.isActive ? Colors.red : Colors.green,
          ),
          tooltip: pharmacy.isActive ? 'Deactivate' : 'Activate',
        ),
        IconButton(
          onPressed: () => _deletePharmacy(pharmacy),
          icon: const Icon(Icons.delete, color: Colors.red),
          tooltip: 'Delete Pharmacy',
        ),
      ],
    );
  }

  void _showAddPharmacyDialog() {
    // TODO: Implement add pharmacy dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add Pharmacy feature will be implemented'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _editPharmacy(Pharmacy pharmacy) {
    // TODO: Implement edit pharmacy dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit ${pharmacy.name} feature will be implemented'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _toggleVerification(Pharmacy pharmacy) async {
    final provider = Provider.of<PharmacyProvider>(context, listen: false);
    final success =
        await provider.togglePharmacyVerification(pharmacy.id, true);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${pharmacy.name} has been verified'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to verify pharmacy'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _toggleStatus(Pharmacy pharmacy) async {
    final provider = Provider.of<PharmacyProvider>(context, listen: false);
    final success =
        await provider.togglePharmacyStatus(pharmacy.id, !pharmacy.isActive);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${pharmacy.name} status updated'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update pharmacy status'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deletePharmacy(Pharmacy pharmacy) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1D29),
        title: const Text('Delete Pharmacy',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete ${pharmacy.name}? This action cannot be undone.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final provider = Provider.of<PharmacyProvider>(context, listen: false);
      final success = await provider.deletePharmacy(pharmacy.id);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${pharmacy.name} has been deleted'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete pharmacy'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
