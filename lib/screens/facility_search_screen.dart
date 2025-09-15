import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../generated/l10n/app_localizations.dart';
import '../models/medical_facility.dart';
import '../services/facility_service.dart';
import '../widgets/facility_card.dart';
import '../widgets/facility_map_view.dart';
import '../widgets/filter_bottom_sheet.dart';
import 'facility_detail_screen.dart';

class FacilitySearchScreen extends StatefulWidget {
  const FacilitySearchScreen({Key? key}) : super(key: key);

  @override
  State<FacilitySearchScreen> createState() => _FacilitySearchScreenState();
}

class _FacilitySearchScreenState extends State<FacilitySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FacilityService _facilityService = FacilityService();

  List<MedicalFacility> _facilities = [];
  List<MedicalFacility> _filteredFacilities = [];
  bool _isLoading = false;
  bool _isMapView = false;
  Position? _currentPosition;
  FacilitySearchFilter _currentFilter = FacilitySearchFilter();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _loadFacilities();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    try {
      // Check location permission
      final permission = await Permission.location.request();
      if (permission.isGranted) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _currentPosition = position;
        });
        _loadFacilities(); // Reload with location
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _loadFacilities() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final facilities = await _facilityService.searchFacilities(
        query: _searchQuery,
        latitude: _currentPosition?.latitude,
        longitude: _currentPosition?.longitude,
        filter: _currentFilter,
      );

      setState(() {
        _facilities = facilities;
        _filteredFacilities = facilities;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading facilities: $e')));
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
    _filterFacilities();
  }

  void _filterFacilities() {
    setState(() {
      _filteredFacilities = _facilities.where((facility) {
        final matchesSearch =
            _searchQuery.isEmpty ||
            facility.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            facility.specialties.any(
              (specialty) =>
                  specialty.toLowerCase().contains(_searchQuery.toLowerCase()),
            ) ||
            facility.address.toLowerCase().contains(_searchQuery.toLowerCase());

        final matchesType =
            _currentFilter.facilityType == null ||
            facility.type == _currentFilter.facilityType;

        final matchesSpecialties =
            _currentFilter.specialties.isEmpty ||
            _currentFilter.specialties.any(
              (specialty) => facility.specialties.contains(specialty),
            );

        final matchesOpenNow =
            !_currentFilter.onlyOpenNow || facility.operatingHours.isOpenNow();

        final matchesICU =
            !_currentFilter.hasICU || facility.equipment.icuStatus.isAvailable;

        final matchesVentilator =
            !_currentFilter.hasVentilator ||
            facility.equipment.ventilatorStatus.isAvailable;

        final matchesBloodBank =
            !_currentFilter.hasBloodBank ||
            (facility.bloodBank?.isOperational ?? false);

        final matchesEquipment =
            _currentFilter.diagnosticEquipment.isEmpty ||
            _currentFilter.diagnosticEquipment.every(
              (equipment) =>
                  facility
                      .equipment
                      .diagnosticEquipment[equipment]
                      ?.isAvailable ??
                  false,
            );

        return matchesSearch &&
            matchesType &&
            matchesSpecialties &&
            matchesOpenNow &&
            matchesICU &&
            matchesVentilator &&
            matchesBloodBank &&
            matchesEquipment;
      }).toList();

      // Sort facilities
      if (_currentFilter.sortBy != null && _currentPosition != null) {
        _filteredFacilities.sort((a, b) {
          switch (_currentFilter.sortBy) {
            case 'distance':
              final distanceA = Geolocator.distanceBetween(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                a.latitude,
                a.longitude,
              );
              final distanceB = Geolocator.distanceBetween(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                b.latitude,
                b.longitude,
              );
              return distanceA.compareTo(distanceB);
            case 'rating':
              return (b.rating ?? 0).compareTo(a.rating ?? 0);
            case 'availability':
              final availabilityA = _calculateAvailabilityScore(a);
              final availabilityB = _calculateAvailabilityScore(b);
              return availabilityB.compareTo(availabilityA);
            default:
              return 0;
          }
        });
      }
    });
  }

  double _calculateAvailabilityScore(MedicalFacility facility) {
    double score = 0;

    // Operating status
    if (facility.status.isOperational) score += 20;
    if (facility.status.acceptingPatients) score += 20;
    if (facility.operatingHours.isOpenNow()) score += 10;

    // Equipment availability
    if (facility.equipment.icuStatus.isAvailable) score += 15;
    if (facility.equipment.ventilatorStatus.isAvailable) score += 15;
    if (facility.equipment.oxygenStatus.isAvailable) score += 10;

    // Blood bank
    if (facility.bloodBank?.isOperational ?? false) score += 10;

    return score;
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        initialFilter: _currentFilter,
        onFilterApplied: (filter) {
          setState(() {
            _currentFilter = filter;
          });
          _filterFacilities();
        },
      ),
    );
  }

  void _toggleMapView() {
    setState(() {
      _isMapView = !_isMapView;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          l10n.findHospitalsLabs,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isMapView ? Icons.list : Icons.map,
              color: Colors.white,
            ),
            onPressed: _toggleMapView,
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar and Quick Filters
          Container(
            color: const Color(0xFF2E7D32),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search hospitals, clinics, labs...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Quick Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildQuickFilterChip(
                        'Hospitals',
                        Icons.local_hospital,
                        _currentFilter.facilityType == 'hospital',
                        () => _applyQuickFilter('hospital'),
                      ),
                      const SizedBox(width: 8),
                      _buildQuickFilterChip(
                        'Labs',
                        Icons.science,
                        _currentFilter.facilityType == 'lab',
                        () => _applyQuickFilter('lab'),
                      ),
                      const SizedBox(width: 8),
                      _buildQuickFilterChip(
                        'Open Now',
                        Icons.access_time,
                        _currentFilter.onlyOpenNow,
                        () => _toggleOpenNowFilter(),
                      ),
                      const SizedBox(width: 8),
                      _buildQuickFilterChip(
                        'ICU Available',
                        Icons.airline_seat_flat,
                        _currentFilter.hasICU,
                        () => _toggleICUFilter(),
                      ),
                      const SizedBox(width: 8),
                      _buildQuickFilterChip(
                        'Emergency',
                        Icons.emergency,
                        false,
                        () => _filterEmergencyFacilities(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Results Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredFacilities.length} facilities found',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                if (_currentPosition != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Near you',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF2E7D32),
                      ),
                    ),
                  )
                : _isMapView
                ? FacilityMapView(
                    facilities: _filteredFacilities,
                    currentPosition: _currentPosition,
                    onFacilityTap: _navigateToFacilityDetail,
                  )
                : _filteredFacilities.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredFacilities.length,
                    itemBuilder: (context, index) {
                      final facility = _filteredFacilities[index];
                      return FacilityCard(
                        facility: facility,
                        currentPosition: _currentPosition,
                        onTap: () => _navigateToFacilityDetail(facility),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilterChip(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No facilities found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentFilter = FacilitySearchFilter();
                _searchController.clear();
              });
              _filterFacilities();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Clear Filters',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _applyQuickFilter(String facilityType) {
    setState(() {
      if (_currentFilter.facilityType == facilityType) {
        _currentFilter = _currentFilter.copyWith(facilityType: null);
      } else {
        _currentFilter = _currentFilter.copyWith(facilityType: facilityType);
      }
    });
    _filterFacilities();
  }

  void _toggleOpenNowFilter() {
    setState(() {
      _currentFilter = _currentFilter.copyWith(
        onlyOpenNow: !_currentFilter.onlyOpenNow,
      );
    });
    _filterFacilities();
  }

  void _toggleICUFilter() {
    setState(() {
      _currentFilter = _currentFilter.copyWith(hasICU: !_currentFilter.hasICU);
    });
    _filterFacilities();
  }

  void _filterEmergencyFacilities() {
    setState(() {
      _currentFilter = _currentFilter.copyWith(
        onlyOpenNow: true,
        hasICU: true,
        hasVentilator: true,
      );
    });
    _filterFacilities();
  }

  void _navigateToFacilityDetail(MedicalFacility facility) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FacilityDetailScreen(facility: facility),
      ),
    );
  }
}
