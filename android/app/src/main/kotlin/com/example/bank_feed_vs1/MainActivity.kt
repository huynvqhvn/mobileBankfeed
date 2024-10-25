package com.example.bank_feed_vs1

import android.content.Intent
import android.os.Bundle
import android.provider.Settings
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import android.util.Log
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.yourapp/notifications"
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        flutterEngine?.dartExecutor?.binaryMessenger?.let {
            MethodChannel(it, CHANNEL).setMethodCallHandler { call, result ->
                if (call.method == "openNotificationAccessSettings") {
                    val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
                    startActivity(intent)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
        }

        // Khởi động Foreground Service khi ứng dụng bắt đầu
        val serviceIntent = Intent(this, MyForegroundService::class.java)
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            startForegroundService(serviceIntent)
        } else {
            startService(serviceIntent)
        }
    }
}
