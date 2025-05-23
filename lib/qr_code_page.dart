import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';

class QrCodePage extends StatefulWidget {
  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  String? _scannedCode;
  bool _isScanning = true;
  bool _flashOn = false;
  final MobileScannerController _controller = MobileScannerController();

  void _onDetect(BarcodeCapture capture) {
    if (!_isScanning) return;
    final code = capture.barcodes.first.rawValue;
    if (code != null) {
      setState(() {
        _scannedCode = code;
        _isScanning = false;
      });
      _controller.stop();
    }
  }

  void _startScan() {
    setState(() {
      _scannedCode = null;
      _isScanning = true;
    });
    _controller.start();
  }

  Future<void> _toggleFlash() async {
    await _controller.toggleTorch();
    setState(() {
      _flashOn = !_flashOn;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        final result = await _controller.analyzeImage(pickedFile.path);
        if (result != null) {
          final List<Barcode> barcodes = result as List<Barcode>;
          if (barcodes.isNotEmpty) {
            final barcode = barcodes.first;
            if (barcode.rawValue != null) {
              setState(() {
                _scannedCode = barcode.rawValue;
                _isScanning = false;
              });
              _controller.stop();
              return;
            }
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QR Code tidak ditemukan di gambar')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan saat memproses gambar')),
        );
      }
    }
  }

  Widget _buildResult() {
    if (_scannedCode == null) {
      return Text(
        'Arahkan kamera ke QR Code',
        style: TextStyle(fontSize: 16, color: Colors.blue[800]),
      );
    }
    final uri = Uri.tryParse(_scannedCode!);
    final isUrl = uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Hasil Scan:',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800]),
        ),
        SizedBox(height: 8),
        isUrl
            ? InkWell(
                onTap: () async {
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: Text(
                  _scannedCode!,
                  style: TextStyle(
                    color: Colors.blue[800],
                    decoration: TextDecoration.underline,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : Text(
                _scannedCode!,
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _startScan,
          child: Text(
            'Scan Lagi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(_flashOn ? Icons.flash_on : Icons.flash_off, color: Colors.white),
            onPressed: _toggleFlash,
            tooltip: 'Flash',
          ),
          IconButton(
            icon: Icon(Icons.photo, color: Colors.white),
            onPressed: _pickImage,
            tooltip: 'Scan dari Galeri',
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue[800]!, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: _isScanning
                ? MobileScanner(
                    controller: _controller,
                    onDetect: _onDetect,
                  )
                : Center(child: Icon(Icons.qr_code_2, size: 80, color: Colors.blue[800])),
          ),
          SizedBox(height: 24),
          _buildResult(),
        ],
      ),
    );
  }
}

