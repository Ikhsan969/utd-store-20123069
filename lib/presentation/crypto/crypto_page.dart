// lib/presentation/crypto/crypto_page.dart
//
// ⭐ LOGIKA PERSONAL ANTI-AI:
// NIM: 20123069 → 2 digit terakhir = 69
// Isolate looping: 69 × 10.000.000 = 690.000.000 kali
// Animasi harga TIDAK boleh freeze saat isolate berjalan!

import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// ⭐ Fungsi top-level untuk Isolate (wajib di luar class)
// Isolate tidak bisa akses kelas/closure, harus top-level function
void _taxCalculationIsolate(SendPort sendPort) {
  // ⭐ 2 digit terakhir NIM = 69 → loop 69 × 10.000.000 = 690.000.000
  const int twoLastDigitsNIM = 69;
  const int multiplier = 10000000;
  final int totalLoop = twoLastDigitsNIM * multiplier;

  double sum = 0;
  for (int i = 1; i <= totalLoop; i++) {
    sum += i;
  }

  // Kirim hasil balik ke main isolate
  // Pajak kripto = 0.1% dari total sum (simulasi)
  final double tax = sum * 0.001;
  sendPort.send('Loop: $totalLoop kali\nHasil: ${sum.toStringAsExponential(4)}\nPajak (0.1%): \$${tax.toStringAsExponential(4)}');
}

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage>
    with SingleTickerProviderStateMixin {
  WebSocketChannel? _channel;
  String _btcPrice = 'Menghubungkan...';
  bool _isCalculating = false;
  String? _taxResult;
  late AnimationController _priceAnimController;
  late Animation<Color?> _priceColorAnim;

  @override
  void initState() {
    super.initState();
    _priceAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _priceColorAnim = ColorTween(
      begin: const Color(0xFFE94560),
      end: Colors.greenAccent,
    ).animate(_priceAnimController);

    _connectWebSocket();
  }

  void _connectWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://ws.coincap.io/prices?assets=bitcoin'),
    );

    _channel!.stream.listen(
      (data) {
        final Map<String, dynamic> json = jsonDecode(data as String);
        final price = json['bitcoin'];
        if (price != null && mounted) {
          setState(() {
            _btcPrice = '\$${double.parse(price.toString()).toStringAsFixed(2)}';
          });
          // Animasi flash saat harga update
          _priceAnimController.forward().then((_) => _priceAnimController.reverse());
        }
      },
      onError: (error) {
        if (mounted) setState(() => _btcPrice = 'Koneksi error');
      },
      onDone: () {
        if (mounted) setState(() => _btcPrice = 'Terputus');
      },
    );
  }

  // ⭐ Jalankan Isolate - harga crypto tidak boleh freeze!
  Future<void> _runTaxCalculation() async {
    setState(() {
      _isCalculating = true;
      _taxResult = null;
    });

    // Buat ReceivePort untuk menerima hasil dari Isolate
    final receivePort = ReceivePort();

    // Spawn isolate dengan top-level function
    await Isolate.spawn(_taxCalculationIsolate, receivePort.sendPort);

    // Tunggu hasil dari isolate
    final result = await receivePort.first as String;

    if (mounted) {
      setState(() {
        _isCalculating = false;
        _taxResult = result;
      });
    }
  }

  @override
  void dispose() {
    _channel?.sink.close();
    _priceAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: const Text(
          'Crypto Hub',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Card harga Bitcoin real-time
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF16213E),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF0F3460), width: 1),
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.currency_bitcoin, color: Color(0xFFF7931A), size: 32),
                      SizedBox(width: 8),
                      Text(
                        'Bitcoin (BTC)',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // ⭐ Animasi harga - tidak boleh freeze saat isolate berjalan!
                  AnimatedBuilder(
                    animation: _priceColorAnim,
                    builder: (context, child) {
                      return Text(
                        _btcPrice,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: _priceColorAnim.value ?? const Color(0xFFE94560),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '🔴 LIVE via WebSocket',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tombol Kalkulasi Pajak Kripto
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isCalculating ? null : _runTaxCalculation,
                icon: _isCalculating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.calculate),
                label: Text(
                  _isCalculating
                      ? 'Menghitung (NIM:69 × 10jt loop)...'
                      : 'Kalkulasi Pajak Kripto',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE94560),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            if (_isCalculating) ...[
              const SizedBox(height: 12),
              const Text(
                '⚙️ Isolate sedang berjalan di background...\nHarga BTC di atas tetap update!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],

            // Hasil kalkulasi
            if (_taxResult != null) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F3460),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '✅ Hasil Kalkulasi Isolate',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _taxResult!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'NIM: 20123069 → 2 digit terakhir = 69\nTotal loop: 69 × 10.000.000 = 690.000.000',
                      style: TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
