import 'package:flutter/foundation.dart';
import '../models/medicine_inventory.dart';

class InventoryProvider with ChangeNotifier {
  List<MedicineInventory> _medicines = [];
  InventoryStats _stats = InventoryStats(
    totalMedicines: 0,
    lowStockItems: 0,
    expiringSoonItems: 0,
    expiredItems: 0,
    totalInventoryValue: 0.0,
    monthlyRevenue: 0.0,
    averageRating: 4.0,
  );

  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _sortBy = 'name'; // 'name', 'stock', 'expiry', 'rating'

  // Getters
  List<MedicineInventory> get medicines => _filteredMedicines;
  List<MedicineInventory> get _filteredMedicines {
    var filtered = _medicines;

    // Search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (medicine) =>
                medicine.medicineName.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                medicine.brandName.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                medicine.genericName.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                medicine.manufacturer.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    // Category filter
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where(
            (medicine) =>
                medicine.category.toString().split('.').last ==
                _selectedCategory.toLowerCase(),
          )
          .toList();
    }

    // Sort
    switch (_sortBy) {
      case 'stock':
        filtered.sort((a, b) => a.quantityInStock.compareTo(b.quantityInStock));
        break;
      case 'expiry':
        filtered.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
        break;
      case 'rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      default:
        filtered.sort((a, b) => a.medicineName.compareTo(b.medicineName));
    }

