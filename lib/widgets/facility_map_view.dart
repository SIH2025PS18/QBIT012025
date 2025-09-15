import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/medical_facility.dart';

class FacilityMapView extends StatefulWidget {
  final List<MedicalFacility> facilities;
  final Position? currentPosition;
  final Function(MedicalFacility) onFacilityTap;

  const FacilityMapView({
    Key? key,
    required this.facilities,
    this.currentPosition,
    required this.onFacilityTap,
  }) : super(key: key);

  @override
  State<FacilityMapView> createState() => _FacilityMapViewState();
}

class _FacilityMapViewState extends State<FacilityMapView> {
  MedicalFacility? selectedFacility;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          // Map placeholder with facilities list
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 64, color: Colors.blue[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Map View',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Interactive map with facility markers',
                    style: TextStyle(fontSize: 14, color: Colors.blue[600]),
                  ),
                  const SizedBox(height: 24),
                  // Simple facility markers representation
                  Container(
                    height: 200,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Stack(
                      children: [
                        // Background map pattern
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/map_pattern.png',
                              ),
                              fit: BoxFit.cover,
                              opacity: 0.1,
                            ),
                          ),
                        ),
                        // Facility markers
                        ...widget.facilities
                            .take(5)
                            .map((facility) => _buildFacilityMarker(facility))
                            .toList(),
                        // Current location marker
                        if (widget.currentPosition != null)
                          _buildCurrentLocationMarker(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom facility list
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.facilities.length,
              itemBuilder: (context, index) {
                final facility = widget.facilities[index];
                return _buildMapFacilityCard(facility);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFacilityMarker(MedicalFacility facility) {
    // Random positions for demo - in real app, these would be calculated from lat/lng
    final random = facility.name.hashCode % 100;
    final left = 20.0 + (random % 60);
    final top = 20.0 + ((random * 2) % 60);

    Color markerColor;
    IconData markerIcon;

    switch (facility.type) {
      case 'hospital':
        markerColor = Colors.red;
        markerIcon = Icons.local_hospital;
        break;
      case 'clinic':
        markerColor = Colors.blue;
        markerIcon = Icons.medical_services;
        break;
      case 'lab':
        markerColor = Colors.purple;
        markerIcon = Icons.science;
        break;
      default:
        markerColor = Colors.grey;
        markerIcon = Icons.location_on;
    }

    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFacility = facility;
          });
          widget.onFacilityTap(facility);
        },
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: markerColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(markerIcon, color: Colors.white, size: 16),
        ),
      ),
    );
  }

  Widget _buildCurrentLocationMarker() {
    return Positioned(
      left: 100,
      top: 80,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(Icons.my_location, color: Colors.white, size: 10),
      ),
    );
  }

  Widget _buildMapFacilityCard(MedicalFacility facility) {
    final isSelected = selectedFacility?.id == facility.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFacility = facility;
        });
        widget.onFacilityTap(facility);
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      facility.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.2)
                          : const Color(0xFF2E7D32).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      facility.type.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                facility.address,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white70 : Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (widget.currentPosition != null) ...[
                    Icon(
                      Icons.location_on,
                      size: 12,
                      color: isSelected ? Colors.white70 : Colors.grey[500],
                    ),
                    const SizedBox(width: 2),
                    Text(
                      facility.getDistanceFrom(
                        widget.currentPosition!.latitude,
                        widget.currentPosition!.longitude,
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Icon(
                    Icons.access_time,
                    size: 12,
                    color: isSelected ? Colors.white70 : Colors.grey[500],
                  ),
                  const SizedBox(width: 2),
                  Text(
                    facility.operatingHours.isOpenNow() ? 'Open' : 'Closed',
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
