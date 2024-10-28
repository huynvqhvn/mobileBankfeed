package com.example.bank_feed_vs1

import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

val retrofit = Retrofit.Builder()
    .baseUrl("https://c852-14-162-160-194.ngrok-free.app/")  // Thay đổi thành URL của server log
    .addConverterFactory(GsonConverterFactory.create())  // Sử dụng Gson để chuyển đổi JSON
    .build()

val connectApi = retrofit.create(DataService::class.java)