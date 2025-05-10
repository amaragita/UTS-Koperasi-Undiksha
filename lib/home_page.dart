import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'saldo_provider.dart';
import 'cek_saldo_page.dart';
import 'transfer_page.dart';
import 'deposito_page.dart';
import 'pembayaran_page.dart';
import 'pinjaman_page.dart';
import 'mutasi_page.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  final String? username;

  HomePage({this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _saldoVisible = false;
  final String _rekening = '1708938402';
  final String _jenisRekening = 'Koperasi Undiksha';
  int _selectedIndex = 0;
  String? _username;

  Future<void> _logout() async {
    // Tampilkan dialog konfirmasi
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text('Konfirmasi Logout'),
          content: Text('Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'Tidak',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Ya',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('username'); // Hapus data login dari SharedPreferences

      // Navigasi ke LoginPage tanpa tombol back
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _selectedIndex = 0;
      // Ambil username dari arguments jika belum ada
      if (_username == null || _username!.isEmpty) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        if (args != null && args['username'] != null) {
          _username = args['username'] as String;
        } else if (widget.username != null && widget.username!.isNotEmpty) {
          _username = widget.username;
        } else {
          _username = '';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            SizedBox(width: 8),
            Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/Logo_undiksha.png/640px-Logo_undiksha.png',
              width: 28,
              height: 28,
            ),
            SizedBox(width: 10),
            Text(
              'KOPERASI UNDIKSHA',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue[800],
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout, // Panggil fungsi logout
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfoCard(context),
            SizedBox(height: 20),
            _buildMenuGrid(context),
            SizedBox(height: 20),
            _buildHelpCard(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildUserInfoCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.blue[800],
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Foto profil bulat dan proporsional
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  'https://raw.githubusercontent.com/amaragita/Tugas-Layout-1/main/Foto%204x6.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 18),
          // Info user dan saldo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LUH PUTU AMARAGITA TIARANI WICAYA',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Anggota Aktif',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 10),
                // Saldo
                Row(
                  children: [
                    Text(
                      'Rp ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Consumer<SaldoProvider>(
                      builder: (context, saldoProvider, child) {
                        return Text(
                          _saldoVisible
                              ? saldoProvider.saldo.toStringAsFixed(0)
                              : '*******',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _saldoVisible = !_saldoVisible;
                        });
                      },
                      child: Icon(
                        _saldoVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Nomor rekening dan copy
                Row(
                  children: [
                    Text(
                      _rekening,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: _rekening));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Nomor rekening disalin!')),
                        );
                      },
                      child: Icon(Icons.copy, color: Colors.white, size: 18),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  _jenisRekening,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildMenuItem(context, Icons.account_balance_wallet_rounded, 'Cek Saldo', CekSaldoPage()),
        _buildMenuItem(context, Icons.send_rounded, 'Transfer', TransferPage(username: _username ?? '')),
        _buildMenuItem(context, Icons.savings_rounded, 'Deposito', DepositoPage()),
        _buildMenuItem(context, Icons.receipt_long_rounded, 'Pembayaran', PembayaranPage(username: _username ?? '')),
        _buildMenuItem(context, Icons.business_center_rounded, 'Pinjaman', PinjamanPage()),
        _buildMenuItem(context, Icons.history_rounded, 'Mutasi', MutasiPage()),
      ],
    );
  }

  Widget _buildHelpCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.phone, color: Colors.blue[800], size: 30),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Butuh Bantuan?',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  SizedBox(height: 5),
                  Text('Hubungi kami di nomor berikut:',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                  SizedBox(height: 5),
                  Text('089123456789',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue[800],
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          showUnselectedLabels: true,
          onTap: (index) {
            if (index == 1) {
              Navigator.pushNamed(context, '/qr').then((_) {
                setState(() {
                  _selectedIndex = 0;
                });
              });
            } else if (index == 2) {
              Navigator.pushNamed(context, '/profile', arguments: {'username': _username ?? ''}).then((_) {
                setState(() {
                  _selectedIndex = 0;
                });
              });
            } else if (index == 3) {
              Navigator.pushNamed(context, '/setting').then((_) {
                setState(() {
                  _selectedIndex = 0;
                });
              });
            }
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            _buildNavBarItem(Icons.home, 'Beranda', 0),
            _buildNavBarItem(Icons.qr_code, 'Kode QR', 1),
            _buildNavBarItem(Icons.person, 'Profil', 2),
            _buildNavBarItem(Icons.settings, 'Pengaturan', 3),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavBarItem(IconData icon, String label, int index) {
    final isActive = _selectedIndex == index;
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          Icon(icon, size: 30, color: isActive ? Colors.blue[800] : Colors.grey[400]),
          SizedBox(height: 4),
          if (isActive)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.blue[800],
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      label: label,
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String label, Widget page) {
    return GestureDetector(
      onTap: () {
        String route = '/';
        if (page is CekSaldoPage) route = '/ceksaldo';
        else if (page is TransferPage) route = '/transfer';
        else if (page is DepositoPage) route = '/deposito';
        else if (page is PembayaranPage) route = '/pembayaran';
        else if (page is PinjamanPage) route = '/pinjaman';
        else if (page is MutasiPage) route = '/mutasi';
        Navigator.pushNamed(context, route);
      },
      child: Card(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(10),
                child: Icon(icon, size: 26, color: Colors.blue[800]),
              ),
              SizedBox(height: 7),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
