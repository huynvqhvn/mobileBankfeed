package com.example.bank_feed_vs1

import android.os.Build
import androidx.annotation.RequiresApi
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

@RequiresApi(Build.VERSION_CODES.O)
fun getCurrentDateTime(): String {
    val current = LocalDateTime.now() // Lấy thời gian hiện tại
    val formatter = DateTimeFormatter.ofPattern("MM-dd-yyyy HH:mm:ss") // Định dạng thời gian
    return current.format(formatter) // Trả về chuỗi thời gian
}
