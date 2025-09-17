import '../models/medicine.dart';
import '../models/smart_pharmacy_models.dart';

/// Service for checking government scheme eligibility and benefits
class GovernmentSchemeService {
  /// Check if patient is eligible for Ayushman Bharat PMJAY
  static bool isEligibleForPMJAY(Map<String, dynamic> patientProfile) {
    final income = patientProfile['annualIncome'] as double? ?? 0;
    final hasAyushmanCard = patientProfile['hasAyushmanCard'] as bool? ?? false;
    final familyCategory = patientProfile['familyCategory'] as String? ?? '';

    // Direct eligibility checks
    if (hasAyushmanCard) return true;

    // Income-based eligibility
    if (income <= 500000) return true; // ₹5 lakh annual income limit

    // Category-based eligibility
    final eligibleCategories = [
      'bpl',
      'landless_laborer',
      'tribal',
      'street_vendor',
      'construction_worker',
      'rag_picker',
      'domestic_worker',
    ];

    return eligibleCategories.contains(familyCategory.toLowerCase());
  }

  /// Check if patient is eligible for Jan Aushadhi scheme
  static bool isEligibleForJanAushadhi(Map<String, dynamic> patientProfile) {
    // Jan Aushadhi is universal - all citizens are eligible
    return true;
  }

  /// Check if patient is eligible for ESIC
  static bool isEligibleForESIC(Map<String, dynamic> patientProfile) {
    final hasESICard = patientProfile['hasESICard'] as bool? ?? false;
    final monthlyIncome = patientProfile['monthlyIncome'] as double? ?? 0;
    final employmentType = patientProfile['employmentType'] as String? ?? '';

    // Direct eligibility
    if (hasESICard) return true;

    // Employment and income-based eligibility
    return monthlyIncome <= 25000 &&
        (employmentType == 'organized_sector' ||
            employmentType == 'factory_worker');
  }

  /// Check state-specific scheme eligibility
  static bool isEligibleForStateScheme(
    GovernmentScheme scheme,
    Map<String, dynamic> patientProfile,
  ) {
    final patientState = patientProfile['state'] as String? ?? '';

    // Must be resident of the scheme's state
    if (scheme.state != 'central' &&
        patientState.toLowerCase() != scheme.state.toLowerCase()) {
      return false;
    }

    // Scheme-specific eligibility logic
    switch (scheme.id) {
      case 'scheme_004': // Delhi Mohalla Clinic
        return patientState.toLowerCase() == 'delhi';

      case 'scheme_005': // Tamil Nadu CMCHIS
        final hasRationCard = patientProfile['hasRationCard'] as bool? ?? false;
        return patientState.toLowerCase() == 'tamil nadu' && hasRationCard;

      case 'scheme_006': // Rajasthan RSBY
        final hasBhamashahCard =
            patientProfile['hasBhamashahCard'] as bool? ?? false;
        final isBPL = patientProfile['isBPL'] as bool? ?? false;
        return patientState.toLowerCase() == 'rajasthan' &&
            (hasBhamashahCard || isBPL);

      default:
        return true;
    }
  }

  /// Get applicable schemes for a patient
  static List<GovernmentScheme> getApplicableSchemes(
    Map<String, dynamic> patientProfile,
    List<GovernmentScheme> allSchemes,
  ) {
    final applicableSchemes = <GovernmentScheme>[];

    for (var scheme in allSchemes) {
      bool isEligible = false;

      switch (scheme.id) {
        case 'scheme_001': // Jan Aushadhi
          isEligible = isEligibleForJanAushadhi(patientProfile);
          break;
        case 'scheme_002': // PMJAY
          isEligible = isEligibleForPMJAY(patientProfile);
          break;
        case 'scheme_003': // ESIC
          isEligible = isEligibleForESIC(patientProfile);
          break;
        default:
          isEligible = isEligibleForStateScheme(scheme, patientProfile);
      }

      if (isEligible) {
        applicableSchemes.add(scheme);
      }
    }

    return applicableSchemes;
  }

