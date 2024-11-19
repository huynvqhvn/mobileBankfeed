package com.example.bank_feed_vs1

import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.POST
import retrofit2.http.Url

interface DataService {
    @POST
    fun sendNotification(@Url url: String, @Body notificationModel: NotificationModel): Call<Void>


    @POST("log")
    fun sendLog(@Body NotificationModel: NotificationModel): Call<Void>

    @GET("smsRule")
    fun getRule(): Call<List<RuleModel?>?>?
}
