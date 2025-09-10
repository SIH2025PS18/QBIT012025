// import 'dart:convert';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/pharmacy.dart';
// import '../models/medicine_stock.dart';
// import '../models/prescription.dart';

// /// Pharmacy integration service for real-time medicine availability and pricing
// class PharmacyService {
//   static final PharmacyService _instance = PharmacyService._internal();
//   factory PharmacyService() => _instance;
//   PharmacyService._internal();

//   final SupabaseClient _supabase = Supabase.instance.client;

//   /// Find medicines in nearby pharmacies
//   Future<List<MedicineStock>> findMedicine({
//     required String medicineName,
//     double? latitude,
//     double? longitude,
//     double radiusKm = 10.0,
//   }) async {
//     try {
//       // Search for medicines in nearby pharmacies
//       final response = await _supabase.rpc(
//         'find_nearby_medicine',
//         params: {
//           'medicine_name': medicineName,
//           'user_lat': latitude,
//           'user_lng': longitude,
//           'radius_km': radiusKm,
//         },
//       );

//       if (response == null) return [];

//       return (response as List<dynamic>)
//           .map((data) => MedicineStock.fromJson(data as Map<String, dynamic>))
//           .toList();
//     } catch (e) {
//       print('❌ Error finding medicine: $e');
//       return [];
//     }
//   }

//   /// Get price comparison for a specific medicine
//   Future<List<PriceComparison>> comparePrice({
//     required String medicineName,
//     double? latitude,
//     double? longitude,
//     double radiusKm = 15.0,
//   }) async {
//     try {
//       final response = await _supabase.rpc(
//         'compare_medicine_prices',
//         params: {
//           'medicine_name': medicineName,
//           'user_lat': latitude,
//           'user_lng': longitude,
//           'radius_km': radiusKm,
//         },
//       );

//       if (response == null) return [];

//       return (response as List<dynamic>)
//           .map((data) => PriceComparison.fromJson(data as Map<String, dynamic>))
//           .toList();
//     } catch (e) {
//       print('❌ Error comparing prices: $e');
//       return [];
//     }
//   }

//   /// Reserve medicine at a pharmacy
//   Future<bool> reserveMedicine({
//     required String pharmacyId,
//     required String medicineId,
//     required int quantity,
//     required String patientId,
//     int reservationHours = 24,
//   }) async {
//     try {
//       final response = await _supabase
//           .from('medicine_reservations')
//           .insert({
//             'pharmacy_id': pharmacyId,
//             'medicine_id': medicineId,
//             'patient_id': patientId,
//             'quantity_reserved': quantity,
//             'reservation_expires_at': DateTime.now()
//                 .add(Duration(hours: reservationHours))
//                 .toIso8601String(),
//             'status': 'reserved',
//             'created_at': DateTime.now().toIso8601String(),
//           })
//           .select()
//           .single();

//       if (response != null) {
//         // Update medicine stock
//         await _updateMedicineStock(medicineId, quantity, 'reserve');

//         // Notify pharmacy about reservation
//         await _notifyPharmacyOfReservation(pharmacyId, medicineId, quantity);

//         return true;
//       }

//       return false;
//     } catch (e) {
//       print('❌ Error reserving medicine: $e');
//       return false;
//     }
//   }

//   /// Notify pharmacies about new prescriptions
//   Future<void> notifyPharmaciesOfPrescription(Prescription prescription) async {
//     try {
//       // Get nearby pharmacies
//       final nearbyPharmacies = await _getNearbyPharmacies(
//         latitude: prescription.patientLocation?.latitude,
//         longitude: prescription.patientLocation?.longitude,
//       );

//       // Send notification to each pharmacy
//       for (final pharmacy in nearbyPharmacies) {
//         await _supabase.from('pharmacy_notifications').insert({
//           'pharmacy_id': pharmacy.id,
//           'prescription_id': prescription.id,
//           'patient_id': prescription.patientId,
//           'medicines': prescription.medicines.map((m) => m.toJson()).toList(),
//           'notification_type': 'new_prescription',
//           'status': 'sent',
//           'created_at': DateTime.now().toIso8601String(),
//         });
//       }

//       print(
//           '✅ Notified ${nearbyPharmacies.length} pharmacies about prescription');
//     } catch (e) {
//       print('❌ Error notifying pharmacies: $e');
//     }
//   }

//   /// Get nearby pharmacies
//   Future<List<Pharmacy>> _getNearbyPharmacies({
//     double? latitude,
//     double? longitude,
//     double radiusKm = 10.0,
//   }) async {
//     try {
//       if (latitude == null || longitude == null) {
//         // Return all active pharmacies if no location provided
//         final response = await _supabase
//             .from('pharmacies')
//             .select()
//             .eq('is_active', true)
//             .limit(20);

