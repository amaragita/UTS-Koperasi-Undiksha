import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ambil username dari arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final username = args?['username'] ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        elevation: 0,
        title: Text('Profil Anggota', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header biru tua tanpa logo
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 30, top: 30),
              decoration: BoxDecoration(
                color: Colors.blue[800],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://raw.githubusercontent.com/amaragita/Tugas-Layout-1/main/Foto%204x6.png',
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 96,
                          height: 96,
                          color: Colors.white,
                          child: Icon(Icons.person, size: 48, color: Colors.grey[400]),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Luh Putu Amaragita Tiarani Wicaya',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  if (username != null && username.toString().isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '@$username',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Info cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildInfoCard(Icons.credit_card, 'Nomor Rekening', '1708938402'),
                  SizedBox(height: 12),
                  _buildInfoCard(Icons.phone, 'No. Handphone', '08977217561'),
                  SizedBox(height: 12),
                  _buildInfoCard(Icons.email, 'Email', 'amaragita@student.undiksha.ac.id'),
                  SizedBox(height: 12),
                  _buildInfoCard(Icons.info, 'Versi Aplikasi', '1.0.0'),
                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
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
                          await prefs.remove('username');
                          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                        }
                      },
                      icon: Icon(Icons.logout, color: Colors.white),
                      label: Text(
                        'LOGOUT',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String subtitle) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 3,
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[800], size: 26),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
      ),
    );
  }
}