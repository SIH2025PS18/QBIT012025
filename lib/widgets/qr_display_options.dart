import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/emergency_medical_data.dart';
import '../services/emergency_qr_service.dart';

class QRDisplayOptionsWidget extends StatefulWidget {
  final EmergencyQRToken token;
  final String patientName;

  const QRDisplayOptionsWidget({
    Key? key,
    required this.token,
    required this.patientName,
  }) : super(key: key);

  @override
  State<QRDisplayOptionsWidget> createState() => _QRDisplayOptionsWidgetState();
}

class _QRDisplayOptionsWidgetState extends State<QRDisplayOptionsWidget> {
  final EmergencyQRService _qrService = EmergencyQRService();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildLockScreenSection(),
          const SizedBox(height: 20),
          _buildPrintableCardSection(),
          const SizedBox(height: 20),
          _buildStickerSection(),
          const SizedBox(height: 20),
          _buildSafetyTips(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.display_settings,
                color: Colors.blue,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'QR Code Display Options',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Choose how you want to display your emergency QR code for quick access',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockScreenSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.phone_android, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                const Text(
                  'Lock Screen Widget',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Display emergency QR code on your phone\'s lock screen for immediate access during emergencies.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Mock lock screen preview
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: Stack(
                children: [
                  // Mock time display
                  const Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: Text(
                      '14:30',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Emergency QR widget
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.qr_code,
                              size: 40,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Emergency',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _enableLockScreenWidget,
                icon: const Icon(Icons.smartphone),
                label: const Text('Enable Lock Screen Widget'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrintableCardSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.credit_card, color: Colors.green.shade700),
                const SizedBox(width: 12),
                const Text(
                  'Printable Emergency Card',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Print a physical emergency card to keep in your wallet or with your ID documents.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Card preview
            Container(
              width: double.infinity,
              child: _qrService.createPrintableQRCard(
                widget.token,
                widget.patientName,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _generatePrintablePDF,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Generate PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _printCard,
                    icon: const Icon(Icons.print),
                    label: const Text('Print Card'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickerSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.label, color: Colors.orange.shade700),
                const SizedBox(width: 12),
                const Text(
                  'Emergency Stickers',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Print stickers for helmets, vehicle dashboards, or wearable accessories.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Sticker options
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Small Sticker',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      _qrService.createStickerQRCode(widget.token, size: 60),
                      const SizedBox(height: 8),
                      const Text(
                        'For helmets, watches',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Large Sticker',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      _qrService.createStickerQRCode(widget.token, size: 100),
                      const SizedBox(height: 8),
                      const Text(
                        'For vehicles, bags',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _generateStickerPDF,
                icon: const Icon(Icons.print),
                label: const Text('Print Stickers'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyTips() {
    return Card(
      color: Colors.yellow.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.security, color: Colors.amber.shade700),
                const SizedBox(width: 12),
                const Text(
                  'Safety & Security Tips',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTip(
              'Keep your emergency QR code easily accessible but secure',
            ),
            _buildTip(
              'Replace physical cards every 30 days when QR codes expire',
            ),
            _buildTip('Monitor access logs regularly for unauthorized use'),
            _buildTip(
              'Only authorized medical professionals can access your data',
            ),
            _buildTip(
              'QR codes contain NO personal data - only secure access tokens',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.amber.shade700,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  // Action methods
  void _enableLockScreenWidget() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lock Screen Widget'),
        content: const Text(
          'To enable the emergency QR code on your lock screen:\n\n'
          '1. Go to your phone settings\n'
          '2. Find "Lock Screen" or "Widgets"\n'
          '3. Add "Sehat Sarthi Emergency" widget\n'
          '4. Position it for easy access\n\n'
          'This feature may vary by device manufacturer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Open phone settings (would require platform-specific implementation)
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _generatePrintablePDF() async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Container(
                width: 300,
                height: 200,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.red, width: 2),
                ),
                child: pw.Column(
                  children: [
                    pw.Container(
                      width: double.infinity,
                      color: PdfColors.red,
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(
                        'EMERGENCY MEDICAL ACCESS',
                        style: pw.TextStyle(
                          color: PdfColors.white,
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(16),
                        child: pw.Row(
                          children: [
                            pw.Container(
                              width: 120,
                              height: 120,
                              decoration: pw.BoxDecoration(
                                border: pw.Border.all(),
                              ),
                              child: pw.Text('QR CODE\nHERE'),
                            ),
                            pw.SizedBox(width: 16),
                            pw.Expanded(
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('Patient: ${widget.patientName}'),
                                  pw.SizedBox(height: 8),
                                  pw.Text('For EMERGENCY use only'),
                                  pw.SizedBox(height: 8),
                                  pw.Text('Scan with Sehat Sarthi Doctor App'),
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
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _printCard() async {
    // This would integrate with the device's printing capabilities
    await _generatePrintablePDF();
  }

  Future<void> _generateStickerPDF() async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text('Emergency QR Code Stickers'),
                pw.SizedBox(height: 20),
                pw.Row(
                  children: [
                    pw.Container(
                      width: 100,
                      height: 120,
                      decoration: pw.BoxDecoration(border: pw.Border.all()),
                      child: pw.Column(
                        children: [
                          pw.Text('EMERGENCY'),
                          pw.Container(
                            width: 80,
                            height: 80,
                            child: pw.Text('QR'),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 20),
                    pw.Container(
                      width: 100,
                      height: 120,
                      decoration: pw.BoxDecoration(border: pw.Border.all()),
                      child: pw.Column(
                        children: [
                          pw.Text('EMERGENCY'),
                          pw.Container(
                            width: 80,
                            height: 80,
                            child: pw.Text('QR'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating sticker PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
