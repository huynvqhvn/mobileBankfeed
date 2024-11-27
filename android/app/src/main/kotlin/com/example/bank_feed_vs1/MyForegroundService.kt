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
import android.os.Handler
import android.os.Looper
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class MyForegroundService : Service() {

    private lateinit var smsReceiver: SmsReceiver
    private val handler = Handler(Looper.getMainLooper())
    private val runnable = object : Runnable {
        override fun run() {
            // Thực hiện công việc của bạn ở đây
            println("Thực hiện công việc lặp lại mỗi 10 giây")
            val databaseHelper = DatabaseHelper(applicationContext);
            val connectApi = setupApiService(applicationContext)
            val checkData = databaseHelper.getAllMessagesNotSend();
            Log.d("checkData", "${checkData}")
            val webhook = databaseHelper.getWebhooks()
            if(checkData.isNotEmpty()){
                for (x in checkData) {
                    var sms = NotificationModel("${x.author}", "${x.message}","${x.timestamp}","${x.serialnumber}","sms");
                    connectApi?.sendNotification(webhook.get(0).webhookEndPoint, sms)!!.enqueue(object :
                        Callback<Void> {
                        override fun onResponse(call: Call<Void>, response: Response<Void>) {
                            if (response.isSuccessful) {
                                println("Log sent sms successfully ${response}")
                                databaseHelper.updateMessageStatus(x.id,true);
                            } else {
                                println("Failed to send log: ${response.code()}");
                            }
                        }

                        override fun onFailure(call: Call<Void>, t: Throwable) {
                            println("Error sending log: ${t.message}")
                        }
                    })
                }
            }
            Log.d("checkDataNotSend", "${checkData}");
            // Lặp lại sau 10 giây
            handler.postDelayed(this, 10000)
        }
    }
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

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // Lấy dữ liệu từ Intent nếu có
        var data: Boolean? = null;
        val databaseHelper = DatabaseHelper(applicationContext);
        val checkStatusAsync = databaseHelper.getWebhooks();
        if(checkStatusAsync.isNotEmpty()){
            data = checkStatusAsync[0].statusAsync == 0
        }else{
            data = intent?.getBooleanExtra("statusAsync",false)
            Log.d("MyService", "Received data: $data")
        }
// Tạo Runnable cho tác vụ lặp lại
        if(data == true){
            // Bắt đầu tác vụ lặp lại
            handler.post(runnable)
        }
        else{
            handler.removeCallbacks(runnable)
        }

        // Trả về START_STICKY để hệ thống khởi động lại Service nếu bị kill
        return START_STICKY
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
