import 'package:intl/intl.dart';

class FormatHelper {
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static double parseCurrency(String amount) {
    // Hapus semua karakter non-digit kecuali titik
    String cleanAmount = amount.replaceAll(RegExp(r'[^\d.]'), '');
    
    // Hapus semua titik (karena ini adalah pemisah ribuan)
    cleanAmount = cleanAmount.replaceAll('.', '');
    
    // Konversi ke double
    return double.tryParse(cleanAmount) ?? 0;
  }
} 