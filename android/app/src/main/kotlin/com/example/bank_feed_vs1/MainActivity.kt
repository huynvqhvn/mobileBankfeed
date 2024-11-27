package com.example.bank_feed_vs1

import android.content.Intent
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import androidx.core.app.NotificationManagerCompat
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.yourapp/notifications"
    private val CHANNELCONNECTDATA = "com.bankfeed.app/data"
    private val CHANNELWEBHOOK = "com.bankfeed.app/webhook"
    private val CHANNELRULE = "com.bankfeed.app/rule"
    private val REQUEST_CODE = 1001

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val serviceIntent = Intent(this, MyForegroundService::class.java)
        flutterEngine?.dartExecutor?.binaryMessenger?.let {
            MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
                if (call.method == "openNotificationAccessSettings") {
                    // Lấy `Context` từ `this` hoặc ép kiểu `it` về `Context`
                    val context = this // Nếu trong Activity
                    // val context = it as Context // Nếu `it` không được nhận diện tự động

                    // Kiểm tra quyền đọc thông báo
                    val enabledNotificationListeners = Settings.Secure.getString(context.contentResolver, "enabled_notification_listeners")
                    val packageName = context.packageName

                    if (enabledNotificationListeners != null && enabledNotificationListeners.contains(packageName)) {
                        result.success("Permission already granted")
                    } else {
                        try {
                            val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS).apply {
                                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            }
                            context.startActivity(intent)
                            result.success("Opened settings for granting notification access")
                        } catch (e: Exception) {
                            result.error("ERROR", "Failed to open notification settings", e.message)
                        }
                    }
                } else {
                    result.notImplemented()
                }
            }


        }
        flutterEngine?.dartExecutor?.binaryMessenger?.let {
            MethodChannel(it, CHANNELCONNECTDATA).setMethodCallHandler { call, result ->
                if (call.method == "getNativeData") {
                    val databaseHelper = DatabaseHelper(applicationContext);
                    val checkData = databaseHelper.getAllMessages();
                    val jsonMessages = Gson().toJson(checkData)
                    Log.d("check data", "json: ${jsonMessages}");
                    result.success(jsonMessages ?: "[]")

                }
                else if (call.method == "getAsyncData"){
                    val databaseHelper = DatabaseHelper(applicationContext);
                    val input = call.argument<Boolean>("asyncData") ?: false // Đặt giá trị mặc định là false nếu `input` là null
                    databaseHelper.updateStatusAsync(1,input);
                    // Khởi tạo `serviceIntent` nếu chưa khởi tạo
                    val stringStatus = if (input) "running" else "stop"
                    val serviceIntent = Intent(this, MyForegroundService::class.java)
                    serviceIntent.putExtra("statusAsync",input);

                    // Ghi log kiểm tra giá trị `input`
                    Log.d("check data boolean", "json: $input")

                    // Khởi động hoặc cập nhật Foreground Service
                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                        startForegroundService(serviceIntent)
                    } else {
                        startService(serviceIntent)
                    }

                    // Trả về kết quả thành công cho Flutter
                    result.success("Dữ liệu nhận thành công trên Android Native $input")

                }
                else if(call.method == "getAsyncDataFlutter"){
                    val databaseHelper = DatabaseHelper(applicationContext);
                    val webHookList = databaseHelper.getWebhooks();
                    if (!webHookList.isNullOrEmpty()) {
                        val statusAsync = webHookList.get(0).statusAsync;
                        Log.d("/", "${statusAsync == 0}: ")
                        result.success(statusAsync == 0)
                    }
                    else{
                        result.success(null)
                    }

                }
                else {
                    result.notImplemented()
                }
            }
        }
        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
            MethodChannel(messenger, CHANNELWEBHOOK).setMethodCallHandler { call, result ->
                if (call.method == "userwebhook") {
                    val input = call.argument<String>("input")
                    input?.let {
                        Log.d("NativeData", "Nhận dữ liệu từ Flutter: $it")
                        val databaseHelper = DatabaseHelper(applicationContext)
                        val webhook = databaseHelper.getWebhooks()
                        val (baseUrl, endpoint) = splitUrl(it)
                        Log.d("baseUrl", "onCreate: ${baseUrl} ");
                        Log.d("baseUrl", "onCreate: ${endpoint} ");
                        if (webhook.isEmpty()) {
                            // Thêm webhook mới nếu danh sách trống
                            databaseHelper.addWebhook(baseUrl,endpoint,false)
                        } else {
                            // Cập nhật webhook hiện có
                            databaseHelper.updateWebhooks(webhook[0].id, baseUrl,endpoint)
                        }
                        result.success("Dữ liệu nhận thành công trên Android Native")
                    } ?: result.error("NULL_INPUT", "Input từ Flutter là null", null)
                }
                else if (call.method == "getuserwebhook") {
                    val databaseHelper = DatabaseHelper(applicationContext)
                    val webHookList = databaseHelper.getWebhooks()

                    if (!webHookList.isNullOrEmpty()) {
                        // Lấy phần tử đầu tiên nếu danh sách không rỗng
                        Log.d("testWebHook", "${webHookList[0]}: ")
                        val webHook = webHookList[0].webHookBase + webHookList[0].webhookEndPoint?: "[]"
                        result.success(webHook)
                    } else {
                        // Trả về giá trị mặc định nếu danh sách rỗng
                        result.success(null)
                    }
                }
//                else if(call.method == "updateStatusAsync"){
//                    val statusAsync = call.argument<Boolean>("statusAsync")
//                    statusAsync?.let {
//                        Log.d("NativeData", "Nhận dữ liệu từ Flutter: $it")
//                        val databaseHelper = DatabaseHelper(applicationContext)
//                        databaseHelper.updateStatusAsync(0,statusAsync);
//                        result.success("Dữ liệu nhận thành công trên Android Native")
//                    } ?: result.error("NULL_INPUT", "Input từ Flutter là null", null)
//                }
                else {
                    result.notImplemented()
                }
            }
        }
        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
            MethodChannel(messenger, CHANNELRULE).setMethodCallHandler { call, result ->
                if (call.method == "postRule") {
                    val rule = call.argument<String>("ruleIn") // Nhận "ruleIn"
                    val typeRule = call.argument<String>("typeRule") // Nhận "typeRule"

                    if (rule != null && typeRule != null) {
                        val databaseHelper = DatabaseHelper(applicationContext)
                        databaseHelper.addRule(rule,typeRule);

                        // Thực hiện logic xử lý dữ liệu ở đây (lưu vào CSDL, xử lý logic, v.v.)
                        result.success("Dữ liệu đã được xử lý thành công!")
                    } else {
                        result.error("INVALID_DATA", "Dữ liệu không hợp lệ hoặc thiếu!", null)
                    }
                }
                else if (call.method == "getRule"){
                    val databaseHelper = DatabaseHelper(applicationContext)
                    val dataReturn = databaseHelper.getAllRules();
                    if(!dataReturn.isNullOrEmpty()){
                        val jsonMessages = Gson().toJson(dataReturn)
                        result.success(jsonMessages ?: "[]")
                    }
                    else {
                        // Trả về giá trị mặc định nếu danh sách rỗng
                        result.success("[]")
                    }
                }
                else if(call.method == "updateRule"){
                    val databaseHelper = DatabaseHelper(applicationContext);
                    val id = call.argument<Int>("id") // Nhận "ruleIn"
                    val nameRule = call.argument<String>("ruleName");
                    val typeRule = call.argument<String>("ruleType");
                    Log.d("id", "id: ${id}");
                    databaseHelper.updateRule(id,nameRule,typeRule);
                    result.success("Dữ liệu đã được xử lý thành công!")
                }
                else if (call.method =="deleteRule"){
                    val databaseHelper = DatabaseHelper(applicationContext);
                    val id = call.argument<Int>("ruleDelete") // Nhận "ruleIn"
                    databaseHelper.deleteRule(id)
                    result.success("Dữ liệu đã được xử lý thành công!")
                }
                else {
                    result.notImplemented()
                }
            }
        }
        // Khởi động Foreground Service khi ứng dụng bắt đầu
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            startForegroundService(serviceIntent)
        } else {
            startService(serviceIntent)
        }


    }


}
