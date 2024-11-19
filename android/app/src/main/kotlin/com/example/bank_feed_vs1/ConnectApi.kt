package com.example.bank_feed_vs1

import android.content.Context
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import android.widget.Toast



fun setupApiService(context: Context): DataService? {
    return try {
        // Khởi tạo DatabaseHelper với applicationContext
        val databaseHelper = DatabaseHelper(context)

        // Thực hiện truy vấn getWebhooks từ DatabaseHelper
        val webhook = databaseHelper.getWebhooks()

        if (webhook.isNotEmpty()) {
            // Khởi tạo Retrofit với URL từ webhook
            val retrofit = Retrofit.Builder()
                .baseUrl("${webhook[0].webHookBase}/") // Đảm bảo URL kết thúc bằng "/"
                .addConverterFactory(GsonConverterFactory.create()) // Sử dụng Gson cho JSON
                .build()
            // Trả về instance của DataService từ Retrofit
            retrofit.create(DataService::class.java)
        } else {
            // Hiển thị thông báo lỗi và trả về null
            Toast.makeText(context, "Bạn cần điền webhook của mình", Toast.LENGTH_SHORT).show()
            null
        }
    } catch (e: Exception) {
        e.printStackTrace()
        null // Trả về null nếu có lỗi xảy ra
    }
}