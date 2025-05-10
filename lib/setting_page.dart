import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _notifOn = true;
  String _theme = 'Terang';
  String _language = 'Indonesia';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pengaturan Umum',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 20),
            // Notifikasi
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: SwitchListTile(
                value: _notifOn,
                onChanged: (value) {
                  setState(() {
                    _notifOn = value;
                  });
                },
                title: Text('Notifikasi', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.w600)),
                subtitle: Text('Aktifkan atau nonaktifkan notifikasi'),
                activeColor: Colors.blue[800],
              ),
            ),
            SizedBox(height: 10),
            // Tema Aplikasi
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.color_lens, color: Colors.blue[800]),
                title: Text('Tema Aplikasi', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.w600)),
                subtitle: Text('Ubah tampilan aplikasi'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_theme, style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.w500)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios, color: Colors.blue[800]),
                  ],
                ),
                onTap: () async {
                  String? selected = await showDialog<String>(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: Text('Pilih Tema', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
                      children: [
                        SimpleDialogOption(
                          child: Text('Terang', style: TextStyle(color: _theme == 'Terang' ? Colors.blue[800] : Colors.black)),
                          onPressed: () => Navigator.pop(context, 'Terang'),
                        ),
                        SimpleDialogOption(
                          child: Text('Gelap', style: TextStyle(color: _theme == 'Gelap' ? Colors.blue[800] : Colors.black)),
                          onPressed: () => Navigator.pop(context, 'Gelap'),
                        ),
                      ],
                    ),
                  );
                  if (selected != null) {
                    setState(() {
                      _theme = selected;
                    });
                  }
                },
              ),
            ),
            SizedBox(height: 10),
            // Bahasa
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.language, color: Colors.blue[800]),
                title: Text('Bahasa', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.w600)),
                subtitle: Text('Pilih bahasa aplikasi'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_language, style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.w500)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios, color: Colors.blue[800]),
                  ],
                ),
                onTap: () async {
                  String? selected = await showDialog<String>(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: Text('Pilih Bahasa', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
                      children: [
                        SimpleDialogOption(
                          child: Text('Indonesia', style: TextStyle(color: _language == 'Indonesia' ? Colors.blue[800] : Colors.black)),
                          onPressed: () => Navigator.pop(context, 'Indonesia'),
                        ),
                        SimpleDialogOption(
                          child: Text('Inggris', style: TextStyle(color: _language == 'Inggris' ? Colors.blue[800] : Colors.black)),
                          onPressed: () => Navigator.pop(context, 'Inggris'),
                        ),
                      ],
                    ),
                  );
                  if (selected != null) {
                    setState(() {
                      _language = selected;
                    });
                  }
                },
              ),
            ),
            SizedBox(height: 10),
            // Tentang Aplikasi
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.info, color: Colors.blue[800]),
                title: Text('Tentang Aplikasi', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.w600)),
                subtitle: Text('Informasi tentang aplikasi'),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue[800]),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Tentang Aplikasi', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
                      content: Text('Versi 1.0.0'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Tutup', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30),
            // Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Tambahkan logika untuk menyimpan pengaturan
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: Colors.blue[800], size: 32),
                          SizedBox(width: 12),
                          Text('Perubahan berhasil disimpan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
                        ],
                      ),
                    ),
                  );
                  Future.delayed(Duration(seconds: 1), () {
                    Navigator.of(context, rootNavigator: true).pop();
                  });
                },
                icon: Icon(Icons.save, color: Colors.white),
                label: Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: EdgeInsets.symmetric(vertical: 16),
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
    );
  }
}
