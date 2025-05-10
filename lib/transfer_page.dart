import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'saldo_provider.dart';
import 'utils/format_helper.dart';
import 'utils/currency_input_formatter.dart';

class TransferPage extends StatefulWidget {
  final String username;

  const TransferPage({Key? key, required this.username}) : super(key: key);

  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final TextEditingController _rekeningController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();

  void _transferSaldo() {
    final saldoProvider = Provider.of<SaldoProvider>(context, listen: false);
    final jumlah = FormatHelper.parseCurrency(_jumlahController.text);
    final rekening = _rekeningController.text.trim();

    if (jumlah <= 0 || rekening.isEmpty) {
      _showDialog('Nomor rekening atau jumlah transfer tidak valid', isSuccess: false);
      return;
    }

    // Untuk Validasi saldo
    try {
      saldoProvider.kurangiSaldo(jumlah); // Kurangi saldo melalui Provider
      final formattedJumlah = FormatHelper.formatCurrency(jumlah);

      // Tampilkan konfirmasi sukses dengan bottom sheet/card
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
              Icon(Icons.check_circle, color: Colors.blue[800], size: 48),
              SizedBox(height: 12),
              Text('Transfer Berhasil!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue[800])),
              SizedBox(height: 10),
              Text('Anda telah mentransfer', style: TextStyle(fontSize: 15)),
              SizedBox(height: 4),
              Text(
                formattedJumlah,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue[800]),
              ),
              SizedBox(height: 4),
              Text('ke Nomor Rekening: $rekening', style: TextStyle(fontSize: 15)),
              SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup bottom sheet
                    Navigator.pop(context); // Kembali ke HomePage
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
    } catch (e) {
      _showDialog(e.toString(), isSuccess: false); // Tampilkan error jika saldo tidak mencukupi
    }
  }

  void _showDialog(String message, {required bool isSuccess}) {
    if (isSuccess) {
      // Sukses tetap pakai bottom sheet biru
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
              Icon(Icons.check_circle, color: Colors.blue[800], size: 48),
              SizedBox(height: 12),
              Text('Transfer Berhasil!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue[800])),
              SizedBox(height: 10),
              Text(message, style: TextStyle(fontSize: 15)),
              SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup bottom sheet
                    Navigator.pop(context); // Kembali ke HomePage
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
    } else {
      // Gagal pakai bottom sheet merah
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
              Icon(Icons.error, color: Colors.red[700], size: 48),
              SizedBox(height: 12),
              Text('Transfer Gagal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red[700])),
              SizedBox(height: 10),
              Text(message, style: TextStyle(fontSize: 15)),
              SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup bottom sheet
                    Navigator.pop(context); // Kembali ke HomePage
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

  @override
  Widget build(BuildContext context) {
    final saldoProvider = Provider.of<SaldoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Saldo', style: TextStyle(color: Colors.white)),
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
                      FormatHelper.formatCurrency(saldoProvider.saldo),
                      style: TextStyle(fontSize: 20, color: Colors.blue[800], fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _rekeningController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Nomor Rekening Tujuan',
                        labelStyle: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.w600),
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
                    SizedBox(height: 10),
                    TextField(
                      controller: _jumlahController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyInputFormatter(),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Jumlah Transfer',
                        labelStyle: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.w600),
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _transferSaldo,
                        child: const Text(
                          'Transfer',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
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
