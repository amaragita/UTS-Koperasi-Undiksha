import 'package:flutter/material.dart';

class QrCodePage extends StatefulWidget {
  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  int _selectedTab = 0; // 0: Scan QR, 1: Kode Bayar, 2: Terima Dana
  final String _rekening = '1708938402';
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Scan QR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [SizedBox(width: 16)],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 24),
              Text(
                'Scan QR atau\nbarcode untuk memulai transaksi',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.blue[800], fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 24),
              if (_selectedTab == 2)
                // Terima Dana: tampilkan QR code besar
                Expanded(
                  child: Center(
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                      ),
                      child: Icon(Icons.qr_code, size: 180, color: Colors.blue[800]),
                    ),
                  ),
                )
              else if (_selectedTab == 1)
                // Kode Bayar: form rekening & password transaksi
                Expanded(
                  child: Center(
                    child: Container(
                      width: 320,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rekening', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                          SizedBox(height: 6),
                          TextField(
                            readOnly: true,
                            controller: TextEditingController(text: _rekening),
                            decoration: InputDecoration(
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
                          SizedBox(height: 18),
                          Text('Password Transaksi', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                          SizedBox(height: 6),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Masukkan password transaksi',
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
                          SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[800],
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('Bayar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                // Area kamera dummy dengan grid biru
                Expanded(
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 320,
                          height: 320,
                          decoration: BoxDecoration(
                            color: Colors.blue[800]!.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _GridPainter(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 24),
              // Bottom nav
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    _buildTabButton('Scan QR', 0),
                    _buildTabButton('Kode Bayar', 1),
                    _buildTabButton('Terima Dana', 2),
                  ],
                ),
              ),
            ],
          ),
          // Logo QRIS kiri bawah
          Positioned(
            left: 20,
            bottom: 80,
            child: Image.asset(
              'assets/qris_logo.png',
              width: 60,
              height: 28,
              errorBuilder: (c, e, s) => SizedBox.shrink(),
            ),
          ),
          // Dua tombol bulat kanan bawah hanya di Scan QR
          if (_selectedTab == 0)
            Positioned(
              right: 30,
              bottom: 90,
              child: Column(
                children: [
                  _circleButton(Icons.flash_on, Colors.blue[800]!),
                  SizedBox(height: 12),
                  _circleButton(Icons.image, Colors.blue[800]!),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int idx) {
    final bool active = _selectedTab == idx;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = idx),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? Colors.blue[800] : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.blue[800]!, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : Colors.blue[800],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleButton(IconData icon, Color color) {
    return Material(
      color: color.withOpacity(0.15),
      shape: CircleBorder(),
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(icon, color: color, size: 26),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue[800]!.withOpacity(0.7)
      ..strokeWidth = 1;
    // Horizontal lines
    for (double y = 0; y < size.height; y += 16) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Vertical lines
    for (double x = 0; x < size.width; x += 16) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

