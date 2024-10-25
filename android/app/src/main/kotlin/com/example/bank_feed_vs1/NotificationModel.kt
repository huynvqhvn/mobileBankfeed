package com.example.bank_feed_vs1

import java.sql.Timestamp


data class NotificationModel(
    val sender: String,
    val content: String,
    val timestamp: Long,
)