import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'saldo_provider.dart';

class PinjamanPage extends StatefulWidget {
  @override
  _PinjamanPageState createState() => _PinjamanPageState();
}

class _PinjamanPageState extends State<PinjamanPage> {
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _loanDurationController = TextEditingController();

  void _ajukanPinjaman() {
    final saldoProvider = Provider.of<SaldoProvider>(context, listen: false);
    final jumlahPinjaman = double.tryParse(_loanAmountController.text) ?? 0;
    final jangkaWaktu = _loanDurationController.text.trim();

    if (jumlahPinjaman <= 0 || jangkaWaktu.isEmpty) {
      _showBottomSheet('Harap lengkapi semua data!', false);
      return;
    }

    try {
      saldoProvider.tambahSaldo(jumlahPinjaman, keterangan: 'Pinjaman - $jangkaWaktu bulan');
      _showBottomSheet('Pinjaman berhasil diajukan!', true, popToHome: true);
    } catch (e) {
      _showBottomSheet(e.toString(), false);
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
    final saldoProvider = Provider.of<SaldoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Pinjaman', style: TextStyle(color: Colors.white)),
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
                    Text(
                      'Saldo Anda sekarang:',
                      style: TextStyle(fontSize: 15, color: Colors.blue[800], fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Rp. ${saldoProvider.saldo.toStringAsFixed(0)}',
                      style: TextStyle(fontSize: 20, color: Colors.blue[800], fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.money_rounded, color: Colors.blue[800], size: 32),
                    ),
                    SizedBox(height: 12),
                    Text('Ajukan Pinjaman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[800])),
                    SizedBox(height: 16),
                    Text('Jumlah Pinjaman', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                    SizedBox(height: 8),
                    TextField(
                      controller: _loanAmountController,
                      decoration: InputDecoration(
                        labelText: 'Masukkan jumlah pinjaman',
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
                    Text('Jangka Waktu', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                    SizedBox(height: 8),
                    TextField(
                      controller: _loanDurationController,
                      decoration: InputDecoration(
                        labelText: 'Masukkan jangka waktu (bulan)',
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
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _ajukanPinjaman,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'Ajukan',
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