package com.example.bank_feed_vs1

import android.content.Context
import android.util.Log
import androidx.work.Worker
import androidx.work.WorkerParameters
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import android.os.Build
import androidx.annotation.RequiresApi
import android.content.SharedPreferences
class NotificationWorker(context: Context, params: WorkerParameters) : Worker(context, params) {

    @RequiresApi(Build.VERSION_CODES.O)
    override fun doWork(): Result {
        // Nhận dữ liệu từ inputData
        val packageName = inputData.getString("packageName")
        val notificationContent = inputData.getString("notificationContent")
        val timestamp = getCurrentDateTime();

        // Log dữ liệu nhận được
        Log.d("NotificationWorker", "Package: $packageName, Content: $notificationContent, Timestamp: $timestamp")
//        if(packageName == "com.google.android.apps.messaging"){
        // Gửi dữ liệu lên server hoặc thực hiện tác vụ khác
        sendNotificationToServer(packageName, notificationContent, timestamp)
//        }

        // Giả sử bạn gửi thành công
        return Result.success()
    }
    fun getDataFromFlutterSharedPreferences(context: Context, key: String): String? {
        val sharedPreferences: SharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        return sharedPreferences.getString("flutter.$key", null) // Tiền tố "flutter." là cần thiết
    }
    private fun sendNotificationToServer(packageName: String?, content: String?, timestamp: String) {
        // Thực hiện gửi dữ liệu thông báo lên server
        Log.d("NotificationWorker", "Sending notification from $packageName with content: $content at $timestamp")
        val databaseHelper = DatabaseHelper(applicationContext);
        val  serialNumber =  getDataFromFlutterSharedPreferences(applicationContext,"Service ID");
        val connectApi = setupApiService(applicationContext)
        val webhook = databaseHelper.getWebhooks()
        val getRules = databaseHelper.getAllRulesSelected();
        for (Rule in getRules ){
            if(Rule.typesName.equals("app") && packageName!= null && content !=null && webhook.isNotEmpty()){
                if(packageName.equals(Rule.typesContent)){
                    if (isNetworkAvailable(applicationContext)) {
                        Log.d("AppWorker","passpass wifi");
                        var notification = NotificationModel("${Rule.rule}", "${content}",timestamp,serialNumber,"app");
                        Log.d("AppWorker", "${notification}");
                        connectApi?.sendNotification(webhook.get(0).webhookEndPoint ,notification)!!.enqueue(object : Callback<Void> {
                            override fun onResponse(call: Call<Void>, response: Response<Void>) {
                                if (response.isSuccessful) {
                                    println("Log sent successfully")
                                    databaseHelper.addMessage(Rule.rule, content, serialNumber,true,timestamp,"app");
                                } else {
                                    println("Failed to send log: ${response.code()}")
                                    databaseHelper.addMessage(Rule.rule, content, serialNumber,false,timestamp,"app");
                                }
                            }
                            override fun onFailure(call: Call<Void>, t: Throwable) {
                                println("Error sending log: ${t.message}")
                                databaseHelper.addMessage(Rule.rule, content, serialNumber,false,timestamp,"app");
                            }
                        })
                    }
                    else {
                        Log.d("AppWorker","not pass wifi");
                        databaseHelper.addMessage(Rule.rule , content, serialNumber,false,timestamp,"app");
                    }
                }
            }
        }
        // Implement logic gửi dữ liệu lên server ở đây
    }
}

