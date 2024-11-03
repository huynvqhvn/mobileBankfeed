package com.example.bank_feed_vs1

import java.net.URI

fun splitUrl(fullUrl: String): Pair<String, String> {
    val uri = URI(fullUrl)
    // Lấy phần baseUrl: scheme + host + "/"
    val baseUrl = "${uri.scheme}://${uri.host}/"
    // Lấy phần endpoint: path + query
    val endpoint = uri.path + (uri.query?.let { "?$it" } ?: "")

    return Pair(baseUrl, endpoint)
}