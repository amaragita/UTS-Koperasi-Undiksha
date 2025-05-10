import 'package:flutter/material.dart';

class SaldoProvider with ChangeNotifier {
  double _saldo = 1200000;
  final List<Map<String, dynamic>> _mutasi = [];

  double get saldo => _saldo;
  List<Map<String, dynamic>> get mutasi => List.unmodifiable(_mutasi);

  void kurangiSaldo(double jumlah, {String? keterangan}) {
    if (jumlah <= 0) {
      throw Exception('Jumlah harus lebih dari 0!');
    }
    if (jumlah > _saldo) {
      throw Exception('Saldo tidak mencukupi!');
    }
    _saldo -= jumlah;
    _mutasi.add({
      'jenis': keterangan?.toLowerCase().contains('pembayaran') == true ? 'pembayaran' : 'transfer',
      'tanggal': DateTime.now(),
      'jumlah': jumlah,
      'keterangan': keterangan,
    });
    notifyListeners();
  }

  void tambahSaldo(double jumlah, {String? keterangan}) {
    if (jumlah <= 0) {
      throw Exception('Jumlah harus lebih dari 0!');
    }
    _saldo += jumlah;
    _mutasi.add({
      'jenis': keterangan?.toLowerCase().contains('deposito') == true ? 'deposito' : 'pinjaman',
      'tanggal': DateTime.now(),
      'jumlah': jumlah,
      'keterangan': keterangan,
    });
    notifyListeners();
  }

  void resetSaldo() {
    _saldo = 1200000;
    _mutasi.clear();
    notifyListeners();
  }
}