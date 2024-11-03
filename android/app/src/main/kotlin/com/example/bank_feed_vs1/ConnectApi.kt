package com.example.bank_feed_vs1

import android.content.Context
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory


fun setupApiService(context: Context): DataService? {
    return try {
        // Khởi tạo DatabaseHelper với applicationContext
        val databaseHelper = DatabaseHelper(context)

        // Thực hiện truy vấn getWebhooks từ DatabaseHelper
        val webhook = databaseHelper.getWebhooks()

        // Khởi tạo Retrofit với URL ngrok (đảm bảo URL có dấu `/` ở cuối)
//        val retrofit = Retrofit.Builder()
//            .baseUrl("https://c852-14-162-160-194.ngrok-free.app/") // Thay đổi thành URL server của bạn
//            .addConverterFactory(GsonConverterFactory.create()) // Sử dụng Gson cho JSON
//            .build()
//        // Tạo instance của DataService từ Retrofit
//        retrofit.create(DataService::class.java)
        if(webhook.isNotEmpty()){
            val retrofit = Retrofit.Builder()
                .baseUrl("${webhook.get(0).webHookBase}/") // Thay đổi thành URL server của bạn
                .addConverterFactory(GsonConverterFactory.create()) // Sử dụng Gson cho JSON
                .build()

            // Tạo instance của DataService từ Retrofit
            retrofit.create(DataService::class.java)
        }
        else{
            val retrofit = Retrofit.Builder()
                .baseUrl("https://c852-14-162-160-194.ngrok-free.app/") // Thay đổi thành URL server của bạn
                .addConverterFactory(GsonConverterFactory.create()) // Sử dụng Gson cho JSON
                .build()
            // Tạo instance của DataService từ Retrofit
            retrofit.create(DataService::class.java)
        }

    } catch (e: Exception) {
        e.printStackTrace()
        null // Trả về null nếu có lỗi xảy ra
    }
}