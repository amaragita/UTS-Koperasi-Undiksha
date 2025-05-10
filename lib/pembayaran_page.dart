import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'saldo_provider.dart';
import 'utils/format_helper.dart';
import 'utils/currency_input_formatter.dart';

class PembayaranPage extends StatefulWidget {
  final String username;

  const PembayaranPage({Key? key, required this.username}) : super(key: key);

  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  final TextEditingController _billNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedJenisPembayaran;

  final List<String> _jenisPembayaran = [
    'Listrik',
    'Air',
    'Internet',
    'Telepon',
    'Lainnya',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran', style: TextStyle(color: Colors.white)),
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
              child: Padding(
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
                          Text(FormatHelper.formatCurrency(saldoProvider.saldo), style: TextStyle(fontSize: 20, color: Colors.blue[800], fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                    Text('Jenis Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedJenisPembayaran,
                      items: _jenisPembayaran.map((String jenis) {
                        return DropdownMenuItem<String>(
                          value: jenis,
                          child: Text(jenis, style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.w600)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedJenisPembayaran = newValue;
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
                    Text('Nomor Tagihan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                    SizedBox(height: 8),
                    TextField(
                      controller: _billNumberController,
                      decoration: InputDecoration(
                        labelText: 'Masukkan nomor tagihan',
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
                    ),
                    SizedBox(height: 16),
                    Text('Jumlah Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                    SizedBox(height: 8),
                    TextField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: 'Masukkan jumlah pembayaran',
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
                      inputFormatters: [
                        CurrencyInputFormatter(),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _bayar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'Bayar',
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

  void _bayar() {
    final saldoProvider = Provider.of<SaldoProvider>(context, listen: false);
    final jumlahPembayaran = FormatHelper.parseCurrency(_amountController.text);
    final nomorTagihan = _billNumberController.text;

    if (_selectedJenisPembayaran == null) {
      _showBottomSheet('Harap pilih jenis pembayaran!', false);
    } else if (nomorTagihan.isNotEmpty && jumlahPembayaran > 0) {
      try {
        saldoProvider.kurangiSaldo(jumlahPembayaran, keterangan: 'Pembayaran $_selectedJenisPembayaran - $nomorTagihan');
        _showBottomSheet('Pembayaran berhasil!', true, popToHome: true);
      } catch (e) {
        _showBottomSheet(e.toString(), false);
      }
    } else {
      _showBottomSheet('Harap lengkapi semua data!', false);
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
}