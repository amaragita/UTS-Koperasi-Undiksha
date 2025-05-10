import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Hapus semua karakter non-digit
    String cleanText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    
    // Konversi ke double
    double value = double.tryParse(cleanText) ?? 0;
    
    // Format dengan pemisah ribuan
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    
    String formattedText = formatter.format(value).trim();
    
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
} 