    return filtered;
  }

  InventoryStats get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get sortBy => _sortBy;

  List<MedicineInventory> get lowStockMedicines =>
      _medicines.where((m) => m.isLowStock).toList();
  List<MedicineInventory> get expiringSoonMedicines =>
      _medicines.where((m) => m.isExpiringSoon && !m.isExpired).toList();
  List<MedicineInventory> get expiredMedicines =>
      _medicines.where((m) => m.isExpired).toList();

  InventoryProvider() {
    _loadDemoData();
    // Force UI update after initialization
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  void _loadDemoData() {
    final now = DateTime.now();

    _medicines = [
      // Recently updated - high rating medicines
      MedicineInventory(
        id: 'med_001',
        medicineName: 'Paracetamol',
        brandName: 'Crocin',
        genericName: 'Paracetamol',
        manufacturer: 'GSK',
        strength: '500mg',
        dosageForm: 'Tablet',
        quantityInStock: 150,
        minStockLevel: 50,
        costPrice: 12.50,
        sellingPrice: 18.75,
        batchNumber: 'CR2024001',
        manufacturingDate: now.subtract(const Duration(days: 90)),
        expiryDate: now.add(const Duration(days: 640)),
        lastUpdated: now.subtract(const Duration(minutes: 15)),
        updatedBy: 'Pharmacy Manager',
        requiresPrescription: false,
        category: MedicineCategory.overTheCounter,
        rating: 4.8,
        reviewCount: 245,
        rackLocation: 'A-1-5',
        supplier: 'GSK Distributors',
        alternativeBrands: ['Dolo 650', 'Paracip'],
      ),

      MedicineInventory(
        id: 'med_002',
        medicineName: 'Amoxicillin',
        brandName: 'Amoxil',
        genericName: 'Amoxicillin',
        manufacturer: 'Ranbaxy',
        strength: '500mg',
        dosageForm: 'Capsule',
        quantityInStock: 75,
        minStockLevel: 30,
        costPrice: 85.00,
        sellingPrice: 125.00,
        batchNumber: 'RX2024002',
        manufacturingDate: now.subtract(const Duration(days: 45)),
        expiryDate: now.add(const Duration(days: 320)),
        lastUpdated: now.subtract(const Duration(hours: 2)),
        updatedBy: 'Staff Nurse',
        requiresPrescription: true,
        category: MedicineCategory.prescription,
        rating: 4.6,
        reviewCount: 89,
        rackLocation: 'B-2-3',
        supplier: 'Ranbaxy Medical',
        alternativeBrands: ['Augmentin', 'Clavam'],
      ),

      MedicineInventory(
        id: 'med_003',
        medicineName: 'Insulin Glargine',
        brandName: 'Lantus',
        genericName: 'Insulin Glargine',
        manufacturer: 'Sanofi',
        strength: '100 units/ml',
        dosageForm: 'Injection',
        quantityInStock: 12,
        minStockLevel: 15, // Low stock alert
        costPrice: 450.00,
        sellingPrice: 650.00,
        batchNumber: 'SF2024003',
        manufacturingDate: now.subtract(const Duration(days: 30)),
        expiryDate: now.add(const Duration(days: 180)), // Expiring in 6 months
        lastUpdated: now.subtract(const Duration(hours: 6)),
        updatedBy: 'Diabetic Specialist',
        requiresPrescription: true,
        category: MedicineCategory.diabetic,
        rating: 4.9,
        reviewCount: 156,
        rackLocation: 'C-1-1',
        supplier: 'Sanofi Direct',
        alternativeBrands: ['Basalog', 'Glaritus'],
        status: 'low_stock',
      ),

      MedicineInventory(
        id: 'med_004',
        medicineName: 'Multivitamin',
        brandName: 'Revital H',
        genericName: 'Multivitamin + Minerals',
        manufacturer: 'Ranbaxy',
        strength: '30 Tablets',
        dosageForm: 'Tablet',
        quantityInStock: 200,
        minStockLevel: 75,
        costPrice: 180.00,
        sellingPrice: 275.00,
        batchNumber: 'RV2024004',
        manufacturingDate: now.subtract(const Duration(days: 60)),
        expiryDate: now.add(const Duration(days: 450)),
        lastUpdated: now.subtract(const Duration(days: 1)),
        updatedBy: 'Stock Manager',
        requiresPrescription: false,
        category: MedicineCategory.supplement,
        rating: 4.4,
        reviewCount: 312,
        rackLocation: 'D-3-2',
        supplier: 'Health Plus Distributors',
        alternativeBrands: ['Centrum', 'Supradyn'],
      ),

      MedicineInventory(
        id: 'med_005',
        medicineName: 'Baby Paracetamol Syrup',
        brandName: 'Calpol',
        genericName: 'Paracetamol',
        manufacturer: 'GSK',
        strength: '120mg/5ml',
        dosageForm: 'Syrup',
        quantityInStock: 45,
        minStockLevel: 25,
        costPrice: 65.00,
        sellingPrice: 95.00,
        batchNumber: 'CP2024005',
        manufacturingDate: now.subtract(const Duration(days: 120)),
        expiryDate: now.add(const Duration(days: 240)),
        lastUpdated: now.subtract(const Duration(hours: 8)),
        updatedBy: 'Pediatric Specialist',
        requiresPrescription: false,
        category: MedicineCategory.babycare,
        rating: 4.7,
        reviewCount: 189,
        rackLocation: 'E-1-4',
        supplier: 'GSK Pharmaceuticals',
        alternativeBrands: ['Febrinil', 'Dolopar'],
      ),

      MedicineInventory(
        id: 'med_006',
        medicineName: 'Ashwagandha',
        brandName: 'Himalaya Ashwagandha',
        genericName: 'Withania Somnifera',
        manufacturer: 'Himalaya',
        strength: '60 Tablets',
        dosageForm: 'Tablet',
        quantityInStock: 80,
        minStockLevel: 40,
        costPrice: 120.00,
        sellingPrice: 185.00,
        batchNumber: 'HM2024006',
        manufacturingDate: now.subtract(const Duration(days: 75)),
        expiryDate: now.add(const Duration(days: 545)),
        lastUpdated: now.subtract(const Duration(hours: 12)),
        updatedBy: 'Ayurvedic Consultant',
        requiresPrescription: false,
        category: MedicineCategory.ayurvedic,
        rating: 4.3,
        reviewCount: 167,
        rackLocation: 'F-2-1',
        supplier: 'Himalaya Direct',
        alternativeBrands: ['Patanjali Ashwagandha', 'Baidyanath'],
      ),

      MedicineInventory(
        id: 'med_007',
        medicineName: 'Surgical Gloves',
        brandName: 'Nitrile Pro',
        genericName: 'Disposable Nitrile Gloves',
        manufacturer: 'MedTech',
        strength: 'Medium Size - 100 pieces',
        dosageForm: 'Gloves',
        quantityInStock: 25,
        minStockLevel: 30, // Low stock
        costPrice: 450.00,
        sellingPrice: 650.00,
        batchNumber: 'MT2024007',
        manufacturingDate: now.subtract(const Duration(days: 15)),
        expiryDate: now.add(const Duration(days: 1095)), // 3 years
        lastUpdated: now.subtract(const Duration(minutes: 30)),
        updatedBy: 'Medical Supplies',
        requiresPrescription: false,
        category: MedicineCategory.surgical,
        rating: 4.5,
        reviewCount: 78,
        rackLocation: 'G-1-2',
        supplier: 'MedTech Supplies',
        alternativeBrands: ['Latex Pro', 'SafeGuard'],
        status: 'low_stock',
      ),

      MedicineInventory(
        id: 'med_008',
        medicineName: 'Metformin',
        brandName: 'Glycomet',
        genericName: 'Metformin HCL',
        manufacturer: 'USV',
        strength: '500mg',
        dosageForm: 'Tablet',
        quantityInStock: 95,
        minStockLevel: 50,
        costPrice: 45.00,
        sellingPrice: 70.00,
        batchNumber: 'USV2024008',
        manufacturingDate: now.subtract(const Duration(days: 100)),
        expiryDate: now.add(const Duration(days: 365)),
        lastUpdated: now.subtract(const Duration(hours: 4)),
        updatedBy: 'Endocrinologist',
        requiresPrescription: true,
        category: MedicineCategory.diabetic,
        rating: 4.6,
        reviewCount: 203,
        rackLocation: 'C-2-4',
        supplier: 'USV Pharmaceuticals',
        alternativeBrands: ['Glucophage', 'Formet'],
      ),

      // Medicine with expiring soon status
      MedicineInventory(
        id: 'med_009',
        medicineName: 'Cough Syrup',
        brandName: 'Benadryl',
        genericName: 'Diphenhydramine',
        manufacturer: 'J&J',
        strength: '100ml',
        dosageForm: 'Syrup',
        quantityInStock: 35,
        minStockLevel: 20,
        costPrice: 85.00,
        sellingPrice: 125.00,
        batchNumber: 'JJ2023009',
        manufacturingDate: now.subtract(const Duration(days: 350)),
        expiryDate: now.add(const Duration(days: 25)), // Expiring soon
        lastUpdated: now.subtract(const Duration(days: 3)),
        updatedBy: 'Respiratory Specialist',
        requiresPrescription: false,
        category: MedicineCategory.overTheCounter,
        rating: 4.2,
        reviewCount: 134,
        rackLocation: 'A-3-1',
        supplier: 'Johnson & Johnson',
        alternativeBrands: ['Corex', 'Ascoril'],
      ),

      MedicineInventory(
        id: 'med_010',
        medicineName: 'Homeopathic Arnica',
        brandName: 'SBL Arnica',
        genericName: 'Arnica Montana',
        manufacturer: 'SBL',
        strength: '30CH - 25ml',
        dosageForm: 'Drops',
        quantityInStock: 60,
        minStockLevel: 25,
        costPrice: 75.00,
        sellingPrice: 115.00,
        batchNumber: 'SBL2024010',
        manufacturingDate: now.subtract(const Duration(days: 40)),
        expiryDate: now.add(const Duration(days: 1460)), // 4 years
        lastUpdated: now.subtract(const Duration(hours: 18)),
        updatedBy: 'Homeopathy Doctor',
        requiresPrescription: false,
        category: MedicineCategory.homeopathic,
        rating: 4.1,
        reviewCount: 92,
        rackLocation: 'H-1-3',
        supplier: 'SBL Homeopathy',
        alternativeBrands: ['Reckeweg', 'Schwabe'],
      ),
    ];

    _calculateStats();
    notifyListeners();
  }

  void _calculateStats() {
    _stats = InventoryStats(
      totalMedicines: _medicines.length,
      lowStockItems: _medicines.where((m) => m.isLowStock).length,
      expiringSoonItems: _medicines
          .where((m) => m.isExpiringSoon && !m.isExpired)
          .length,
      expiredItems: _medicines.where((m) => m.isExpired).length,
      totalInventoryValue: _medicines.fold(
        0.0,
        (sum, m) => sum + (m.sellingPrice * m.quantityInStock),
      ),
      monthlyRevenue: 45650.00, // Demo revenue
      averageRating:
          _medicines.fold(0.0, (sum, m) => sum + m.rating) / _medicines.length,
    );
  }

  // Actions
  void searchMedicines(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void sortMedicines(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  Future<void> addMedicine(MedicineInventory medicine) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _medicines.add(medicine);
      _calculateStats();
      _error = null;
    } catch (e) {
      _error = 'Failed to add medicine: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateMedicine(MedicineInventory medicine) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _medicines.indexWhere((m) => m.id == medicine.id);
      if (index != -1) {
        _medicines[index] = medicine;
        _calculateStats();
      }
      _error = null;
    } catch (e) {
      _error = 'Failed to update medicine: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteMedicine(String medicineId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      _medicines.removeWhere((m) => m.id == medicineId);
      _calculateStats();
      _error = null;
    } catch (e) {
      _error = 'Failed to delete medicine: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateStock(
    String medicineId,
    int newQuantity,
    String reason,
  ) async {
    try {
      final index = _medicines.indexWhere((m) => m.id == medicineId);
      if (index != -1) {
        final updatedMedicine = _medicines[index].copyWith(
          quantityInStock: newQuantity,
          lastUpdated: DateTime.now(),
          updatedBy: 'Stock Update - $reason',
        );
        _medicines[index] = updatedMedicine;
        _calculateStats();
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update stock: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
