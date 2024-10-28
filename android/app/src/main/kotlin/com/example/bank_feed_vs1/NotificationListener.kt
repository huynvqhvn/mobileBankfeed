package com.example.bank_feed_vs1
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import androidx.work.OneTimeWorkRequest
import androidx.work.WorkManager
import androidx.work.Data

class NotificationListener : NotificationListenerService() {

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val packageName = sbn.packageName // Tên gói ứng dụng
        val notificationContent = sbn.notification.extras.getString("android.text") ?: "No Content" // Nội dung thông báo
        val timestamp = sbn.postTime // Thời gian thông báo được tạo

        // Log dữ liệu thông báo
        Log.d("NotificationListener", "Notification from: $packageName, content: $notificationContent, timestamp: $timestamp, test $sbn")

        // Chuẩn bị dữ liệu cho Worker
        val notificationData = Data.Builder()
            .putString("packageName", packageName)
            .putString("notificationContent", notificationContent)
            .putLong("timestamp", timestamp)
            .build()

        // Tạo yêu cầu công việc với dữ liệu đính kèm
        val workRequest = OneTimeWorkRequest.Builder(NotificationWorker::class.java)
            .setInputData(notificationData)
            .build()

        // Sử dụng WorkManager để lên lịch công việc
        WorkManager.getInstance(this).enqueue(workRequest)
    }
}
