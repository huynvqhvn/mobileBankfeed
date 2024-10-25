package com.example.bank_feed_vs1

import android.content.Context
import android.util.Log
import androidx.work.Worker
import androidx.work.WorkerParameters
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class SmsWorker(context: Context, params: WorkerParameters) : Worker(context, params) {

    override fun doWork(): Result {
        // Nhận dữ liệu đã truyền từ SmsReceiver
        val sender = inputData.getString("sender")
        val message = inputData.getString("message")
        val timestamp = inputData.getLong("timestamp", 0)

        // Log dữ liệu nhận được
        Log.d("SmsWorker", "Sender: $sender, Message: $message, Timestamp: $timestamp")

        // Thực hiện công việc (ví dụ gửi dữ liệu này lên server)
        sendSmsToServer(sender, message, timestamp)

        // Giả sử gửi thành công
        return Result.success()
    }

    private fun sendSmsToServer(sender: String?, message: String?, timestamp: Long) {
        // Hàm thực hiện gửi dữ liệu SMS lên server
        Log.d("SmsWorker", "Sending SMS from $sender with message: $message at $timestamp")
        var sms = NotificationModel("processSms running ${sender}", "${message}",timestamp);
        connectApi.sendNotification(sms).enqueue(object : Callback<Void> {
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
    }
}