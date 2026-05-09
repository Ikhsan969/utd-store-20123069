// lib/presentation/home/widgets/battery_widget.dart
//
// Widget untuk menampilkan info baterai via Platform Channel
// Bisa ditambahkan ke halaman Home atau dibuat halaman tersendiri

import 'package:flutter/material.dart';
import '../../../core/platform/native_channel.dart';

class BatteryWidget extends StatefulWidget {
  const BatteryWidget({super.key});

  @override
  State<BatteryWidget> createState() => _BatteryWidgetState();
}

class _BatteryWidgetState extends State<BatteryWidget> {
  int _batteryLevel = -1;
  bool _loading = false;

  Future<void> _readBattery() async {
    setState(() => _loading = true);
    final level = await NativeChannel.getBatteryLevel();
    if (mounted) {
      setState(() {
        _batteryLevel = level;
        _loading = false;
      });

      // Tampilkan Native Toast setelah membaca baterai
      await NativeChannel.showToast('Baterai: $level% - UTD Store NIM:20123069');
    }
  }

  Color _batteryColor() {
    if (_batteryLevel >= 60) return Colors.greenAccent;
    if (_batteryLevel >= 30) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF0F3460)),
      ),
      child: Column(
        children: [
          const Text(
            '🔋 Status Baterai (Native)',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          if (_batteryLevel >= 0) ...[
            Text(
              '$_batteryLevel%',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: _batteryColor(),
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _batteryLevel / 100,
              backgroundColor: Colors.white12,
              color: _batteryColor(),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ] else ...[
            const Text(
              'Tekan tombol untuk membaca baterai',
              style: TextStyle(color: Colors.white54),
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loading ? null : _readBattery,
            icon: _loading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.battery_full),
            label: const Text('Baca Baterai & Toast'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3460),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
