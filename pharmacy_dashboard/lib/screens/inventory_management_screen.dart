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
    return Container(
      color: const Color(0xFFF8F9FA),
      child: Column(
        children: [
          // Header with tabs and add button
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
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
                // Title and add button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.inventory_2_rounded,
                          color: Color(0xFF10B981),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Inventory Management',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(
                            'Manage your medicine stock and inventory',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () => _showAddMedicineDialog(),
                        icon: const Icon(Icons.add, size: 20),
                        label: const Text('Add Medicine'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shadowColor: const Color(0xFF10B981).withOpacity(0.3),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Tabs
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: SizedBox(
                    height: 56,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey[600],
                      indicator: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 4,
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                      dividerColor: Colors.transparent,
                      labelPadding: EdgeInsets.zero,
                      tabs: [
                        Tab(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(height: 2),
                              Icon(Icons.medication_rounded, size: 18),
                              SizedBox(height: 1),
                              Text('All Medicines'),
                              SizedBox(height: 2),
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(height: 2),
                              Icon(Icons.warning_amber_rounded, size: 18),
                              SizedBox(height: 1),
                              Text('Low Stock'),
                              SizedBox(height: 2),
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(height: 2),
                              Icon(Icons.schedule_rounded, size: 18),
                              SizedBox(height: 1),
                              Text('Expiring'),
                              SizedBox(height: 2),
                            ],
                          ),
                        ),
                        Tab(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(height: 2),
                              Icon(Icons.analytics_rounded, size: 18),
                              SizedBox(height: 1),
                              Text('Analytics'),
                              SizedBox(height: 2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Consumer<InventoryProvider>(
              builder: (context, provider, child) {
                return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                        return [
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                _buildSearchAndFilters(provider),
                                _buildStatsOverview(provider),
                              ],
                            ),
                          ),
                        ];
                      },
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAllMedicinesTab(provider),
                      _buildLowStockTab(provider),
                      _buildExpiringTab(provider),
                      _buildAnalyticsTab(provider),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(InventoryProvider provider) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Enhanced search bar
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search medicines, brands, or manufacturers...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: Container(
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          provider.searchMedicines('');
                        },
                        icon: const Icon(Icons.clear_rounded, size: 18),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              onChanged: provider.searchMedicines,
            ),
          ),

          const SizedBox(height: 16),

          // Enhanced filters
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: provider.selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      labelStyle: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      prefixIcon: Icon(
                        Icons.category_rounded,
                        color: Color(0xFF10B981),
                        size: 18,
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
                                child: Text(
                                  category,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (value) => provider.filterByCategory(value!),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: provider.sortBy,
                    decoration: const InputDecoration(
                      labelText: 'Sort By',
                      labelStyle: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      prefixIcon: Icon(
                        Icons.sort_rounded,
                        color: Color(0xFF10B981),
                        size: 18,
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
              ),

              const SizedBox(width: 12),

              // Filter button
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF10B981).withOpacity(0.3),
                  ),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.tune_rounded,
                    color: Color(0xFF10B981),
                    size: 20,
                  ),
                  tooltip: 'More Filters',
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
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
        children: [
          _buildModernStatCard(
            'Total Items',
            stats.totalMedicines.toString(),
            Icons.inventory_2_rounded,
            const Color(0xFF3B82F6),
            '↗ 12%',
            true,
          ),
          _buildModernStatCard(
            'Low Stock',
            stats.lowStockItems.toString(),
            Icons.warning_amber_rounded,
            const Color(0xFFF59E0B),
            '↑ 3%',
            false,
          ),
          _buildModernStatCard(
            'Expiring',
            stats.expiringSoonItems.toString(),
            Icons.schedule_rounded,
            const Color(0xFFEF4444),
            '→ 0%',
            null,
          ),
          _buildModernStatCard(
            'Total Value',
            '₹${(stats.totalInventoryValue / 1000).toStringAsFixed(0)}K',
            Icons.account_balance_wallet_rounded,
            const Color(0xFF10B981),
            '↗ 8%',
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildModernStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String change,
    bool? isPositive,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive == null
                      ? Colors.grey[100]
                      : isPositive
                      ? Colors.green[50]
                      : Colors.red[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isPositive == null
                        ? Colors.grey[600]
                        : isPositive
                        ? Colors.green[600]
                        : Colors.red[600],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllMedicinesTab(InventoryProvider provider) {
    if (provider.medicines.isEmpty) {
      return const Center(child: Text('No medicines found'));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: provider.medicines.map((medicine) {
            return _buildMedicineCard(medicine, provider);
          }).toList(),
        ),
      ),
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

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: lowStockMedicines.map((medicine) {
            return _buildMedicineCard(
              medicine,
              provider,
              showLowStockAlert: true,
            );
          }).toList(),
        ),
      ),
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

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: expiringMedicines.map((medicine) {
            return _buildMedicineCard(
              medicine,
              provider,
              showExpiryAlert: true,
            );
          }).toList(),
        ),
      ),
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
      width: 280,
      margin: const EdgeInsets.only(right: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: showLowStockAlert
              ? Colors.orange.withOpacity(0.4)
              : showExpiryAlert
              ? Colors.red.withOpacity(0.4)
              : Colors.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with medicine icon and category
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getCategoryColor(medicine.category).withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(
                      medicine.category,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(medicine.category),
                    color: _getCategoryColor(medicine.category),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicine.brandName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        medicine.genericName,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Alert indicator
                if (showLowStockAlert || showExpiryAlert)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: showLowStockAlert ? Colors.orange : Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      showLowStockAlert ? Icons.warning : Icons.schedule,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),

          // Medicine details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Strength and form
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${medicine.strength} • ${medicine.dosageForm}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Stock and price info
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Stock',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: medicine.isLowStock
                                  ? Colors.red[50]
                                  : Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${medicine.quantityInStock} units',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: medicine.isLowStock
                                    ? Colors.red[700]
                                    : Colors.green[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            medicine.formattedSellingPrice,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Rating and manufacturer
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            medicine.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        medicine.manufacturer,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _showStockUpdateDialog(medicine, provider),
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Update'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[50],
                          foregroundColor: Colors.blue[700],
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.blue[200]!),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showMedicineDetailsDialog(medicine),
                        icon: const Icon(Icons.info_outline, size: 16),
                        label: const Text('Details'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[50],
                          foregroundColor: Colors.green[700],
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.green[200]!),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
