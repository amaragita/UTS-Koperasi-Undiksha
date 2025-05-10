import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'saldo_provider.dart';
import 'utils/format_helper.dart';


class CekSaldoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final saldoProvider = Provider.of<SaldoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cek Saldo', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Card(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.account_balance_wallet_rounded, color: Colors.blue[800], size: 40),
                ),
                SizedBox(height: 18),
                Text(
                  'Saldo Anda',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue[800]),
                ),
                SizedBox(height: 10),
                Text(
                  FormatHelper.formatCurrency(saldoProvider.saldo),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}