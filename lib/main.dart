import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'saldo_provider.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'qr_code_page.dart';
import 'setting_page.dart';
import 'cek_saldo_page.dart';
import 'transfer_page.dart';
import 'deposito_page.dart';
import 'pembayaran_page.dart';
import 'pinjaman_page.dart';
import 'mutasi_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SaldoProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(username: ''),
        '/profile': (context) => ProfilePage(),
        '/qr': (context) => QrCodePage(),
        '/setting': (context) => SettingPage(),
        '/ceksaldo': (context) => CekSaldoPage(),
        '/transfer': (context) => TransferPage(username: ''),
        '/deposito': (context) => DepositoPage(),
        '/pembayaran': (context) => PembayaranPage(username: ''),
        '/pinjaman': (context) => PinjamanPage(),
        '/mutasi': (context) => MutasiPage(),
      },
    );
  }
}