//         return response
//             .map<Pharmacy>((data) => Pharmacy.fromJson(data))
//             .toList();
//       }

//       final response = await _supabase.rpc(
//         'find_nearby_pharmacies',
//         params: {
//           'user_lat': latitude,
//           'user_lng': longitude,
//           'radius_km': radiusKm,
//         },
//       );

//       if (response == null) return [];

//       return (response as List<dynamic>)
//           .map((data) => Pharmacy.fromJson(data as Map<String, dynamic>))
//           .toList();
//     } catch (e) {
//       print('❌ Error getting nearby pharmacies: $e');
//       return [];
//     }
//   }

//   /// Update medicine stock after reservation/purchase
//   Future<void> _updateMedicineStock(
//     String medicineId,
//     int quantity,
//     String operation, // 'reserve', 'purchase', 'release'
//   ) async {
//     try {
//       String updateQuery;
//       switch (operation) {
//         case 'reserve':
//           updateQuery =
//               'quantity_available = quantity_available - $quantity, quantity_reserved = quantity_reserved + $quantity';
//           break;
//         case 'purchase':
//           updateQuery = 'quantity_reserved = quantity_reserved - $quantity';
//           break;
//         case 'release':
//           updateQuery =
//               'quantity_available = quantity_available + $quantity, quantity_reserved = quantity_reserved - $quantity';
//           break;
//         default:
//           return;
//       }

//       await _supabase.rpc('update_medicine_stock', params: {
//         'medicine_id': medicineId,
//         'operation': operation,
//         'quantity': quantity,
//       });

//       print('✅ Medicine stock updated: $operation $quantity units');
//     } catch (e) {
//       print('❌ Error updating medicine stock: $e');
//     }
//   }

//   /// Notify pharmacy about reservation
//   Future<void> _notifyPharmacyOfReservation(
//     String pharmacyId,
//     String medicineId,
//     int quantity,
//   ) async {
//     try {
//       // Get pharmacy and medicine details
//       final pharmacyResponse = await _supabase
//           .from('pharmacies')
//           .select('name, phone_number, email')
//           .eq('id', pharmacyId)
//           .single();

//       final medicineResponse = await _supabase
//           .from('medicine_inventory')
//           .select('medicine_name, brand_name')
//           .eq('id', medicineId)
//           .single();

//       // Send real-time notification via Supabase Realtime
//       await _supabase.from('real_time_notifications').insert({
//         'recipient_id': pharmacyId,
//         'recipient_type': 'pharmacy',
//         'notification_type': 'medicine_reservation',
//         'title': 'New Medicine Reservation',
//         'message':
//             'Medicine ${medicineResponse['medicine_name']} reserved - Quantity: $quantity',
//         'data': {
//           'medicine_id': medicineId,
//           'medicine_name': medicineResponse['medicine_name'],
//           'quantity': quantity,
//         },
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       // TODO: Send SMS notification if phone number available
//       if (pharmacyResponse['phone_number'] != null) {
//         await _sendSMSNotification(
//           phoneNumber: pharmacyResponse['phone_number'],
//           message:
//               'Medicine reservation: ${medicineResponse['medicine_name']} - Qty: $quantity',
//         );
//       }

//       print('✅ Pharmacy notified about reservation');
//     } catch (e) {
//       print('❌ Error notifying pharmacy: $e');
//     }
//   }

//   /// Send SMS notification (placeholder - implement with Twilio)
//   Future<void> _sendSMSNotification({
//     required String phoneNumber,
//     required String message,
//   }) async {
//     try {
//       // TODO: Integrate with Twilio or other SMS service
//       print('📱 SMS would be sent to $phoneNumber: $message');

//       // For now, just log the SMS that would be sent
//       await _supabase.from('sms_log').insert({
//         'phone_number': phoneNumber,
//         'message': message,
//         'status': 'simulated',
//         'created_at': DateTime.now().toIso8601String(),
//       });
//     } catch (e) {
//       print('❌ Error sending SMS: $e');
//     }
//   }

//   /// Get pharmacy inventory for a specific pharmacy
//   Future<List<MedicineStock>> getPharmacyInventory(String pharmacyId) async {
//     try {
//       final response = await _supabase
//           .from('medicine_inventory')
//           .select()
//           .eq('pharmacy_id', pharmacyId)
//           .eq('quantity_available', 0, negate: true) // Only in-stock medicines
//           .order('medicine_name');

//       return response
//           .map<MedicineStock>((data) => MedicineStock.fromJson(data))
//           .toList();
//     } catch (e) {
//       print('❌ Error getting pharmacy inventory: $e');
//       return [];
//     }
//   }