  /// Calculate scheme benefits for a specific medicine
  static GovernmentSchemeMatch? calculateSchemeMatch(
    Medicine medicine,
    GovernmentScheme scheme,
    Map<String, dynamic> patientProfile,
  ) {
    // Check if medicine is covered by scheme
    if (!_isMedicineCoveredByScheme(medicine, scheme)) {
      return null;
    }

    // Check patient eligibility
    if (!_isPatientEligible(scheme, patientProfile)) {
      return null;
    }

    // Calculate subsidy
    double subsidizedPrice = medicine.price;
    double savingsAmount = 0.0;
    bool isFullyCovered = false;

    if (scheme.subsidyPercentage > 0) {
      // Percentage-based subsidy
      savingsAmount = medicine.price * (scheme.subsidyPercentage / 100);
      subsidizedPrice = medicine.price - savingsAmount;
    } else if (scheme.maxSubsidyAmount > 0) {
      // Fixed amount subsidy
      savingsAmount = scheme.maxSubsidyAmount.clamp(0, medicine.price);
      subsidizedPrice = medicine.price - savingsAmount;
    }

    isFullyCovered = subsidizedPrice <= 0;
    if (isFullyCovered) {
      subsidizedPrice = 0;
      savingsAmount = medicine.price;
    }

    final savingsPercentage = medicine.price > 0
        ? (savingsAmount / medicine.price) * 100
        : 0.0;

    return GovernmentSchemeMatch(
      scheme: scheme,
      medicineId: medicine.id,
      medicineName: medicine.name,
      originalPrice: medicine.price,
      subsidizedPrice: subsidizedPrice,
      savingsAmount: savingsAmount,
      savingsPercentage: savingsPercentage,
      isFullyCovered: isFullyCovered,
      eligibilityStatus: 'eligible',
      nearbyApprovedPharmacies: _getNearbyApprovedPharmacies(scheme),
    );
  }

  /// Get all scheme matches for a list of medicines
  static List<GovernmentSchemeMatch> getAllSchemeMatches(
    List<Medicine> medicines,
    List<GovernmentScheme> schemes,
    Map<String, dynamic> patientProfile,
  ) {
    final matches = <GovernmentSchemeMatch>[];

    for (var medicine in medicines) {
      for (var scheme in schemes) {
        final match = calculateSchemeMatch(medicine, scheme, patientProfile);
        if (match != null) {
          matches.add(match);
        }
      }
    }

    // Sort by savings amount (highest first)
    matches.sort((a, b) => b.savingsAmount.compareTo(a.savingsAmount));

    return matches;
  }

  /// Calculate total potential savings from all applicable schemes
  static Map<String, dynamic> calculateTotalSchemesSavings(
    List<PrescribedMedicine> prescribedMedicines,
    List<GovernmentScheme> schemes,
    Map<String, dynamic> patientProfile,
  ) {
    double totalOriginalCost = 0.0;
    double totalSubsidizedCost = 0.0;
    int medicinesWithSchemeSupport = 0;
    final schemeWiseSavings = <String, double>{};
    final detailedAnalysis = <Map<String, dynamic>>[];

    for (var prescMed in prescribedMedicines) {
      final medicine = prescMed.medicine;
      final quantity = prescMed.quantity;
      final medOriginalCost = medicine.price * quantity;

      totalOriginalCost += medOriginalCost;

      // Find best scheme match for this medicine
      GovernmentSchemeMatch? bestMatch;
      double maxSavings = 0.0;

      for (var scheme in schemes) {
        final match = calculateSchemeMatch(medicine, scheme, patientProfile);
        if (match != null && match.savingsAmount > maxSavings) {
          bestMatch = match;
          maxSavings = match.savingsAmount;
        }
      }

      if (bestMatch != null) {
        final medSubsidizedCost = bestMatch.subsidizedPrice * quantity;
        totalSubsidizedCost += medSubsidizedCost;
        medicinesWithSchemeSupport++;

        // Track scheme-wise savings
        final schemeName = bestMatch.scheme.shortName;
        schemeWiseSavings[schemeName] =
            (schemeWiseSavings[schemeName] ?? 0) + (maxSavings * quantity);

        detailedAnalysis.add({
          'medicineName': medicine.name,
          'originalPrice': medicine.price,
          'subsidizedPrice': bestMatch.subsidizedPrice,
          'quantity': quantity,
          'schemeName': schemeName,
          'savingsPerMedicine': maxSavings,
          'totalSavings': maxSavings * quantity,
          'isFullyCovered': bestMatch.isFullyCovered,
        });
      } else {
        totalSubsidizedCost += medOriginalCost;
        detailedAnalysis.add({
          'medicineName': medicine.name,
          'originalPrice': medicine.price,
          'quantity': quantity,
          'schemeName': null,
          'totalSavings': 0.0,
          'isFullyCovered': false,
        });
      }
    }

    final totalSavings = totalOriginalCost - totalSubsidizedCost;
    final savingsPercentage = totalOriginalCost > 0
        ? (totalSavings / totalOriginalCost) * 100
        : 0.0;

    return {
      'totalOriginalCost': totalOriginalCost,
      'totalSubsidizedCost': totalSubsidizedCost,
      'totalSavings': totalSavings,
      'savingsPercentage': savingsPercentage,
      'medicinesWithSchemeSupport': medicinesWithSchemeSupport,
      'totalMedicines': prescribedMedicines.length,
      'schemeWiseSavings': schemeWiseSavings,
      'detailedAnalysis': detailedAnalysis,
    };
  }

