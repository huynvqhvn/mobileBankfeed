package com.example.bank_feed_vs1

import android.content.Context
import android.util.Log
import androidx.work.Worker
import androidx.work.WorkerParameters
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class NotificationWorker(context: Context, params: WorkerParameters) : Worker(context, params) {

    override fun doWork(): Result {
        // Nhận dữ liệu từ inputData
        val packageName = inputData.getString("packageName")
        val notificationContent = inputData.getString("notificationContent")
        val timestamp = inputData.getLong("timestamp", 0)

        // Log dữ liệu nhận được
        Log.d("NotificationWorker", "Package: $packageName, Content: $notificationContent, Timestamp: $timestamp")
        if(packageName == "com.google.android.apps.messaging"){
        // Gửi dữ liệu lên server hoặc thực hiện tác vụ khác
        sendNotificationToServer(packageName, notificationContent, timestamp)
        }

        // Giả sử bạn gửi thành công
        return Result.success()
    }

    private fun sendNotificationToServer(packageName: String?, content: String?, timestamp: Long) {
        // Thực hiện gửi dữ liệu thông báo lên server
        Log.d("NotificationWorker", "Sending notification from $packageName with content: $content at $timestamp")
        var notificationModel = NotificationModel("processNotification running ${packageName}", "${content}",timestamp);
        connectApi.sendNotification(notificationModel).enqueue(object : Callback<Void> {
            override fun onResponse(call: Call<Void>, response: Response<Void>) {
                if (response.isSuccessful) {
                    println("Log sent successfully")
                } else {
                    println("Failed to send log: ${response.code()}")
                }
            }

            override fun onFailure(call: Call<Void>, t: Throwable) {
                println("Error sending log: ${t.message}")
            }
        })
        // Implement logic gửi dữ liệu lên server ở đây
    }
}

