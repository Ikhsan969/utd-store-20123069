package com.utdstore.utd_store

import android.content.Context
import android.os.BatteryManager
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.utdstore/native"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getBatteryLevel") {
                    val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
                    val level = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
                    if (level >= 0) {
                        result.success(level)
                    } else {
                        result.error("UNAVAILABLE", "Battery level not available.", null)
                    }
                } else if (call.method == "showToast") {
                    val message = call.argument<String>("message") ?: "Hello!"
                    Toast.makeText(applicationContext, message, Toast.LENGTH_SHORT).show()
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }
}
