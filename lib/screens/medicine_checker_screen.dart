import 'package:flutter/material.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/medicine_stock.dart';
import '../models/pharmacy.dart';

class MedicineCheckerScreen extends StatefulWidget {
  const MedicineCheckerScreen({super.key});

  @override
  State<MedicineCheckerScreen> createState() => _MedicineCheckerScreenState();
}

class _MedicineCheckerScreenState extends State<MedicineCheckerScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  List<MedicineStock> _searchResults = [];
  bool _isOnline = true;

  // Mock data for demonstration
  final List<Pharmacy> _nearbyPharmacies = [
    Pharmacy(
      id: '1',
      name: 'Nabha Medical Store',
      licenseNumber: 'PHAR/2023/001',
      address: 'Main Bazaar, Near Bus Stand',
      city: 'Nabha',
      state: 'Punjab',
      pincode: '147201',
      latitude: 30.3782,
      longitude: 76.1374,
      isActive: true,
      createdAt: DateTime.now(),
    ),
    Pharmacy(
      id: '2',
      name: 'Sukhmani Pharmacy',
      licenseNumber: 'PHAR/2023/002',
      address: 'Civil Hospital Road',
      city: 'Nabha',
      state: 'Punjab',
      pincode: '147201',
      latitude: 30.3795,
      longitude: 76.1382,
      isActive: true,
      createdAt: DateTime.now(),
    ),
    Pharmacy(
      id: '3',
      name: 'City Chemist',
      licenseNumber: 'PHAR/2023/003',
      address: 'Market Chowk',
      city: 'Nabha',
      state: 'Punjab',
      pincode: '147201',
      latitude: 30.3771,
      longitude: 76.1368,
      isActive: true,
      createdAt: DateTime.now(),
    ),
  ];

  // Mock medicine data with expanded inventory
  final List<MedicineStock> _mockMedicines = [
    // Pain Relief & Fever
    MedicineStock(
      id: '1',
      pharmacyId: '1',
      medicineName: 'Paracetamol',
      brandName: 'Crocin',
      genericName: 'Paracetamol',
      manufacturer: 'GlaxoSmithKline',
      strength: '500mg',
      dosageForm: 'Tablet',
      quantityAvailable: 100,
      quantityReserved: 10,
      unitPrice: 12.50,
      lastUpdated: DateTime.now(),
      pharmacyName: 'Nabha Medical Store',
      pharmacyAddress: 'Main Bazaar, Near Bus Stand',
      distanceKm: 0.5,
      category: MedicineCategory.overTheCounter,
      requiresPrescription: false,
      expiryDate: DateTime.now().add(Duration(days: 365)),
      batchNumber: 'CR001234',
    ),
    MedicineStock(
      id: '2',
      pharmacyId: '1',
      medicineName: 'Ibuprofen',
      brandName: 'Brufen',
      genericName: 'Ibuprofen',
      manufacturer: 'Abbott',
      strength: '400mg',
      dosageForm: 'Tablet',
      quantityAvailable: 85,
      quantityReserved: 15,
      unitPrice: 25.00,
      lastUpdated: DateTime.now(),
      pharmacyName: 'Nabha Medical Store',
      pharmacyAddress: 'Main Bazaar, Near Bus Stand',
      distanceKm: 0.5,
      category: MedicineCategory.overTheCounter,
      requiresPrescription: false,
      expiryDate: DateTime.now().add(Duration(days: 300)),
      batchNumber: 'BF002345',
    ),
    MedicineStock(
      id: '3',
      pharmacyId: '2',
      medicineName: 'Paracetamol',
      brandName: 'Dolo 650',
      genericName: 'Paracetamol',
      manufacturer: 'Micro Labs',
      strength: '650mg',
      dosageForm: 'Tablet',
      quantityAvailable: 75,
      quantityReserved: 0,
      unitPrice: 15.00,
      lastUpdated: DateTime.now(),
      pharmacyName: 'Sukhmani Pharmacy',
      pharmacyAddress: 'Civil Hospital Road',
      distanceKm: 0.8,
      category: MedicineCategory.overTheCounter,
      requiresPrescription: false,
      expiryDate: DateTime.now().add(Duration(days: 400)),
      batchNumber: 'DL003456',
    ),
    MedicineStock(
      id: '4',
      pharmacyId: '3',
      medicineName: 'Aspirin',
      brandName: 'Disprin',
      genericName: 'Aspirin',
      manufacturer: 'Reckitt Benckiser',
      strength: '325mg',
      dosageForm: 'Tablet',
      quantityAvailable: 60,
      quantityReserved: 5,
      unitPrice: 18.75,
      lastUpdated: DateTime.now(),
      pharmacyName: 'City Chemist',
      pharmacyAddress: 'Market Chowk',
      distanceKm: 1.2,
      category: MedicineCategory.overTheCounter,
      requiresPrescription: false,
      expiryDate: DateTime.now().add(Duration(days: 250)),
      batchNumber: 'DP004567',
    ),

    // Antibiotics
    MedicineStock(
      id: '5',
      pharmacyId: '1',
      medicineName: 'Amoxicillin',
      brandName: 'Amoxil',
      genericName: 'Amoxicillin',
      manufacturer: 'GSK',
      strength: '250mg',
      dosageForm: 'Capsule',
      quantityAvailable: 50,
      quantityReserved: 5,
      unitPrice: 45.00,
      lastUpdated: DateTime.now(),
      pharmacyName: 'Nabha Medical Store',
      pharmacyAddress: 'Main Bazaar, Near Bus Stand',
      distanceKm: 0.5,
      category: MedicineCategory.prescription,
      requiresPrescription: true,
      expiryDate: DateTime.now().add(Duration(days: 180)),
      batchNumber: 'AM005678',
    ),
    MedicineStock(
      id: '6',
      pharmacyId: '2',
      medicineName: 'Azithromycin',
      brandName: 'Azithral',
      genericName: 'Azithromycin',
      manufacturer: 'Alembic',
      strength: '500mg',
      dosageForm: 'Tablet',
      quantityAvailable: 30,
      quantityReserved: 3,
      unitPrice: 120.00,
      lastUpdated: DateTime.now(),
      pharmacyName: 'Sukhmani Pharmacy',
      pharmacyAddress: 'Civil Hospital Road',
      distanceKm: 0.8,
      category: MedicineCategory.prescription,
      requiresPrescription: true,
      expiryDate: DateTime.now().add(Duration(days: 220)),
      batchNumber: 'AZ006789',
    ),
    MedicineStock(
      id: '7',
      pharmacyId: '3',
      medicineName: 'Ciprofloxacin',
      brandName: 'Cipro',
      genericName: 'Ciprofloxacin',
      manufacturer: 'Ranbaxy',
      strength: '500mg',
      dosageForm: 'Tablet',
      quantityAvailable: 40,
      quantityReserved: 8,
      unitPrice: 85.50,
      lastUpdated: DateTime.now(),
      pharmacyName: 'City Chemist',
      pharmacyAddress: 'Market Chowk',
      distanceKm: 1.2,
      category: MedicineCategory.prescription,
      requiresPrescription: true,
      expiryDate: DateTime.now().add(Duration(days: 160)),
      batchNumber: 'CP007890',
    ),

    // Allergy & Cold
    MedicineStock(
      id: '8',
      pharmacyId: '1',
      medicineName: 'Cetirizine',
      brandName: 'Cetzine',
      genericName: 'Cetirizine',
      manufacturer: 'Dr. Reddy\'s',
      strength: '10mg',
      dosageForm: 'Tablet',
      quantityAvailable: 30,
      quantityReserved: 5,
      unitPrice: 22.50,
      lastUpdated: DateTime.now(),
      pharmacyName: 'Nabha Medical Store',
      pharmacyAddress: 'Main Bazaar, Near Bus Stand',
      distanceKm: 0.5,
      category: MedicineCategory.overTheCounter,
      requiresPrescription: false,
      expiryDate: DateTime.now().add(Duration(days: 340)),
      batchNumber: 'CT008901',
    ),
    MedicineStock(
      id: '9',
      pharmacyId: '2',
      medicineName: 'Loratadine',
      brandName: 'Lorinol',
      genericName: 'Loratadine',
      manufacturer: 'Cipla',
      strength: '10mg',
      dosageForm: 'Tablet',
      quantityAvailable: 45,
      quantityReserved: 0,
      unitPrice: 28.00,
      lastUpdated: DateTime.now(),
      pharmacyName: 'Sukhmani Pharmacy',
      pharmacyAddress: 'Civil Hospital Road',
      distanceKm: 0.8,
      category: MedicineCategory.overTheCounter,
      requiresPrescription: false,
      expiryDate: DateTime.now().add(Duration(days: 280)),
      batchNumber: 'LR009012',
    ),
    MedicineStock(
      id: '10',
      pharmacyId: '3',
      medicineName: 'Phenylephrine',
      brandName: 'D-Cold',
      genericName: 'Phenylephrine + Paracetamol',
      manufacturer: 'Paras Pharma',
      strength: '5mg + 325mg',
      dosageForm: 'Tablet',
      quantityAvailable: 55,
      quantityReserved: 10,
      unitPrice: 35.75,
      lastUpdated: DateTime.now(),
      pharmacyName: 'City Chemist',
      pharmacyAddress: 'Market Chowk',
      distanceKm: 1.2,
      category: MedicineCategory.overTheCounter,
      requiresPrescription: false,
      expiryDate: DateTime.now().add(Duration(days: 200)),
      batchNumber: 'DC010123',
    ),

    // Digestive Health
    MedicineStock(
      id: '11',
      pharmacyId: '1',
      medicineName: 'Omeprazole',
      brandName: 'Omez',
      genericName: 'Omeprazole',
      manufacturer: 'Dr. Reddy\'s',
      strength: '20mg',
      dosageForm: 'Capsule',
      quantityAvailable: 70,
      quantityReserved: 12,
      unitPrice: 68.50,
      lastUpdated: DateTime.now(),
      pharmacyName: 'Nabha Medical Store',
      pharmacyAddress: 'Main Bazaar, Near Bus Stand',
      distanceKm: 0.5,
      category: MedicineCategory.overTheCounter,
      requiresPrescription: false,
      expiryDate: DateTime.now().add(Duration(days: 320)),
      batchNumber: 'OM011234',
    ),
    MedicineStock(
      id: '12',
      pharmacyId: '2',
      medicineName: 'Ranitidine',
      brandName: 'Rantac',
      genericName: 'Ranitidine',
      manufacturer: 'J&J',
      strength: '150mg',
      dosageForm: 'Tablet',
      quantityAvailable: 35,
      quantityReserved: 7,
      unitPrice: 42.25,
      lastUpdated: DateTime.now(),
      pharmacyName: 'Sukhmani Pharmacy',
      pharmacyAddress: 'Civil Hospital Road',
      distanceKm: 0.8,
      category: MedicineCategory.overTheCounter,
      requiresPrescription: false,
      expiryDate: DateTime.now().add(Duration(days: 260)),
      batchNumber: 'RT012345',
    ),
    MedicineStock(
      id: '13',
      pharmacyId: '3',
      medicineName: 'Loperamide',
      brandName: 'Lopamide',
      genericName: 'Loperamide',
      manufacturer: 'Sun Pharma',
      strength: '2mg',
      dosageForm: 'Tablet',
      quantityAvailable: 25,
      quantityReserved: 3,
      unitPrice: 55.00,
      lastUpdated: DateTime.now(),
      pharmacyName: 'City Chemist',
      pharmacyAddress: 'Market Chowk',
      distanceKm: 1.2,
      category: MedicineCategory.overTheCounter,
      requiresPrescription: false,
      expiryDate: DateTime.now().add(Duration(days: 150)),
      batchNumber: 'LP013456',
    ),

    // Vitamins & Supplements
    MedicineStock(
      id: '14',
      pharmacyId: '1',
      medicineName: 'Vitamin D3',
      brandName: 'Calcirol',
      genericName: 'Cholecalciferol',
      manufacturer: 'Cadila',
      strength: '60000 IU',
      dosageForm: 'Sachet',
      quantityAvailable: 80,
      quantityReserved: 5,
      unitPrice: 125.00,
      lastUpdated: DateTime.now(),
      pharmacyName: 'Nabha Medical Store',
      pharmacyAddress: 'Main Bazaar, Near Bus Stand',
      distanceKm: 0.5,
      category: MedicineCategory.supplement,
      requiresPrescription: false,
      expiryDate: DateTime.now().add(Duration(days: 450)),
      batchNumber: 'VD014567',
    ),
    MedicineStock(
      id: '15',
      pharmacyId: '2',
      medicineName: 'Multivitamin',
      brandName: 'Revital',
      genericName: 'Multivitamin + Minerals',
      manufacturer: 'Ranbaxy',
      strength: '30 tablets',
      dosageForm: 'Tablet',
      quantityAvailable: 65,
      quantityReserved: 8,
      unitPrice: 295.00,
      lastUpdated: DateTime.now(),
      pharmacyName: 'Sukhmani Pharmacy',
      pharmacyAddress: 'Civil Hospital Road',
      distanceKm: 0.8,
      category: MedicineCategory.supplement,
      requiresPrescription: false,
      expiryDate: DateTime.now().add(Duration(days: 380)),
      batchNumber: 'MV015678',
    ),
    MedicineStock(
      id: '16',
      pharmacyId: '3',
      medicineName: 'Calcium Carbonate',
      brandName: 'Shelcal',
      genericName: 'Calcium Carbonate + Vitamin D3',
      manufacturer: 'Torrent',
      strength: '500mg + 250 IU',
      dosageForm: 'Tablet',
      quantityAvailable: 90,
      quantityReserved: 15,
      unitPrice: 180.50,
      lastUpdated: DateTime.now(),
      pharmacyName: 'City Chemist',
      pharmacyAddress: 'Market Chowk',
      distanceKm: 1.2,
      category: MedicineCategory.supplement,
      requiresPrescription: false,
      expiryDate: DateTime.now().add(Duration(days: 420)),
      batchNumber: 'SH016789',
    ),

    // Diabetes
    MedicineStock(
      id: '17',
      pharmacyId: '1',
      medicineName: 'Metformin',
      brandName: 'Glycomet',
      genericName: 'Metformin',
      manufacturer: 'USV',
      strength: '500mg',
      dosageForm: 'Tablet',
      quantityAvailable: 95,
      quantityReserved: 20,
      unitPrice: 85.00,
      lastUpdated: DateTime.now(),
      pharmacyName: 'Nabha Medical Store',
      pharmacyAddress: 'Main Bazaar, Near Bus Stand',
      distanceKm: 0.5,
      category: MedicineCategory.prescription,
      requiresPrescription: true,
      expiryDate: DateTime.now().add(Duration(days: 300)),
      batchNumber: 'GL017890',
    ),
    MedicineStock(
      id: '18',
      pharmacyId: '2',
      medicineName: 'Glimepiride',
      brandName: 'Amaryl',
      genericName: 'Glimepiride',
      manufacturer: 'Sanofi',
      strength: '2mg',
      dosageForm: 'Tablet',
      quantityAvailable: 40,
      quantityReserved: 8,
      unitPrice: 195.50,
      lastUpdated: DateTime.now(),
      pharmacyName: 'Sukhmani Pharmacy',
      pharmacyAddress: 'Civil Hospital Road',
      distanceKm: 0.8,
      category: MedicineCategory.prescription,
      requiresPrescription: true,
      expiryDate: DateTime.now().add(Duration(days: 240)),
      batchNumber: 'AM018901',
    ),

    // Heart & Blood Pressure
    MedicineStock(
      id: '19',
      pharmacyId: '3',
      medicineName: 'Amlodipine',
      brandName: 'Amlodac',
      genericName: 'Amlodipine',
      manufacturer: 'Zydus Cadila',
      strength: '5mg',
      dosageForm: 'Tablet',
      quantityAvailable: 75,
      quantityReserved: 12,
      unitPrice: 125.75,
      lastUpdated: DateTime.now(),
      pharmacyName: 'City Chemist',
      pharmacyAddress: 'Market Chowk',
      distanceKm: 1.2,
      category: MedicineCategory.prescription,
      requiresPrescription: true,
      expiryDate: DateTime.now().add(Duration(days: 270)),
      batchNumber: 'AD019012',
    ),
    MedicineStock(
      id: '20',
      pharmacyId: '1',
      medicineName: 'Atorvastatin',
      brandName: 'Atorlip',
      genericName: 'Atorvastatin',
      manufacturer: 'Cipla',
      strength: '20mg',
      dosageForm: 'Tablet',
      quantityAvailable: 60,
      quantityReserved: 10,
      unitPrice: 145.25,
      lastUpdated: DateTime.now(),
      pharmacyName: 'Nabha Medical Store',
      pharmacyAddress: 'Main Bazaar, Near Bus Stand',
      distanceKm: 0.5,
      category: MedicineCategory.prescription,
      requiresPrescription: true,
      expiryDate: DateTime.now().add(Duration(days: 290)),
      batchNumber: 'AT020123',
    ),
  ];

  // Medicine suggestions for common conditions
  final List<String> _commonMedicineSearches = [
    'Paracetamol',
    'Fever medicine',
    'Cold medicine',
    'Cough syrup',
    'Headache relief',
    'Stomach pain',
    'Vitamin D',
    'Calcium',
    'Blood pressure',
    'Diabetes medicine',
    'Allergy medicine',
    'Antibiotic',
    'Pain relief',
    'Indigestion',
  ];

  final List<Map<String, dynamic>> _medicineSuggestions = [
    {
      'condition': 'Fever & Body Pain',
      'medicines': ['Paracetamol', 'Ibuprofen', 'Aspirin'],
      'icon': Icons.thermostat,
      'color': Colors.red,
    },
    {
      'condition': 'Cold & Cough',
      'medicines': ['Phenylephrine', 'Cetirizine', 'Loratadine'],
      'icon': Icons.masks,
      'color': Colors.blue,
    },
    {
      'condition': 'Stomach Issues',
      'medicines': ['Omeprazole', 'Ranitidine', 'Loperamide'],
      'icon': Icons.restaurant,
      'color': Colors.green,
    },
    {
      'condition': 'Allergies',
      'medicines': ['Cetirizine', 'Loratadine', 'Montelukast'],
      'icon': Icons.healing,
      'color': Colors.purple,
    },
    {
      'condition': 'Vitamins & Health',
      'medicines': ['Vitamin D3', 'Multivitamin', 'Calcium'],
      'icon': Icons.favorite,
      'color': Colors.orange,
    },
    {
      'condition': 'Chronic Conditions',
      'medicines': ['Metformin', 'Amlodipine', 'Atorvastatin'],
      'icon': Icons.medical_services,
      'color': Colors.teal,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchMedicine() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _searchQuery = query;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Filter mock data based on search query
    final results = _mockMedicines
        .where(
          (medicine) =>
              medicine.medicineName.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              (medicine.brandName?.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ??
                  false) ||
              (medicine.genericName?.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ??
                  false),
        )
        .toList();

    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Medicine Availability',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          // Network status indicator
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _isOnline ? Colors.green[100] : Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _isOnline ? Icons.wifi : Icons.wifi_off,
                    size: 16,
                    color: _isOnline ? Colors.green[700] : Colors.orange[700],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _isOnline ? Colors.green[700] : Colors.orange[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for medicine...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchResults.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  onSubmitted: (_) => _searchMedicine(),
                  onChanged: (value) {
                    // Clear results when text is cleared
                    if (value.isEmpty) {
                      setState(() {
                        _searchResults.clear();
                        _searchQuery = '';
                      });
                    }
                  },
                ),
              ),
            ),

            // Search button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: _searchMedicine,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Search Medicine',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Results or empty state
            Expanded(
              child: _isSearching
                  ? const Center(child: CircularProgressIndicator())
                  : _searchResults.isEmpty && _searchQuery.isNotEmpty
                  ? _buildEmptyState()
                  : _searchResults.isEmpty
                  ? _buildWelcomeMessage()
                  : _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          Center(
            child: Column(
              children: [
                Icon(Icons.medication, size: 80, color: Colors.blue[300]),
                const SizedBox(height: 24),
                const Text(
                  'Find Medicine Availability',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Search for any medicine to see availability in pharmacies near you',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Medicine suggestions section
          const Text(
            'Common Medicine Categories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Suggestion cards grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _medicineSuggestions.length,
            itemBuilder: (context, index) {
              final suggestion = _medicineSuggestions[index];
              return _buildSuggestionCard(suggestion);
            },
          ),

          const SizedBox(height: 32),

          // Quick search chips
          const Text(
            'Quick Searches',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _commonMedicineSearches.map((search) {
              return ActionChip(
                label: Text(search),
                onPressed: () {
                  _searchController.text = search;
                  _searchMedicine();
                },
                backgroundColor: Colors.blue[50],
                labelStyle: TextStyle(color: Colors.blue[700]),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(Map<String, dynamic> suggestion) {
    return GestureDetector(
      onTap: () {
        // Show medicine options for this category
        _showCategoryMedicines(suggestion);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (suggestion['color'] as Color).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  suggestion['icon'],
                  size: 32,
                  color: suggestion['color'],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                suggestion['condition'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${(suggestion['medicines'] as List).length} medicines',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoryMedicines(Map<String, dynamic> suggestion) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (suggestion['color'] as Color).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        suggestion['icon'],
                        color: suggestion['color'],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            suggestion['condition'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Recommended medicines',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Medicine list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: (suggestion['medicines'] as List).length,
                  itemBuilder: (context, index) {
                    final medicineName = suggestion['medicines'][index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: (suggestion['color'] as Color)
                              .withOpacity(0.1),
                          child: Icon(
                            Icons.medication,
                            color: suggestion['color'],
                            size: 20,
                          ),
                        ),
                        title: Text(
                          medicineName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text('Tap to search availability'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.pop(context);
                          _searchController.text = medicineName;
                          _searchMedicine();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            const Text(
              'No Results Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'We couldn\'t find any medicine matching "$_searchQuery" in nearby pharmacies',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchResults.clear();
                  _searchQuery = '';
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 45),
              ),
              child: Text(AppLocalizations.of(context)!.clearSearch),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    // Group results by medicine name
    final groupedResults = <String, List<MedicineStock>>{};
    for (final medicine in _searchResults) {
      final key = medicine.medicineName;
      if (!groupedResults.containsKey(key)) {
        groupedResults[key] = [];
      }
      groupedResults[key]!.add(medicine);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Found ${_searchResults.length} results for "$_searchQuery"',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ...groupedResults.entries.map((entry) {
            return _buildMedicineGroup(entry.key, entry.value);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMedicineGroup(
    String medicineName,
    List<MedicineStock> medicines,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Medicine header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.medication, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicineName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${medicines.length} pharmacies have this medicine',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Pharmacy list
          ...medicines.map((medicine) {
            return _buildPharmacyItem(medicine);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPharmacyItem(MedicineStock medicine) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.pharmacyName ?? 'Pharmacy',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      medicine.pharmacyAddress ?? 'Address not available',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${medicine.distanceKm?.toStringAsFixed(1) ?? '0'} km away',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStockStatusColor(medicine.stockStatus),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStockStatusText(medicine.stockStatus),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    medicine.formattedPrice,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    '${medicine.availableQuantity} units',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Strength',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    medicine.strength ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Show directions to pharmacy
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Opening directions to ${medicine.pharmacyName}',
                        ),
                      ),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.directions),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Reserve medicine
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Reserved ${medicine.displayName} at ${medicine.pharmacyName}',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Text(AppLocalizations.of(context)!.reserve),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStockStatusColor(StockStatus status) {
    switch (status) {
      case StockStatus.inStock:
        return Colors.green;
      case StockStatus.lowStock:
        return Colors.orange;
      case StockStatus.outOfStock:
        return Colors.red;
      case StockStatus.expiringSoon:
        return Colors.amber;
      case StockStatus.expired:
        return Colors.grey;
    }
  }

  String _getStockStatusText(StockStatus status) {
    switch (status) {
      case StockStatus.inStock:
        return 'In Stock';
      case StockStatus.lowStock:
        return 'Low Stock';
      case StockStatus.outOfStock:
        return 'Out of Stock';
      case StockStatus.expiringSoon:
        return 'Expiring Soon';
      case StockStatus.expired:
        return 'Expired';
    }
  }
}
