import 'package:flutter/foundation.dart';

class LegalModel {
  final String documentId;
  final String termsAndConditions;
  final String privacyPolicy;

  LegalModel({
    @required this.documentId,
    @required this.termsAndConditions,
    @required this.privacyPolicy,
  });

  Map<String, dynamic> toMap() {
    return {
      'terms': termsAndConditions,
      'privacyPolicy': privacyPolicy,
    };
  }

  static LegalModel fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) return null;
  
    return LegalModel(
      documentId: documentId,
      termsAndConditions: data['termsAndConditions'],
      privacyPolicy: data['privacyPolicy'],
    );
  }

  
}
