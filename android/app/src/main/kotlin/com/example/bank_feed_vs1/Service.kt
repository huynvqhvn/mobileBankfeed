package com.example.bank_feed_vs1

import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.POST
interface LogService {
    @POST("dataTransition")
    fun sendNotification(@Body NotificationModel: NotificationModel): Call<Void>

    @POST("log")
    fun sendLog(@Body NotificationModel: NotificationModel): Call<Void>
}
