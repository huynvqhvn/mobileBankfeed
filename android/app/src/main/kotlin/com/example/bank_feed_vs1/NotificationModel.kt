package com.example.bank_feed_vs1


data class NotificationModel(
    val sender: String,
    val content: String,
    val timestamp: String,
    val serial_number: String?,
    val type: String
)