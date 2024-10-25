package com.example.bank_feed_vs1
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat

class MyForegroundService : Service() {

    private lateinit var smsReceiver: SmsReceiver

    override fun onCreate() {
        super.onCreate()
        Log.d("MyForegroundService", "Service is running...")

        // Khởi động Foreground Service
        startForegroundService()

        // Đăng ký BroadcastReceiver để lắng nghe SMS
        smsReceiver = SmsReceiver()
        val filter = IntentFilter("android.provider.Telephony.SMS_RECEIVED")
        registerReceiver(smsReceiver, filter)
    }

    private fun startForegroundService() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = "foreground_service_channel"
            val channelName = "Foreground Service for SMS and Notifications"
            val channel = NotificationChannel(
                channelId,
                channelName,
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(channel)

            val notification: Notification = NotificationCompat.Builder(this, channelId)
                .setContentTitle("App is running")
                .setContentText("Lắng nghe SMS và thông báo từ các ứng dụng khác...")
                .build()

            startForeground(1, notification)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        // Hủy đăng ký BroadcastReceiver khi service bị hủy
        unregisterReceiver(smsReceiver)
        Log.d("MyForegroundService", "Service is destroyed...")
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}