//   /// Search medicines by name or brand
//   Future<List<MedicineStock>> searchMedicines({
//     required String searchQuery,
//     double? latitude,
//     double? longitude,
//     double radiusKm = 20.0,
//   }) async {
//     try {
//       final response = await _supabase.rpc(
//         'search_medicines',
//         params: {
//           'search_query': searchQuery.toLowerCase(),
//           'user_lat': latitude,
//           'user_lng': longitude,
//           'radius_km': radiusKm,
//         },
//       );

//       if (response == null) return [];

//       return (response as List<dynamic>)
//           .map((data) => MedicineStock.fromJson(data as Map<String, dynamic>))
//           .toList();
//     } catch (e) {
//       print('❌ Error searching medicines: $e');
//       return [];
//     }
//   }

//   /// Get medicine alternatives/substitutes
//   Future<List<MedicineStock>> getMedicineAlternatives({
//     required String genericName,
//     double? latitude,
//     double? longitude,
//     double radiusKm = 15.0,
//   }) async {
//     try {
//       final response = await _supabase.rpc(
//         'find_medicine_alternatives',
//         params: {
//           'generic_name': genericName,
//           'user_lat': latitude,
//           'user_lng': longitude,
//           'radius_km': radiusKm,
//         },
//       );

//       if (response == null) return [];

//       return (response as List<dynamic>)
//           .map((data) => MedicineStock.fromJson(data as Map<String, dynamic>))
//           .toList();
//     } catch (e) {
//       print('❌ Error finding alternatives: $e');
//       return [];
//     }
//   }

//   /// Get pharmacy details by ID
//   Future<Pharmacy?> getPharmacyDetails(String pharmacyId) async {
//     try {
//       final response = await _supabase
//           .from('pharmacies')
//           .select()
//           .eq('id', pharmacyId)
//           .single();

//       return Pharmacy.fromJson(response);
//     } catch (e) {
//       print('❌ Error getting pharmacy details: $e');
//       return null;
//     }
//   }

//   /// Check medicine expiry status
//   Future<List<ExpiryAlert>> checkMedicineExpiry({
//     String? pharmacyId,
//     int daysThreshold = 30,
//   }) async {
//     try {
//       final query = _supabase
//           .from('medicine_inventory')
//           .select('*, pharmacies(name)')
//           .lte(
//               'expiry_date',
//               DateTime.now()
//                   .add(Duration(days: daysThreshold))
//                   .toIso8601String()
//                   .split('T')[0]);

//       if (pharmacyId != null) {
//         query.eq('pharmacy_id', pharmacyId);
//       }

//       final response = await query.execute();

//       return response.data
//           .map<ExpiryAlert>((data) => ExpiryAlert.fromJson(data))
//           .toList();
//     } catch (e) {
//       print('❌ Error checking medicine expiry: $e');
//       return [];
//     }
//   }

//   /// Stream real-time inventory updates
//   Stream<List<MedicineStock>> streamInventoryUpdates({
//     String? pharmacyId,
//     String? medicineName,
//   }) {
//     try {
//       var query =
//           _supabase.from('medicine_inventory').stream(primaryKey: ['id']);

//       if (pharmacyId != null) {
//         query = query.eq('pharmacy_id', pharmacyId);
//       }

//       if (medicineName != null) {
//         query = query.ilike('medicine_name', '%$medicineName%');
//       }

//       return query.map((data) => data
//           .map<MedicineStock>((item) => MedicineStock.fromJson(item))
//           .toList());
//     } catch (e) {
//       print('❌ Error streaming inventory updates: $e');
//       return Stream.value([]);
//     }
//   }
// }

// /// Medicine expiry alert model
// class ExpiryAlert {
//   final String medicineId;
//   final String medicineName;
//   final String pharmacyName;
//   final DateTime expiryDate;
//   final int quantityAvailable;
//   final int daysUntilExpiry;

//   const ExpiryAlert({
//     required this.medicineId,
//     required this.medicineName,
//     required this.pharmacyName,
//     required this.expiryDate,
//     required this.quantityAvailable,
//     required this.daysUntilExpiry,
//   });

//   factory ExpiryAlert.fromJson(Map<String, dynamic> json) {
//     final expiryDate = DateTime.parse(json['expiry_date']);
//     final now = DateTime.now();
//     final daysUntilExpiry = expiryDate.difference(now).inDays;

//     return ExpiryAlert(
//       medicineId: json['id'],
//       medicineName: json['medicine_name'],
//       pharmacyName: json['pharmacies']['name'],
//       expiryDate: expiryDate,
//       quantityAvailable: json['quantity_available'],
//       daysUntilExpiry: daysUntilExpiry,
//     );
//   }

//   bool get isExpired => daysUntilExpiry < 0;
//   bool get isExpiringSoon => daysUntilExpiry <= 30 && daysUntilExpiry >= 0;
// }
