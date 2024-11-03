package com.example.bank_feed_vs1

import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.POST

interface DataService {

    @POST("/index.php?m=bankfeeds&id=134c0278-30bd-4ddb-b441-6ab1340386f1&action=receive-sms")
    fun sendNotification(@Body NotificationModel: NotificationModel): Call<Void>

    @POST("log")
    fun sendLog(@Body NotificationModel: NotificationModel): Call<Void>

    @GET("smsRule")
    fun getRule(): Call<List<RuleModel?>?>?
}
