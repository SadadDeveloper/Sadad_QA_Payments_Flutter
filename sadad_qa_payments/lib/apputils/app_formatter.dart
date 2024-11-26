import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreditCardFormatter extends TextInputFormatter {
  final bool isRtl;

  CreditCardFormatter({required this.isRtl});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any non-digit characters from the input
    String unmaskedText = newValue.text.replaceAll(RegExp(r'\D'), '');
    // Create a masked version of the credit card number
    String maskedText = '';
    for (int i = 0; i < unmaskedText.length; i++) {
      maskedText += unmaskedText[i];
      if ((i + 1) % 4 == 0 && i != unmaskedText.length - 1) {
        maskedText+= '-'; // Add a space every 4 characters
      }
    }
    return TextEditingValue(
      text: maskedText,
      selection: TextSelection.collapsed(
        offset: maskedText.length,
      ),
    );
  }
}

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any non-digit characters from the input
    String unmaskedText = newValue.text.replaceAll(RegExp(r'\D'), '');

    // Create a masked version of the credit card number
    String maskedText = '';
    for (int i = 0; i < unmaskedText.length; i++) {
      maskedText += unmaskedText[i];
      if ((i + 1) % 2 == 0 && i != unmaskedText.length - 1) {
        maskedText += '/'; // Add a space every 4 characters
      }
    }

    return TextEditingValue(
      text: maskedText,
      selection: TextSelection.collapsed(offset: maskedText.length),
    );
  }
}
