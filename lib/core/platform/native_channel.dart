// lib/core/platform/native_channel.dart
//
// ⭐ Platform Channel - MethodChannel ke Kotlin
// Membaca baterai dan Native Toast Android

import 'package:flutter/services.dart';

class NativeChannel {
  static const MethodChannel _channel = MethodChannel('com.utdstore/native');

  // Membaca persentase baterai
  static Future<int> getBatteryLevel() async {
    try {
      final int batteryLevel = await _channel.invokeMethod('getBatteryLevel');
      return batteryLevel;
    } on PlatformException catch (e) {
      print('Error getBatteryLevel: ${e.message}');
      return -1;
    }
  }

  // Tampilkan Native Toast Android
  static Future<void> showToast(String message) async {
    try {
      await _channel.invokeMethod('showToast', {'message': message});
    } on PlatformException catch (e) {
      print('Error showToast: ${e.message}');
    }
  }
}
