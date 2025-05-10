import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'saldo_provider.dart';

class MutasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final saldoProvider = Provider.of<SaldoProvider>(context);
    final mutasi = saldoProvider.mutasi;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mutasi', style: TextStyle(color: Colors.white)),
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
      body: mutasi.isEmpty
          ? Center(
              child: Text(
                'Belum ada histori transaksi.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: mutasi.length,
              itemBuilder: (context, index) {
                final item = mutasi[index];
                final jenisTransaksi = (item['jenis'] ?? 'Lainnya').toString().toLowerCase();
                final keterangan = item['keterangan'] ?? _getKeteranganTransaksi(jenisTransaksi);
                final isPengurangan = jenisTransaksi == 'transfer' || jenisTransaksi == 'pembayaran';

                return Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              keterangan,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue[800],
                              ),
                            ),
                            Text(
                              '${isPengurangan ? '-' : '+'} Rp. ${item['jumlah'].toStringAsFixed(0)}',
                              style: TextStyle(
                                color: isPengurangan ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tanggal: ${item['tanggal'].toString().split('.')[0]}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _getKeteranganTransaksi(String jenis) {
    switch (jenis) {
      case 'transfer':
        return 'Transfer';
      case 'pembayaran':
        return 'Pembayaran';
      case 'deposito':
        return 'Deposito';
      case 'pinjaman':
        return 'Pinjaman';
      default:
        return 'Lainnya';
    }
  }
}