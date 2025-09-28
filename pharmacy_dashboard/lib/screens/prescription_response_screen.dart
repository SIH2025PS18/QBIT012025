import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/prescription_provider.dart';
import '../models/prescription_request.dart';

enum PrescriptionPriority { urgent, high, medium, low }

class PrescriptionResponseScreen extends StatefulWidget {
  final PrescriptionRequest request;

  const PrescriptionResponseScreen({super.key, required this.request});

  @override
  State<PrescriptionResponseScreen> createState() =>
      _PrescriptionResponseScreenState();
}

class _PrescriptionResponseScreenState
    extends State<PrescriptionResponseScreen> {
  final TextEditingController _responseController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _deliveryTimeController = TextEditingController();
  bool _isAvailable = true;
  String _selectedLanguage = 'en';
  List<String> _selectedMedicines = [];

  // Quick response suggestions based on prescription type
  List<Map<String, String>> _getSuggestions() {
    final request = widget.request;

    // Analyze prescription content for suggestions based on medicines
    final allMedicineText = request.medicines
        .map((m) => '${m.name} ${m.brand ?? ''} ${m.instructions ?? ''}')
        .join(' ')
        .toLowerCase();

    if (allMedicineText.contains('diabetes') ||
        allMedicineText.contains('sugar') ||
        allMedicineText.contains('insulin') ||
        allMedicineText.contains('metformin')) {
      return [
        {
          'en':
              'All diabetes medications are available. Please note that insulin requires refrigeration. Total cost: ₹',
          'hi':
              'सभी मधुमेह की दवाएं उपलब्ध हैं। कृपया ध्यान दें कि इंसुलिन को रेफ्रिजरेशन की आवश्यकता होती है। कुल लागत: ₹',
          'pa':
              'ਸਾਰੀਆਂ ਮਧੂਮੇਹ ਦੀਆਂ ਦਵਾਈਆਂ ਉਪਲਬਧ ਹਨ। ਕਿਰਪਾ ਕਰਕੇ ਨੋਟ ਕਰੋ ਕਿ ਇੰਸੁਲਿਨ ਨੂੰ ਠੰਡੇ ਵਿੱਚ ਰੱਖਣ ਦੀ ਲੋੜ ਹੈ। ਕੁੱਲ ਲਾਗਤ: ₹',
        },
        {
          'en':
              'Please bring your glucose meter for a free check-up with this purchase.',
          'hi':
              'कृपया इस खरीदारी के साथ मुफ्त जांच के लिए अपना ग्लूकोज मीटर लाएं।',
          'pa':
              'ਕਿਰਪਾ ਕਰਕੇ ਇਸ ਖਰੀਦਦਾਰੀ ਦੇ ਨਾਲ ਮੁਫਤ ਜਾਂਚ ਲਈ ਆਪਣਾ ਗਲੂਕੋਜ਼ ਮੀਟਰ ਲਿਆਓ।',
        },
        {
          'en':
              'We recommend taking diabetes medications after meals. Would you like dietary consultation?',
          'hi':
              'हम भोजन के बाद मधुमेह की दवाएं लेने की सलाह देते हैं। क्या आप आहार परामर्श चाहते हैं?',
          'pa':
              'ਅਸੀਂ ਖਾਣੇ ਤੋਂ ਬਾਅਦ ਮਧੂਮੇਹ ਦੀਆਂ ਦਵਾਈਆਂ ਲੈਣ ਦੀ ਸਲਾਹ ਦਿੰਦੇ ਹਾਂ। ਕੀ ਤੁਸੀਂ ਖੁਰਾਕ ਸੰਬੰਧੀ ਸਲਾਹ ਚਾਹੁੰਦੇ ਹੋ?',
        },
      ];
    } else if (allMedicineText.contains('fever') ||
        allMedicineText.contains('paracetamol') ||
        allMedicineText.contains('child') ||
        allMedicineText.contains('बुखार')) {
      return [
        {
          'en':
              'Child fever medicines are available. Please follow dosage instructions carefully based on weight.',
          'hi':
              'बच्चे के बुखार की दवाएं उपलब्ध हैं। कृपया वजन के आधार पर खुराक के निर्देशों का सावधानीपूर्वक पालन करें।',
          'pa':
              'ਬੱਚਿਆਂ ਦੇ ਬੁਖਾਰ ਦੀਆਂ ਦਵਾਈਆਂ ਉਪਲਬਧ ਹਨ। ਕਿਰਪਾ ਕਰਕੇ ਭਾਰ ਦੇ ਆਧਾਰ ਤੇ ਖੁਰਾਕ ਦੇ ਨਿਰਦੇਸ਼ਾਂ ਦਾ ਧਿਆਨ ਨਾਲ ਪਾਲਣ ਕਰੋ।',
        },
        {
          'en':
              'For children under 2 years, please consult doctor before giving any medication.',
          'hi':
              '2 साल से कम उम्र के बच्चों के लिए, कोई भी दवा देने से पहले डॉक्टर से सलाह लें।',
          'pa':
              '2 ਸਾਲ ਤੋਂ ਘੱਟ ਉਮਰ ਦੇ ਬੱਚਿਆਂ ਲਈ, ਕੋਈ ਵੀ ਦਵਾਈ ਦੇਣ ਤੋਂ ਪਹਿਲਾਂ ਡਾਕਟਰ ਨਾਲ ਸਲਾਹ ਕਰੋ।',
        },
        {
          'en':
              'We also have sugar-free syrups available for diabetic children.',
          'hi':
              'हमारे पास मधुमेह वाले बच्चों के लिए चीनी मुक्त सिरप भी उपलब्ध हैं।',
          'pa': 'ਸਾਡੇ ਕੋਲ ਮਧੂਮੇਹੀ ਬੱਚਿਆਂ ਲਈ ਖੰਡ ਰਹਿਤ ਸਿਰਪ ਵੀ ਉਪਲਬਧ ਹਨ।',
        },
      ];
    } else if (allMedicineText.contains('heart') ||
        allMedicineText.contains('cardiac') ||
        allMedicineText.contains('bp') ||
        allMedicineText.contains('blood pressure') ||
        allMedicineText.contains('amlodipine')) {
      return [
        {
          'en':
              'All cardiac medications are in stock. Please take BP medicines at the same time daily.',
          'hi':
              'सभी हृदय संबंधी दवाएं स्टॉक में हैं। कृपया बीपी की दवाएं रोजाना एक ही समय पर लें।',
          'pa':
              'ਸਾਰੀਆਂ ਦਿਲ ਸੰਬੰਧੀ ਦਵਾਈਆਂ ਸਟਾਕ ਵਿੱਚ ਹਨ। ਕਿਰਪਾ ਕਰਕੇ ਬੀਪੀ ਦੀਆਂ ਦਵਾਈਆਂ ਰੋਜ਼ਾਨਾ ਇੱਕੋ ਸਮੇਂ ਲਓ।',
        },
        {
          'en':
              'Free BP check-up available. Would you like to monitor your blood pressure?',
          'hi':
              'मुफ्त बीपी जांच उपलब्ध है। क्या आप अपने रक्तचाप की निगरानी करना चाहते हैं?',
          'pa':
              'ਮੁਫਤ ਬੀਪੀ ਜਾਂਚ ਉਪਲਬਧ ਹੈ। ਕੀ ਤੁਸੀਂ ਆਪਣੇ ਬਲੱਡ ਪ੍ਰੈਸ਼ਰ ਦੀ ਨਿਗਰਾਨੀ ਕਰਨਾ ਚਾਹੁੰਦੇ ਹੋ?',
        },
        {
          'en':
              'Please avoid salty foods and maintain regular exercise with these medications.',
          'hi':
              'कृपया नमकीन भोजन से बचें और इन दवाओं के साथ नियमित व्यायाम बनाए रखें।',
          'pa':
              'ਕਿਰਪਾ ਕਰਕੇ ਨਮਕੀਨ ਖਾਣੇ ਤੋਂ ਬਚੋ ਅਤੇ ਇਨ੍ਹਾਂ ਦਵਾਈਆਂ ਦੇ ਨਾਲ ਨਿਯਮਤ ਕਸਰਤ ਕਰੋ।',
        },
      ];
    } else {
      return [
        {
          'en':
              'All prescribed medications are available. We ensure genuine medicines with proper storage.',
          'hi':
              'सभी निर्धारित दवाएं उपलब्ध हैं। हम उचित भंडारण के साथ वास्तविक दवाओं को सुनिश्चित करते हैं।',
          'pa':
              'ਸਾਰੀਆਂ ਨਿਰਧਾਰਤ ਦਵਾਈਆਂ ਉਪਲਬਧ ਹਨ। ਅਸੀਂ ਸਹੀ ਸਟੋਰੇਜ਼ ਦੇ ਨਾਲ ਅਸਲੀ ਦਵਾਈਆਂ ਨੂੰ ਯਕੀਨੀ ਬਣਾਉਂਦੇ ਹਾਂ।',
        },
        {
          'en': 'Please complete the full course as prescribed by your doctor.',
          'hi': 'कृपया अपने डॉक्टर द्वारा निर्धारित पूरा कोर्स पूरा करें।',
          'pa': 'ਕਿਰਪਾ ਕਰਕੇ ਆਪਣੇ ਡਾਕਟਰ ਦੁਆਰਾ ਨਿਰਧਾਰਤ ਪੂਰਾ ਕੋਰਸ ਪੂਰਾ ਕਰੋ।',
        },
        {
          'en':
              'Free home delivery available for orders above ₹500. Contact us for details.',
          'hi':
              '₹500 से अधिक के ऑर्डर के लिए मुफ्त होम डिलीवरी उपलब्ध है। विवरण के लिए हमसे संपर्क करें।',
          'pa':
              '₹500 ਤੋਂ ਉੱਪਰ ਦੇ ਆਰਡਰਾਂ ਲਈ ਮੁਫਤ ਘਰ ਦੀ ਸਿਪੁਰਦਗੀ ਉਪਲਬਧ ਹੈ। ਵੇਰਵਿਆਂ ਲਈ ਸਾਡੇ ਨਾਲ ਸੰਪਰਕ ਕਰੋ।',
        },
      ];
    }
  }

  // Available medicines with pricing
  final List<Map<String, dynamic>> _availableMedicines = [
    {'name': 'Paracetamol 500mg', 'price': 25, 'stock': 150},
    {'name': 'Insulin Glargine', 'price': 850, 'stock': 12},
    {'name': 'Metformin 500mg', 'price': 45, 'stock': 80},
    {'name': 'Amoxicillin 250mg', 'price': 65, 'stock': 200},
    {'name': 'Cetirizine 10mg', 'price': 35, 'stock': 120},
    {'name': 'Amlodipine 5mg', 'price': 55, 'stock': 90},
    {'name': 'Atorvastatin 20mg', 'price': 125, 'stock': 75},
    {'name': 'Omeprazole 20mg', 'price': 85, 'stock': 110},
  ];

  @override
  Widget build(BuildContext context) {
    final suggestions = _getSuggestions();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Respond to Prescription'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Prescription Request Card
            _buildPrescriptionCard(),

            const SizedBox(height: 20),

            // AI Suggestions Section
            _buildSuggestionsSection(suggestions),

            const SizedBox(height: 20),

            // Available Medicines Section
            _buildAvailableMedicinesSection(),

            const SizedBox(height: 20),

            // Response Form
            _buildResponseForm(),

            const SizedBox(height: 20),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrescriptionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.receipt_long, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prescription Request',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Patient: ${widget.request.patientName}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                  color: _getPriorityColor(
                    PrescriptionPriority.medium,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.request.status.toUpperCase(),
                  style: TextStyle(
                    color: _getPriorityColor(PrescriptionPriority.medium),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Prescription Details:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.request.medicines
                      .map(
                        (medicine) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            '• ${medicine.name} ${medicine.brand ?? ''} - ${medicine.dosage} (${medicine.quantity})',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                'Requested: ${_formatTime(widget.request.requestedAt)}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const Spacer(),
              if (widget.request.patientPhone.isNotEmpty) ...[
                Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  widget.request.patientPhone,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsSection(List<Map<String, String>> suggestions) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.lightbulb, color: Colors.purple),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI-Powered Suggestions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Smart recommendations based on prescription analysis',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // Language Selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedLanguage,
                    isDense: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'en',
                        child: Text('🇬🇧 English'),
                      ),
                      DropdownMenuItem(value: 'hi', child: Text('🇮🇳 हिंदी')),
                      DropdownMenuItem(value: 'pa', child: Text('🇮🇳 ਪੰਜਾਬੀ')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ...suggestions.asMap().entries.map((entry) {
            final index = entry.key;
            final suggestion = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () {
                  _responseController.text =
                      suggestion[_selectedLanguage] ?? suggestion['en']!;
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple[25],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.purple[100]!),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.purple[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[700],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          suggestion[_selectedLanguage] ?? suggestion['en']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.purple[700],
                          ),
                        ),
                      ),
                      Icon(
                        Icons.touch_app,
                        size: 16,
                        color: Colors.purple[400],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[25],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue[100]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[600], size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tip: Click on any suggestion to use it as your response template',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableMedicinesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.medication, color: Colors.green),
              ),
              const SizedBox(width: 12),
              const Text(
                'Available Medicines',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ...(_availableMedicines.take(6).map((medicine) {
            final isSelected = _selectedMedicines.contains(medicine['name']);
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedMedicines.remove(medicine['name']);
                    } else {
                      _selectedMedicines.add(medicine['name']);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green[50] : Colors.grey[25],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? Colors.green : Colors.grey[200]!,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              _selectedMedicines.add(medicine['name']);
                            } else {
                              _selectedMedicines.remove(medicine['name']);
                            }
                          });
                        },
                        activeColor: Colors.green,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              medicine['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Stock: ${medicine['stock']} units',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '₹${medicine['price']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList()),

          if (_selectedMedicines.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[25],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calculate, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Selected Items Total: ₹${_calculateTotal()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResponseForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Response',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          // Availability Toggle
          Row(
            children: [
              const Text('Medicine Availability:'),
              const Spacer(),
              Switch(
                value: _isAvailable,
                onChanged: (value) {
                  setState(() {
                    _isAvailable = value;
                  });
                },
                activeColor: Colors.green,
              ),
              Text(
                _isAvailable ? 'Available' : 'Not Available',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: _isAvailable ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Response Message
          TextField(
            controller: _responseController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Response Message',
              hintText: 'Enter your response to the patient...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),

          const SizedBox(height: 16),

          if (_isAvailable) ...[
            // Price and Delivery Info
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Total Price (₹)',
                      prefixText: '₹ ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _deliveryTimeController,
                    decoration: InputDecoration(
                      labelText: 'Delivery Time',
                      hintText: 'e.g., 30 minutes',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _sendResponse,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Send Response',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getPriorityColor(PrescriptionPriority priority) {
    switch (priority) {
      case PrescriptionPriority.urgent:
        return Colors.red;
      case PrescriptionPriority.high:
        return Colors.orange;
      case PrescriptionPriority.medium:
        return Colors.blue;
      case PrescriptionPriority.low:
        return Colors.green;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  int _calculateTotal() {
    int total = 0;
    for (String medicineName in _selectedMedicines) {
      final medicine = _availableMedicines.firstWhere(
        (m) => m['name'] == medicineName,
        orElse: () => {'price': 0},
      );
      total += (medicine['price'] as int);
    }
    return total;
  }

  void _sendResponse() async {
    if (_responseController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a response message')),
      );
      return;
    }

    final provider = Provider.of<PrescriptionProvider>(context, listen: false);

    // Update prescription with response
    if (_isAvailable) {
      await provider.respondAllAvailable(
        widget.request.id,
        estimatedCost: _priceController.text.isNotEmpty
            ? double.tryParse(_priceController.text) ?? 0
            : null,
        notes: _responseController.text,
      );
    } else {
      await provider.respondUnavailable(
        widget.request.id,
        notes: _responseController.text,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Response sent successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }
}
