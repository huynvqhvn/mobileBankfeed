package com.example.bank_feed_vs1

import android.content.Context
import android.content.SharedPreferences
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
        val call: Call<List<RuleModel?>?>? = connectApi.getRule()
        call!!.enqueue(object : Callback<List<RuleModel?>?> {
            override fun onResponse(
                call: Call<List<RuleModel?>?>,
                response: Response<List<RuleModel?>?>
            ) {
                if (response.isSuccessful && response.body() != null) {
                    val smsRules: List<RuleModel?>? = response.body()
                    if (smsRules != null) {
                        for (rule in smsRules) {
                            if (rule != null) {
                                Log.d("SmsRule", "Key Search: " + rule.keySearch)
                                if(rule.keySearch == sender){
                                     // Thực hiện công việc (ví dụ gửi dữ liệu này lên server)
                                    sendSmsToServer(sender, message, timestamp);
                                }
                            }
                        }
                    }
                } else {
                    Log.e("Error", "Response is not successful or body is null")
                }
            }

            override fun onFailure(call: Call<List<RuleModel?>?>, t: Throwable) {
                Log.e("Error", t.message!!)
            }
        })
        // Giả sử gửi thành công
        return Result.success()
    }
    fun getDataFromFlutterSharedPreferences(context: Context, key: String): String? {
        val sharedPreferences: SharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        return sharedPreferences.getString("flutter.$key", null) // Tiền tố "flutter." là cần thiết
    }
    private fun sendSmsToServer(sender: String?, message: String?, timestamp: Long){
        // Hàm thực hiện gửi dữ liệu SMS lên server
        Log.d("SmsWorker", "Sending SMS from $sender with message: $message at $timestamp");

        val databaseHelper = DatabaseHelper(applicationContext);
        val  serialNumber =  getDataFromFlutterSharedPreferences(applicationContext,"Service ID");
        Log.d("SmsWorker","databaseHelper ruuning");
        val unsentMessages = databaseHelper.addMessage(sender,message,serialNumber);
        val checkData = databaseHelper.getAllMessages();
        Log.d("SmsWorker", "${checkData.size}");
//        var sms = NotificationModel("processSms running ${sender}", "${message}",timestamp);
//        connectApi.sendNotification(sms).enqueue(object : Callback<Void> {
//            override fun onResponse(call: Call<Void>, response: Response<Void>) {
//                if (response.isSuccessful) {
//                    println("Log sent successfully")
//                } else {
//                    println("Failed to send log: ${response.code()}")
//                }
//            }
//
//            override fun onFailure(call: Call<Void>, t: Throwable) {
//                println("Error sending log: ${t.message}")
//            }
//        })
    }
}