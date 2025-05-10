import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Periksa apakah pengguna sudah login
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    if (username != null) {
      // Jika username tersimpan, langsung navigasi ke HomePage
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: {'username': username},
      );
    }
  }

  Future<void> _login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username == "Amaragita" && password == "2315091030") {
      // Simpan username ke SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);

      // Navigasi ke HomePage
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: {'username': username},
      );
    } else {
      // Tampilkan pesan kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username atau password salah!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'KOPERASI UNDIKSHA',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.blue[800],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/Logo_undiksha.png/640px-Logo_undiksha.png',
                width: 150,
                height: 150,
              ),
              SizedBox(height: 60),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!, width: 1.5),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[800]!, width: 1.5),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text(
                  'LOGIN',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      final TextEditingController namaController = TextEditingController();
                      final TextEditingController hpController = TextEditingController();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Daftar Mbanking', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: namaController,
                                decoration: InputDecoration(
                                  labelText: 'Nama Lengkap',
                                  labelStyle: TextStyle(color: Colors.blue[800]),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue[800]!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue[800]!, width: 1.5),
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              TextField(
                                controller: hpController,
                                decoration: InputDecoration(
                                  labelText: 'No. Handphone',
                                  labelStyle: TextStyle(color: Colors.blue[800]),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue[800]!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue[800]!, width: 1.5),
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                if (namaController.text.isEmpty || hpController.text.isEmpty) {
                                  // Notifikasi gagal
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Gagal', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                      content: Text('Harap isi semua data!', style: TextStyle(color: Colors.red)),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Tutup', style: TextStyle(color: Colors.blue[800])),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Berhasil', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
                                      content: Text('Pendaftaran berhasil, silakan tunggu verifikasi admin.', style: TextStyle(color: Colors.blue[800])),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Tutup', style: TextStyle(color: Colors.blue[800])),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: Text('Kirim', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('Daftar Mbanking', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
                  ),
                  TextButton(
                    onPressed: () {
                      final TextEditingController kontakController = TextEditingController();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Lupa Password', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: kontakController,
                                decoration: InputDecoration(
                                  labelText: 'No. HP atau Email',
                                  labelStyle: TextStyle(color: Colors.blue[800]),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue[800]!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue[800]!, width: 1.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                if (kontakController.text.isEmpty) {
                                  // Notifikasi gagal
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Gagal', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                      content: Text('Harap isi semua data!', style: TextStyle(color: Colors.red)),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Tutup', style: TextStyle(color: Colors.blue[800])),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Berhasil', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
                                      content: Text('Permintaan reset password telah dikirim ke admin.', style: TextStyle(color: Colors.blue[800])),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Tutup', style: TextStyle(color: Colors.blue[800])),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: Text('Kirim', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('Lupa password?', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
