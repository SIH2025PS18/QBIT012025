import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import '../models/emergency_medical_data.dart';

class EmergencyQRService {
  static const String _baseUrl = 'https://sehat-sarthi.com/emergency';
  static final EmergencyQRService _instance = EmergencyQRService._internal();

  factory EmergencyQRService() => _instance;
  EmergencyQRService._internal();

  // Generate a secure token for QR code (does NOT contain patient data)
  String _generateSecureToken() {
    final random = Random.secure();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomBytes = List<int>.generate(16, (i) => random.nextInt(256));

    // Combine timestamp and random bytes for uniqueness
    final tokenData = '$timestamp${randomBytes.join('')}';
    final bytes = utf8.encode(tokenData);
    final digest = sha256.convert(bytes);

    return digest.toString().substring(0, 32); // 32 character token
  }

  // Generate QR code data (token only, no patient information)
  Future<EmergencyQRToken> generateEmergencyQRToken(String patientId) async {
    final tokenId = _generateSecureToken();
    final generatedAt = DateTime.now();
    final expiresAt = generatedAt.add(
      const Duration(days: 30),
    ); // 30-day validity

    final qrToken = EmergencyQRToken(
      tokenId: tokenId,
      patientId: patientId,
      generatedAt: generatedAt,
      expiresAt: expiresAt,
      isActive: true,
    );

    // Store token in local database and sync with server
    await _storeTokenLocally(qrToken);
    await _syncTokenWithServer(qrToken);

    return qrToken;
  }

  // Generate QR code string (only contains token, not patient data)
  String generateQRCodeData(EmergencyQRToken token) {
    final qrData = {
      'type': 'sehat_sarthi_emergency',
      'version': '1.0',
      'token': token.tokenId,
      'url': '$_baseUrl/${token.tokenId}',
      'generated': token.generatedAt.toIso8601String(),
    };

    return jsonEncode(qrData);
  }

  // Create QR code widget
  Widget createQRCodeWidget(EmergencyQRToken token, {double size = 200}) {
    final qrData = generateQRCodeData(token);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QrImageView(
            data: qrData,
            version: QrVersions.auto,
            size: size,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            errorStateBuilder: (cxt, err) {
              return Container(
                child: Center(
                  child: Text(
                    "Error generating QR",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Emergency Medical Access',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade700,
            ),
          ),
          Text(
            'Scan in emergency situations only',
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            'Token: ${token.tokenId.substring(0, 8)}...',
            style: TextStyle(
              fontSize: 8,
              color: Colors.grey.shade500,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  // Create printable QR code widget (for physical cards)
  Widget createPrintableQRCard(EmergencyQRToken token, String patientName) {
    final qrData = generateQRCodeData(token);

    return Container(
      width: 300,
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.red.shade700, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red.shade700,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'EMERGENCY MEDICAL ACCESS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),

          // QR Code and Patient Info
          Expanded(
            child: Row(
              children: [
                // QR Code
                QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 120,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  errorStateBuilder: (cxt, err) {
                    return Container(
                      child: Center(
                        child: Text("Error", textAlign: TextAlign.center),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),

                // Patient Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Patient: $patientName',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'For EMERGENCY use only',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Scan with Sehat Sarthi Doctor App',
                        style: TextStyle(fontSize: 9, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Generated: ${_formatDate(token.generatedAt)}',
                        style: const TextStyle(fontSize: 8, color: Colors.grey),
                      ),
                      Text(
                        'Expires: ${_formatDate(token.expiresAt)}',
                        style: const TextStyle(fontSize: 8, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Footer
          const Divider(height: 8),
          const Text(
            'Keep this card in your wallet or with your ID',
            style: TextStyle(
              fontSize: 8,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Create helmet/vehicle sticker QR code
  Widget createStickerQRCode(EmergencyQRToken token, {double size = 80}) {
    final qrData = generateQRCodeData(token);

    return Container(
      width: size + 20,
      height: size + 40,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.red.shade700, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.red.shade700,
              borderRadius: BorderRadius.circular(2),
            ),
            child: const Text(
              'EMERGENCY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          QrImageView(
            data: qrData,
            version: QrVersions.auto,
            size: size,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            errorStateBuilder: (cxt, err) {
              return Container(
                child: Center(
                  child: Text("QR Error", textAlign: TextAlign.center),
                ),
              );
            },
          ),
          const SizedBox(height: 2),
          const Text(
            'Scan for medical info',
            style: TextStyle(fontSize: 6, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Validate QR token (check if still active and not expired)
  bool isTokenValid(EmergencyQRToken token) {
    final now = DateTime.now();
    return token.isActive && now.isBefore(token.expiresAt);
  }

  // Revoke QR token
  Future<void> revokeToken(String tokenId) async {
    // Update local storage
    await _revokeTokenLocally(tokenId);
    // Sync with server
    await _syncTokenRevocationWithServer(tokenId);
  }

  // Get all active tokens for a patient
  Future<List<EmergencyQRToken>> getActiveTokens(String patientId) async {
    // Implementation would fetch from local storage
    // For now, return empty list
    return [];
  }

  // Private helper methods
  Future<void> _storeTokenLocally(EmergencyQRToken token) async {
    // Implementation for local SQLite storage
    // Store token data locally for offline access
  }

  Future<void> _syncTokenWithServer(EmergencyQRToken token) async {
    // Implementation to sync token with backend server
    // Send token to server for validation when scanned
  }

  Future<void> _revokeTokenLocally(String tokenId) async {
    // Implementation to mark token as inactive locally
  }

  Future<void> _syncTokenRevocationWithServer(String tokenId) async {
    // Implementation to sync token revocation with server
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// QR Code Display Options
enum QRDisplayOption {
  lockScreen, // Display on phone lock screen
  printableCard, // Printable physical card
  stickerSmall, // Small sticker for helmet/vehicle
  stickerLarge, // Large sticker for prominent display
}

// QR Code Configuration
class QRCodeConfig {
  final QRDisplayOption displayOption;
  final double size;
  final bool includePatientName;
  final bool includeExpiryDate;
  final Color foregroundColor;
  final Color backgroundColor;

  QRCodeConfig({
    required this.displayOption,
    this.size = 200,
    this.includePatientName = true,
    this.includeExpiryDate = true,
    this.foregroundColor = Colors.black,
    this.backgroundColor = Colors.white,
  });
}
