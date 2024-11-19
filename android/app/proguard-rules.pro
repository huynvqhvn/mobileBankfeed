
# Giữ lại tất cả các lớp và phương thức trong ứng dụng Flutter
-keep class com.example.bank_feed_vs1.** { *; }

# Quy tắc cho Retrofit
-keep class retrofit2.** { *; }
-keepclassmembers,allowobfuscation interface retrofit2.** {
    @retrofit2.http.* <methods>;
}

# Quy tắc cho Gson
-keep class com.google.gson.** { *; }
-keep class com.google.gson.reflect.TypeToken
-keepattributes Signature
-keepattributes *Annotation*

