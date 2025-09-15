import 'package:flutter/material.dart';
import '../models/medical_facility.dart';

class FilterBottomSheet extends StatefulWidget {
  final FacilitySearchFilter initialFilter;
  final Function(FacilitySearchFilter) onFilterApplied;

  const FilterBottomSheet({
    Key? key,
    required this.initialFilter,
    required this.onFilterApplied,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late FacilitySearchFilter _filter;

  @override
  void initState() {
    super.initState();
    _filter = FacilitySearchFilter(
      facilityType: widget.initialFilter.facilityType,
      specialties: List.from(widget.initialFilter.specialties),
      maxDistance: widget.initialFilter.maxDistance,
      onlyOpenNow: widget.initialFilter.onlyOpenNow,
      hasICU: widget.initialFilter.hasICU,
      hasVentilator: widget.initialFilter.hasVentilator,
      hasBloodBank: widget.initialFilter.hasBloodBank,
      diagnosticEquipment: List.from(widget.initialFilter.diagnosticEquipment),
      sortBy: widget.initialFilter.sortBy,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Facilities',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _clearFilters,
                  child: const Text(
                    'Clear All',
                    style: TextStyle(color: Color(0xFF2E7D32)),
                  ),
                ),
              ],
            ),
          ),

          // Filter content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Facility Type
                  _buildSectionTitle('Facility Type'),
                  _buildFacilityTypeSelector(),
                  const SizedBox(height: 20),

                  // Distance
                  _buildSectionTitle('Maximum Distance'),
                  _buildDistanceSlider(),
                  const SizedBox(height: 20),

                  // Quick Filters
                  _buildSectionTitle('Quick Filters'),
                  _buildQuickFilters(),
                  const SizedBox(height: 20),

                  // Specialties
                  _buildSectionTitle('Specialties'),
                  _buildSpecialtiesSelector(),
                  const SizedBox(height: 20),

                  // Diagnostic Equipment
                  _buildSectionTitle('Required Equipment'),
                  _buildEquipmentSelector(),
                  const SizedBox(height: 20),

                  // Sort By
                  _buildSectionTitle('Sort By'),
                  _buildSortBySelector(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Apply button
          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onFilterApplied(_filter);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildFacilityTypeSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: FacilityConstants.facilityTypes.map((type) {
        final isSelected = _filter.facilityType == type;
        return GestureDetector(
          onTap: () {
            setState(() {
              _filter = _filter.copyWith(
                facilityType: isSelected ? null : type,
              );
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[300]!,
              ),
            ),
            child: Text(
              type.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDistanceSlider() {
    return Column(
      children: [
        Slider(
          value: _filter.maxDistance,
          min: 1.0,
          max: 100.0,
          divisions: 99,
          activeColor: const Color(0xFF2E7D32),
          label: '${_filter.maxDistance.round()} km',
          onChanged: (value) {
            setState(() {
              _filter = _filter.copyWith(maxDistance: value);
            });
          },
        ),
        Text(
          'Within ${_filter.maxDistance.round()} km',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildQuickFilters() {
    return Column(
      children: [
        _buildFilterTile(
          'Open now',
          'Show only facilities currently open',
          _filter.onlyOpenNow,
          (value) {
            setState(() {
              _filter = _filter.copyWith(onlyOpenNow: value);
            });
          },
        ),
        _buildFilterTile(
          'ICU beds available',
          'Show facilities with available ICU beds',
          _filter.hasICU,
          (value) {
            setState(() {
              _filter = _filter.copyWith(hasICU: value);
            });
          },
        ),
        _buildFilterTile(
          'Ventilators available',
          'Show facilities with available ventilators',
          _filter.hasVentilator,
          (value) {
            setState(() {
              _filter = _filter.copyWith(hasVentilator: value);
            });
          },
        ),
        _buildFilterTile(
          'Blood bank available',
          'Show facilities with operational blood banks',
          _filter.hasBloodBank,
          (value) {
            setState(() {
              _filter = _filter.copyWith(hasBloodBank: value);
            });
          },
        ),
      ],
    );
  }

  Widget _buildFilterTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      trailing: Switch(
        value: value,
        activeColor: const Color(0xFF2E7D32),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSpecialtiesSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: FacilityConstants.specialties.map((specialty) {
        final isSelected = _filter.specialties.contains(specialty);
        return GestureDetector(
          onTap: () {
            setState(() {
              final specialties = List<String>.from(_filter.specialties);
              if (isSelected) {
                specialties.remove(specialty);
              } else {
                specialties.add(specialty);
              }
              _filter = _filter.copyWith(specialties: specialties);
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF2E7D32).withOpacity(0.1)
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[300]!,
              ),
            ),
            child: Text(
              specialty,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[700],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEquipmentSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: FacilityConstants.diagnosticEquipment.map((equipment) {
        final isSelected = _filter.diagnosticEquipment.contains(equipment);
        return GestureDetector(
          onTap: () {
            setState(() {
              final equipmentList = List<String>.from(
                _filter.diagnosticEquipment,
              );
              if (isSelected) {
                equipmentList.remove(equipment);
              } else {
                equipmentList.add(equipment);
              }
              _filter = _filter.copyWith(diagnosticEquipment: equipmentList);
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF2E7D32).withOpacity(0.1)
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[300]!,
              ),
            ),
            child: Text(
              equipment,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[700],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSortBySelector() {
    final sortOptions = [
      {'value': 'distance', 'label': 'Distance'},
      {'value': 'rating', 'label': 'Rating'},
      {'value': 'availability', 'label': 'Availability'},
    ];

    return Column(
      children: sortOptions.map((option) {
        return RadioListTile<String>(
          contentPadding: EdgeInsets.zero,
          title: Text(option['label']!, style: const TextStyle(fontSize: 14)),
          value: option['value']!,
          groupValue: _filter.sortBy,
          activeColor: const Color(0xFF2E7D32),
          onChanged: (value) {
            setState(() {
              _filter = _filter.copyWith(sortBy: value);
            });
          },
        );
      }).toList(),
    );
  }

  void _clearFilters() {
    setState(() {
      _filter = FacilitySearchFilter();
    });
  }
}
