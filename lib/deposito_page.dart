import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'saldo_provider.dart';

class DepositoPage extends StatefulWidget {
  @override
  _DepositoPageState createState() => _DepositoPageState();
}

class _DepositoPageState extends State<DepositoPage> {
  String? _selectedDuration;
  String? _sumberDana;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();

  final List<Map<String, String>> _durations = [
    {'value': '3', 'label': '3 Bulan (Pendek)'},
    {'value': '6', 'label': '6 Bulan (Menengah)'},
    {'value': '12', 'label': '12 Bulan (Panjang)'},
  ];

  void _simpanDeposito() {
    final saldoProvider = Provider.of<SaldoProvider>(context, listen: false);
    final jumlah = double.tryParse(_amountController.text.replaceAll(',', '').replaceAll('.', '')) ?? 0;
    final token = _tokenController.text.trim();
    if (_sumberDana == null || _selectedDuration == null || jumlah <= 0 || token.isEmpty) {
      _showBottomSheet('Harap lengkapi semua data!', false);
      return;
    }
    if (token != '123456') {
      _showBottomSheet('Token salah!', false);
      return;
    }

    if (_sumberDana == 'tabungan') {
      try {
        saldoProvider.kurangiSaldo(jumlah, keterangan: 'Deposito dari Tabungan');
        _showBottomSheet('Deposito berhasil dari tabungan!', true, popToHome: true);
      } catch (e) {
        _showBottomSheet(e.toString(), false);
      }
    } else if (_sumberDana == 'bank_lain') {
      saldoProvider.tambahSaldo(jumlah, keterangan: 'Deposito dari Bank Lain');
      _showBottomSheet('Deposito berhasil dari bank lain!', true, popToHome: true);
    }
  }

  void _showBottomSheet(String message, bool success, {bool popToHome = false}) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(success ? Icons.check_circle : Icons.error,
                color: Colors.blue[800], size: 48),
            SizedBox(height: 12),
            Text(
              success ? 'Sukses' : 'Gagal',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 10),
            Text(message, style: TextStyle(fontSize: 15)),
            SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Tutup bottom sheet
                  if (popToHome && success) {
                    Navigator.pop(context); // Kembali ke HomePage
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Kembali', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deposito', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<SaldoProvider>(
                      builder: (context, saldoProvider, _) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Saldo Anda sekarang:', style: TextStyle(fontSize: 15, color: Colors.blue[800], fontWeight: FontWeight.w600)),
                          SizedBox(height: 4),
                          Text('Rp. ${saldoProvider.saldo.toStringAsFixed(0)}', style: TextStyle(fontSize: 20, color: Colors.blue[800], fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                    Text('Jangka Waktu', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedDuration,
                      items: _durations
                          .map((e) => DropdownMenuItem(
                                value: e['value'],
                                child: Text(
                                  e['label']!,
                                  style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.w600),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDuration = value;
                        });
                      },
                      icon: Icon(Icons.arrow_drop_down, color: Colors.blue[800]),
                      dropdownColor: Colors.white,
                      style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue[800]!, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text('Jumlah Deposito', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                    SizedBox(height: 8),
                    TextField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: 'Masukkan jumlah',
                        labelStyle: TextStyle(color: Colors.blue[800]),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue[800]!, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    Text('Token', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                    SizedBox(height: 8),
                    TextField(
                      controller: _tokenController,
                      decoration: InputDecoration(
                        labelText: 'Masukkan token',
                        labelStyle: TextStyle(color: Colors.blue[800]),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue[800]!, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    Text('Sumber Dana', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _sumberDana,
                      items: [
                        DropdownMenuItem(value: 'tabungan', child: Text('Dari Tabungan Sendiri')),
                        DropdownMenuItem(value: 'bank_lain', child: Text('Dari Bank Lain')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _sumberDana = value;
                        });
                      },
                      icon: Icon(Icons.arrow_drop_down, color: Colors.blue[800]),
                      iconEnabledColor: Colors.blue[800],
                      dropdownColor: Colors.white,
                      decoration: InputDecoration(
                        labelText: 'Sumber Dana',
                        labelStyle: TextStyle(color: Colors.blue[800]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue[800]!, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
                        ),
                      ),
                      style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _simpanDeposito,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'Simpan',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}