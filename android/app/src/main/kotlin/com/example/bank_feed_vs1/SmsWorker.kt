package com.example.bank_feed_vs1

import android.content.Context
import android.content.SharedPreferences
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.work.Worker
import androidx.work.WorkerParameters
import com.google.gson.Gson
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import kotlin.math.log

class SmsWorker(context: Context, params: WorkerParameters) : Worker(context, params) {

    // Thực hiện công việc tách dữ liệu và gửi tin nhắn cho server
    @RequiresApi(Build.VERSION_CODES.O)
    override fun doWork(): Result {
        // Nhận dữ liệu đã truyền từ SmsReceiver
        val sender = inputData.getString("sender")
        val message = inputData.getString("message")
        val timestamp = getCurrentDateTime();
        Log.d("timestamp12345", "${timestamp}")
        sendSmsToServer(sender, message, timestamp);
        // Gửi thành công
        return Result.success()
    }
    fun getDataFromFlutterSharedPreferences(context: Context, key: String): String? {
        val sharedPreferences: SharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        return sharedPreferences.getString("flutter.$key", null) // Tiền tố "flutter." là cần thiết
    }
    // Gửi tin tin nhắn cho server
    private fun sendSmsToServer(sender: String?, message: String?, timestamp: String){
        // Hàm thực hiện gửi dữ liệu SMS lên server
        Log.d("SmsWorker", "Sending SMS from $sender with message: $message at $timestamp");

        val databaseHelper = DatabaseHelper(applicationContext);
        val serialNumber =  getDataFromFlutterSharedPreferences(applicationContext,"Service ID");
        val connectApi = setupApiService(applicationContext)
        val webhook = databaseHelper.getWebhooks()
        val getRules = databaseHelper.getAllRulesSelected();
        for (Rule in getRules ){
            if(Rule.typesName.equals("sms") && sender != null && message !=null && webhook.isNotEmpty()){
                Log.d("SmsWorker","passpass");
                    if(Rule.typesContent.toLowerCase().equals(sender.toLowerCase())){
                        if (isNetworkAvailable(applicationContext)) {
                            Log.d("SmsWorker","passpass wifi");
                            var sms = NotificationModel("${Rule.rule}", "${message}",timestamp,serialNumber,"sms");
                            Log.d("timestamp12345", "${sms}")
                            connectApi?.sendNotification(webhook.get(0).webhookEndPoint, sms)!!.enqueue(object : Callback<Void> {
                                override fun onResponse(call: Call<Void>, response: Response<Void>) {
                                    if (response.isSuccessful) {
                                        println("Log sent sms successfully")
                                        databaseHelper.addMessage(Rule.rule, message, serialNumber,true,timestamp,"sms");
                                    } else {
                                        println("Failed to send log: ${response.code()}")
                                        databaseHelper.addMessage(Rule.rule, message, serialNumber,false,timestamp,"sms");
                                    }
                                }

                                override fun onFailure(call: Call<Void>, t: Throwable) {
                                    println("Error sending log: ${t.message}")
                                    databaseHelper.addMessage(Rule.rule, message, serialNumber,false,timestamp,"sms");
                                }
                            })
                        }
                        else {
                            Log.d("SmsWorker","not pass wifi");
                            databaseHelper.addMessage(Rule.rule, message, serialNumber,false,timestamp,"sms");
                        }

                    }
            }
        }
    }
}