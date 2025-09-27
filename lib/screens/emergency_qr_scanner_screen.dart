import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/emergency_qr_service.dart';
import '../widgets/emergency_medical_data_display.dart';

class EmergencyQRScannerScreen extends StatefulWidget {
  const EmergencyQRScannerScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyQRScannerScreen> createState() =>
      _EmergencyQRScannerScreenState();
}

class _EmergencyQRScannerScreenState extends State<EmergencyQRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  final EmergencyQRService _qrService = EmergencyQRService();
  bool _isScanning = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency QR Scanner'),
        backgroundColor: Colors.red[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => cameraController.toggleTorch(),
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
          ),
          IconButton(
            onPressed: () => cameraController.switchCamera(),
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Instructions
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.red[50],
            child: Column(
              children: [
                Icon(Icons.qr_code_scanner, size: 32, color: Colors.red[600]),
                const SizedBox(height: 8),
                Text(
                  'Scan Emergency QR Code',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Position the QR code within the frame to access emergency medical information',
                  style: TextStyle(fontSize: 14, color: Colors.red[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // QR Scanner
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                MobileScanner(
                  controller: cameraController,
                  onDetect: _onDetect,
                ),
                if (!_isScanning)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                // Scanning overlay
                Container(
                  decoration: ShapeDecoration(
                    shape: QrScannerOverlayShape(
                      borderColor: Colors.red,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: 250,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Controls
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _isScanning
                          ? () async {
                              await cameraController.stop();
                              setState(() {
                                _isScanning = false;
                              });
                            }
                          : () async {
                              await cameraController.start();
                              setState(() {
                                _isScanning = true;
                              });
                            },
                      icon: Icon(_isScanning ? Icons.pause : Icons.play_arrow),
                      label: Text(_isScanning ? 'Pause' : 'Resume'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isScanning
                            ? Colors.orange
                            : Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await cameraController.stop();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Emergency QR codes contain secure tokens to access critical medical information',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) async {
    if (!_isScanning) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        setState(() {
          _isScanning = false;
        });

        // Stop camera while processing
        await cameraController.stop();

        try {
          // Process the scanned QR code
          await _processQRCode(barcode.rawValue!);
        } catch (e) {
          print('Error processing QR code: $e');
          _showErrorDialog('Failed to process QR code');
        } finally {
          // Resume scanning after processing
          setState(() {
            _isScanning = true;
          });
          await cameraController.start();
        }
        break; // Process only the first valid barcode
      }
    }
  }

  Future<void> _processQRCode(String qrCodeData) async {
    try {
      // Use the QR service to scan and get medical data
      final medicalData = await _qrService.scanQRAndGetMedicalData(qrCodeData);

      if (!mounted) return;

      if (medicalData != null) {
        // Show the medical data in a dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              EmergencyQRResultDialog(medicalData: medicalData),
        );
      } else {
        // Show error for invalid QR code
        await showDialog(
          context: context,
          builder: (context) => const EmergencyQRResultDialog(
            errorMessage: 'Invalid emergency QR code or expired token',
          ),
        );
      }
    } catch (e) {
      print('Error in QR processing: $e');
      _showErrorDialog('Failed to retrieve medical data: ${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text('Scan Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}

// Custom overlay shape for QR scanner
class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 40,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path _getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return _getLeftTopPath(rect)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      ..lineTo(rect.left, rect.top);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final borderWidthSize = width / 2;
    final height = rect.height;
    final borderOffset = borderWidth / 2;
    final _borderLength = borderLength > cutOutSize / 2 + borderOffset
        ? borderWidthSize / 2
        : borderLength;
    final _cutOutSize = cutOutSize < width ? cutOutSize : width - borderOffset;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final cutOutRect = Rect.fromLTWH(
      rect.left + width / 2 - _cutOutSize / 2 + borderOffset,
      rect.top + height / 2 - _cutOutSize / 2 + borderOffset,
      _cutOutSize - borderOffset * 2,
      _cutOutSize - borderOffset * 2,
    );

    // Draw background
    canvas.saveLayer(rect, backgroundPaint);
    canvas.drawRect(rect, backgroundPaint);

    // Draw cut out
    canvas.drawRect(cutOutRect, boxPaint);
    canvas.restore();

    // Draw border
    canvas.drawRRect(
      RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
      borderPaint,
    );

    // Draw corners
    final path = Path();
    // Top left corner
    path.moveTo(cutOutRect.left - borderOffset, cutOutRect.top + _borderLength);
    path.lineTo(cutOutRect.left - borderOffset, cutOutRect.top - borderOffset);
    path.lineTo(cutOutRect.left + _borderLength, cutOutRect.top - borderOffset);

    // Top right corner
    path.moveTo(
      cutOutRect.right - _borderLength,
      cutOutRect.top - borderOffset,
    );
    path.lineTo(cutOutRect.right + borderOffset, cutOutRect.top - borderOffset);
    path.lineTo(
      cutOutRect.right + borderOffset,
      cutOutRect.top + _borderLength,
    );

    // Bottom right corner
    path.moveTo(
      cutOutRect.right + borderOffset,
      cutOutRect.bottom - _borderLength,
    );
    path.lineTo(
      cutOutRect.right + borderOffset,
      cutOutRect.bottom + borderOffset,
    );
    path.lineTo(
      cutOutRect.right - _borderLength,
      cutOutRect.bottom + borderOffset,
    );

    // Bottom left corner
    path.moveTo(
      cutOutRect.left + _borderLength,
      cutOutRect.bottom + borderOffset,
    );
    path.lineTo(
      cutOutRect.left - borderOffset,
      cutOutRect.bottom + borderOffset,
    );
    path.lineTo(
      cutOutRect.left - borderOffset,
      cutOutRect.bottom - _borderLength,
    );

    canvas.drawPath(path, borderPaint);
  }

  @override
  ShapeBorder scale(double t) {
    return QrScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}

// Test QR Code Generator for Development
class TestQRGeneratorScreen extends StatefulWidget {
  const TestQRGeneratorScreen({Key? key}) : super(key: key);

  @override
  State<TestQRGeneratorScreen> createState() => _TestQRGeneratorScreenState();
}

class _TestQRGeneratorScreenState extends State<TestQRGeneratorScreen> {
  final EmergencyQRService _qrService = EmergencyQRService();
  Widget? _qrWidget;
  String? _generatedToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test QR Generator'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Generate Test Emergency QR Code',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This generates a QR code for testing the emergency medical data display.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _generateTestQR,
                        icon: const Icon(Icons.qr_code),
                        label: const Text('Generate Test QR'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_qrWidget != null) ...[
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Generated QR Code',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _qrWidget!,
                      const SizedBox(height: 16),
                      if (_generatedToken != null) ...[
                        Text(
                          'Token: ${_generatedToken!.substring(0, 16)}...',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      const Text(
                        'Use the Emergency QR Scanner to test this code',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _generateTestQR() async {
    try {
      // Generate a test emergency QR token
      final token = await _qrService.generateEmergencyQRToken(
        'test-patient-id',
      );

      // Create QR widget using the generated token
      final qrWidget = _qrService.createQRCodeWidget(token);

      setState(() {
        _qrWidget = qrWidget;
        _generatedToken = token.tokenId;
      });
    } catch (e) {
      print('Error generating test QR: $e');
      _showErrorDialog('Error: ${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
