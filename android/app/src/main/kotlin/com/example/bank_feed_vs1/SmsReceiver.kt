package com.example.bank_feed_vs1

import androidx.work.Data
import androidx.work.OneTimeWorkRequest
import androidx.work.WorkManager
import android.telephony.SmsMessage
import android.util.Log
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class SmsReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val bundle = intent.extras
        var smsBody = ""
        var sender = ""
        var timestamp: Long = 0

        if (bundle != null) {
            val pdus = bundle["pdus"] as Array<*>
            val messages = arrayOfNulls<SmsMessage>(pdus.size)
            for (i in pdus.indices) {
                messages[i] = SmsMessage.createFromPdu(pdus[i] as ByteArray)
                sender = messages[i]?.originatingAddress.toString()
                smsBody += messages[i]?.messageBody.toString()
                    .replace("\n", " ")  // Thay thế xuống dòng Unix/Linux
                    .replace("\r", " ")  // Thay thế xuống dòng Windows
                    .replace("\r\n", " ") // Thay thế xuống dòng Windows đầy đủ
                timestamp = messages[i]?.timestampMillis ?: 0
            }

            // Log thông tin SMS nhận được
            Log.d("SmsReceiver", "SMS from: $sender, body: $smsBody, timestamp: $timestamp")

            // Chuẩn bị dữ liệu cho Worker
            val smsData = Data.Builder()
                .putString("sender", sender)
                .putString("message", smsBody)
                .putLong("timestamp", timestamp)
                .build()

            // Tạo yêu cầu công việc với dữ liệu đính kèm
            val workRequest = OneTimeWorkRequest.Builder(SmsWorker::class.java)
                .setInputData(smsData)
                .build()

            // Sử dụng WorkManager để xếp hàng công việc
            WorkManager.getInstance(context).enqueue(workRequest)
        }
    }
}