  /// Generate scheme eligibility report for patient
  static Map<String, dynamic> generateEligibilityReport(
    Map<String, dynamic> patientProfile,
    List<GovernmentScheme> allSchemes,
  ) {
    final eligibleSchemes = <GovernmentScheme>[];
    final ineligibleSchemes = <GovernmentScheme>[];
    final missingDocuments = <String, List<String>>{};
    final recommendations = <String>[];

    for (var scheme in allSchemes) {
      if (_isPatientEligible(scheme, patientProfile)) {
        eligibleSchemes.add(scheme);

        // Check for missing documents
        final missing = _getMissingDocuments(scheme, patientProfile);
        if (missing.isNotEmpty) {
          missingDocuments[scheme.shortName] = missing;
        }
      } else {
        ineligibleSchemes.add(scheme);

        // Generate recommendations for eligibility
        final recommendation = _getEligibilityRecommendation(
          scheme,
          patientProfile,
        );
        if (recommendation.isNotEmpty) {
          recommendations.add(recommendation);
        }
      }
    }

    return {
      'eligibleSchemes': eligibleSchemes.map((s) => s.toJson()).toList(),
      'ineligibleSchemes': ineligibleSchemes.map((s) => s.toJson()).toList(),
      'missingDocuments': missingDocuments,
      'recommendations': recommendations,
      'totalSchemes': allSchemes.length,
      'eligibleCount': eligibleSchemes.length,
    };
  }

  // Private helper methods

  static bool _isMedicineCoveredByScheme(
    Medicine medicine,
    GovernmentScheme scheme,
  ) {
    return scheme.coveredMedicines.contains('*') || // Universal coverage
        scheme.coveredMedicines.contains(medicine.category) ||
        scheme.coveredMedicines.contains(medicine.name) ||
        scheme.coveredMedicines.contains(medicine.chemicalComposition);
  }

  static bool _isPatientEligible(
    GovernmentScheme scheme,
    Map<String, dynamic> patientProfile,
  ) {
    switch (scheme.id) {
      case 'scheme_001':
        return isEligibleForJanAushadhi(patientProfile);
      case 'scheme_002':
        return isEligibleForPMJAY(patientProfile);
      case 'scheme_003':
        return isEligibleForESIC(patientProfile);
      default:
        return isEligibleForStateScheme(scheme, patientProfile);
    }
  }

  static List<String> _getNearbyApprovedPharmacies(GovernmentScheme scheme) {
    // This would typically query a database of approved pharmacies
    switch (scheme.id) {
      case 'scheme_001': // Jan Aushadhi
        return [
          'Jan Aushadhi Store - AIIMS Delhi',
          'Jan Aushadhi Medical Store - Safdarjung',
          'Jan Aushadhi Kendra - Lajpat Nagar',
        ];
      case 'scheme_002': // PMJAY
        return [
          'AIIMS Pharmacy',
          'Safdarjung Hospital Pharmacy',
          'Lady Hardinge Medical College Pharmacy',
        ];
      default:
        return ['Contact scheme helpline for approved pharmacies'];
    }
  }

  static List<String> _getMissingDocuments(
    GovernmentScheme scheme,
    Map<String, dynamic> patientProfile,
  ) {
    final missing = <String>[];
    final hasDocuments =
        patientProfile['documents'] as Map<String, bool>? ?? {};

    for (var requiredDoc in scheme.requiredDocuments) {
      final docKey = requiredDoc.toLowerCase().replaceAll(' ', '_');
      if (!(hasDocuments[docKey] ?? false)) {
        missing.add(requiredDoc);
      }
    }

    return missing;
  }

  static String _getEligibilityRecommendation(
    GovernmentScheme scheme,
    Map<String, dynamic> patientProfile,
  ) {
    switch (scheme.id) {
      case 'scheme_002': // PMJAY
        final income = patientProfile['annualIncome'] as double? ?? 0;
        if (income > 500000) {
          return 'To become eligible for ${scheme.shortName}, your annual family income should be less than ₹5 lakhs. Consider applying if your income documentation shows lower income.';
        }
        return 'Check your family\'s inclusion in SECC 2011 database or apply for Ayushman Card at nearest CSC center.';

      case 'scheme_003': // ESIC
        final monthlyIncome = patientProfile['monthlyIncome'] as double? ?? 0;
        if (monthlyIncome > 25000) {
          return 'ESIC coverage is available for employees earning up to ₹25,000 per month. Check with your employer for registration.';
        }
        return 'If you work in organized sector, ask your employer to register you under ESIC scheme.';

      default:
        return 'Check eligibility criteria for ${scheme.shortName} scheme and gather required documents.';
    }
  }
}
