import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';
import '../models/medicine_inventory.dart';

class InventoryManagementScreen extends StatefulWidget {
  const InventoryManagementScreen({super.key});

  @override
  State<InventoryManagementScreen> createState() =>
      _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Inventory Management',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF2E7D32),
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: const Color(0xFF2E7D32),
          tabs: const [
            Tab(text: 'All Medicines', icon: Icon(Icons.medication)),
            Tab(text: 'Low Stock', icon: Icon(Icons.warning_amber)),
            Tab(text: 'Expiring', icon: Icon(Icons.schedule)),
            Tab(text: 'Analytics', icon: Icon(Icons.analytics)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => _showAddMedicineDialog(),
            icon: const Icon(Icons.add),
            tooltip: 'Add Medicine',
          ),
        ],
      ),
      body: Consumer<InventoryProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              _buildSearchAndFilters(provider),
              _buildStatsOverview(provider),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAllMedicinesTab(provider),
                    _buildLowStockTab(provider),
                    _buildExpiringTab(provider),
                    _buildAnalyticsTab(provider),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchAndFilters(InventoryProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search medicines, brands, or manufacturers...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            onChanged: provider.searchMedicines,
          ),

          const SizedBox(height: 12),

          // Filters
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: provider.selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items:
                      [
                            'All',
                            'Prescription',
                            'Over-the-counter',
                            'Supplement',
                            'Diabetic',
                            'Ayurvedic',
                            'Surgical',
                          ]
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                  onChanged: (value) => provider.filterByCategory(value!),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: DropdownButtonFormField<String>(
                  value: provider.sortBy,
                  decoration: InputDecoration(
                    labelText: 'Sort By',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'name', child: Text('Name')),
                    DropdownMenuItem(
                      value: 'stock',
                      child: Text('Stock Level'),
                    ),
                    DropdownMenuItem(
                      value: 'expiry',
                      child: Text('Expiry Date'),
                    ),
                    DropdownMenuItem(value: 'rating', child: Text('Rating')),
                  ],
                  onChanged: (value) => provider.sortMedicines(value!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsOverview(InventoryProvider provider) {
    final stats = provider.stats;

    return Container(
      margin: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: _buildStatCard(
                'Total Items',
                stats.totalMedicines.toString(),
                Icons.inventory_2,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 120,
              child: _buildStatCard(
                'Low Stock',
                stats.lowStockItems.toString(),
                Icons.warning,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 120,
              child: _buildStatCard(
                'Expiring',
                stats.expiringSoonItems.toString(),
                Icons.schedule,
                Colors.red,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 120,
              child: _buildStatCard(
                'Value',
                '₹${(stats.totalInventoryValue / 1000).toStringAsFixed(0)}K',
                Icons.account_balance_wallet,
                Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAllMedicinesTab(InventoryProvider provider) {
    if (provider.medicines.isEmpty) {
      return const Center(child: Text('No medicines found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.medicines.length,
      itemBuilder: (context, index) {
        final medicine = provider.medicines[index];
        return _buildMedicineCard(medicine, provider);
      },
    );
  }

  Widget _buildLowStockTab(InventoryProvider provider) {
    final lowStockMedicines = provider.lowStockMedicines;

    if (lowStockMedicines.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 64, color: Colors.green[300]),
            const SizedBox(height: 16),
            Text(
              'All medicines are well stocked!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: lowStockMedicines.length,
      itemBuilder: (context, index) {
        final medicine = lowStockMedicines[index];
        return _buildMedicineCard(medicine, provider, showLowStockAlert: true);
      },
    );
  }

  Widget _buildExpiringTab(InventoryProvider provider) {
    final expiringMedicines = provider.expiringSoonMedicines;

    if (expiringMedicines.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 64, color: Colors.green[300]),
            const SizedBox(height: 16),
            Text(
              'No medicines expiring soon!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: expiringMedicines.length,
      itemBuilder: (context, index) {
        final medicine = expiringMedicines[index];
        return _buildMedicineCard(medicine, provider, showExpiryAlert: true);
      },
    );
  }

  Widget _buildAnalyticsTab(InventoryProvider provider) {
    final stats = provider.stats;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Revenue Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[400]!, Colors.green[600]!],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Monthly Revenue',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${stats.monthlyRevenue.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '↗ 12% from last month',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Analytics Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildAnalyticsCard(
                'Total Inventory Value',
                '₹${stats.totalInventoryValue.toStringAsFixed(0)}',
                Icons.account_balance,
                Colors.blue,
              ),
              _buildAnalyticsCard(
                'Average Rating',
                stats.averageRating.toStringAsFixed(1),
                Icons.star,
                Colors.amber,
              ),
              _buildAnalyticsCard(
                'Medicine Categories',
                '8 Types',
                Icons.category,
                Colors.purple,
              ),
              _buildAnalyticsCard(
                'Top Rated Medicines',
                '${provider.medicines.where((m) => m.rating >= 4.5).length}',
                Icons.thumb_up,
                Colors.green,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Top Performing Medicines
          const Text(
            'Top Rated Medicines',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...provider.medicines
              .where((m) => m.rating >= 4.5)
              .take(3)
              .map(
                (medicine) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.star, color: Colors.amber),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              medicine.brandName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${medicine.rating} ★ (${medicine.reviewCount} reviews)',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${medicine.quantityInStock} units',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildMedicineCard(
    MedicineInventory medicine,
    InventoryProvider provider, {
    bool showLowStockAlert = false,
    bool showExpiryAlert = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: showLowStockAlert
              ? Colors.orange.withOpacity(0.3)
              : showExpiryAlert
              ? Colors.red.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alert indicator
            if (showLowStockAlert || showExpiryAlert)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: showLowStockAlert ? Colors.orange : Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      showLowStockAlert ? Icons.warning : Icons.schedule,
                      color: Colors.white,
                      size: 10,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      showLowStockAlert ? 'Low Stock' : 'Expiring',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            // Main content
            Row(
              children: [
                // Medicine icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(
                      medicine.category,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(medicine.category),
                    color: _getCategoryColor(medicine.category),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),

                // Medicine info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicine.brandName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${medicine.genericName} • ${medicine.strength}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Stock and price info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: medicine.isLowStock
                            ? Colors.red[50]
                            : Colors.green[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${medicine.quantityInStock} units',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: medicine.isLowStock
                              ? Colors.red[700]
                              : Colors.green[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      medicine.formattedSellingPrice,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 8),

                // Rating
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 10),
                      const SizedBox(width: 1),
                      Text(
                        medicine.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Action buttons row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showStockUpdateDialog(medicine, provider),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      side: BorderSide(color: Colors.blue[300]!),
                    ),
                    child: Text(
                      'Update',
                      style: TextStyle(fontSize: 11, color: Colors.blue[700]),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showMedicineDetailsDialog(medicine),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      side: BorderSide(color: Colors.green[300]!),
                    ),
                    child: Text(
                      'Details',
                      style: TextStyle(fontSize: 11, color: Colors.green[700]),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(MedicineCategory category) {
    switch (category) {
      case MedicineCategory.prescription:
        return Colors.red;
      case MedicineCategory.overTheCounter:
        return Colors.blue;
      case MedicineCategory.supplement:
        return Colors.green;
      case MedicineCategory.diabetic:
        return Colors.orange;
      case MedicineCategory.ayurvedic:
        return Colors.brown;
      case MedicineCategory.surgical:
        return Colors.purple;
      case MedicineCategory.babycare:
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(MedicineCategory category) {
    switch (category) {
      case MedicineCategory.prescription:
        return Icons.medical_services;
      case MedicineCategory.overTheCounter:
        return Icons.medication;
      case MedicineCategory.supplement:
        return Icons.local_pharmacy;
      case MedicineCategory.diabetic:
        return Icons.monitor_weight;
      case MedicineCategory.ayurvedic:
        return Icons.eco;
      case MedicineCategory.surgical:
        return Icons.healing;
      case MedicineCategory.babycare:
        return Icons.child_care;
      default:
        return Icons.medication;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showStockUpdateDialog(
    MedicineInventory medicine,
    InventoryProvider provider,
  ) {
    final stockController = TextEditingController(
      text: medicine.quantityInStock.toString(),
    );
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Stock: ${medicine.brandName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'New Stock Quantity',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for Update',
                hintText: 'e.g., New delivery, Sale, Expired',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newQuantity = int.tryParse(stockController.text);
              if (newQuantity != null && reasonController.text.isNotEmpty) {
                await provider.updateStock(
                  medicine.id,
                  newQuantity,
                  reasonController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Stock updated successfully')),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showMedicineDetailsDialog(MedicineInventory medicine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(medicine.brandName),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Generic Name', medicine.genericName),
              _buildDetailRow('Manufacturer', medicine.manufacturer),
              _buildDetailRow('Strength', medicine.strength),
              _buildDetailRow('Dosage Form', medicine.dosageForm),
              _buildDetailRow('Batch Number', medicine.batchNumber),
              _buildDetailRow(
                'Manufacturing Date',
                _formatDate(medicine.manufacturingDate),
              ),
              _buildDetailRow('Expiry Date', _formatDate(medicine.expiryDate)),
              _buildDetailRow('Cost Price', medicine.formattedCostPrice),
              _buildDetailRow('Selling Price', medicine.formattedSellingPrice),
              _buildDetailRow(
                'Profit Margin',
                '${medicine.profitMargin.toStringAsFixed(1)}%',
              ),
              _buildDetailRow(
                'Rating',
                '${medicine.rating} ★ (${medicine.reviewCount} reviews)',
              ),
              _buildDetailRow(
                'Rack Location',
                medicine.rackLocation ?? 'Not assigned',
              ),
              _buildDetailRow('Supplier', medicine.supplier ?? 'N/A'),
              if (medicine.alternativeBrands.isNotEmpty)
                _buildDetailRow(
                  'Alternative Brands',
                  medicine.alternativeBrands.join(', '),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showAddMedicineDialog() {
    // Implementation for adding new medicine
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Medicine dialog will be implemented')),
    );
  }
}
