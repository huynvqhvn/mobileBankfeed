package com.example.bank_feed_vs1


import android.content.ContentValues
import android.content.Context
import android.content.SharedPreferences
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.util.Log
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

// Định nghĩa thông tin của database
private const val DATABASE_NAME = "MessagesDB"
private const val DATABASE_VERSION = 1

// Định nghĩa bảng và các cột
private const val TABLE_MESSAGES = "messages"
private const val COLUMN_ID = "id"
private const val COLUMN_AUTHOR = "author"
private const val COLUMN_MESSAGES = "body"
private const val COLUMN_TIMESTAMP = "timestamp"
private const val COLUMN_SERIAL_NUMBER = "serialnumber"
private const val COLUMN_CHECKSEND = "checksend"
private const val COLUMN_TYPE = "type"

// Định nghĩa bảng mới và các cột
private const val TABLE_RULES = "rules"
private const val COLUMN_RULES_ID = "rulesID"
private const val COLUMN_RULES_NAME = "rulesName"
private const val COLUMN_RULES_TYPE = "ruleType"

//
private const val TABLE_WEBHOOKS = "webhooks"
private const val COLUMN_WEBHOOKS_ID = "webhooksID"
private const val COLUMN_WEBHOOKS_BASE = "webhookBase"
private const val COLUMN_WEBHOOKS_ENDPOINT = "webhookEndPoint"
private const val COLUMN_STATUS_ASYNC = "statusAsync"
class DatabaseHelper(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    // Tạo bảng messages
    override fun onCreate(db: SQLiteDatabase) {
        val createTableMessages = ("CREATE TABLE " + TABLE_MESSAGES + "("
                + COLUMN_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                + COLUMN_AUTHOR + " TEXT, "
                + COLUMN_MESSAGES + " TEXT, "
                + COLUMN_TIMESTAMP + "  TEXT,"
                + COLUMN_SERIAL_NUMBER + " TEXT, "
                + COLUMN_CHECKSEND + " INTEGER, "
                + COLUMN_TYPE + " TEXT "
                + ")")

        val createTableRules = ("CREATE TABLE " + TABLE_RULES + "("
                + COLUMN_RULES_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                + COLUMN_RULES_NAME + " TEXT,"
                + COLUMN_RULES_TYPE + " TEXT"
                + ")")

        val createTableWebHooks = ("CREATE TABLE " + TABLE_WEBHOOKS + "("
                + COLUMN_WEBHOOKS_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                + COLUMN_WEBHOOKS_BASE + " TEXT, "
                + COLUMN_WEBHOOKS_ENDPOINT + " TEXT, "
                + COLUMN_STATUS_ASYNC + " INTEGER"
                + ")")

        db.execSQL(createTableMessages)
        db.execSQL(createTableRules)
        db.execSQL(createTableWebHooks)
    }


    // Cập nhật database nếu phiên bản thay đổi
    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS $TABLE_MESSAGES")
        onCreate(db)
    }

    // Phương thức để thêm một thông báo (message)
    fun addMessage(sender: String?, body: String?,serialnumber:String? ,checksend: Boolean,timestamp:String?,type:String): Long {
        Log.d("check add", "$sender")
        val db = this.writableDatabase
        val contentValues = ContentValues().apply {
            put(COLUMN_AUTHOR, sender)
            put(COLUMN_MESSAGES, body)
            put(COLUMN_CHECKSEND, if (checksend) 1 else 0)
            put(COLUMN_SERIAL_NUMBER,serialnumber)
            put(COLUMN_TIMESTAMP, timestamp)
            put(COLUMN_TYPE, type)
        }

        return try {
            val result = db.insert(TABLE_MESSAGES, null, contentValues)
            return result // Trả về kết quả chèn
        } catch (e: Exception) {
            Log.e("DatabaseError", "Lỗi khi chèn dữ liệu: ${e.message}")
            return -1 // Trả về -1 để báo lỗi khi chèn thất bại
        } finally {
            db.close() // Đảm bảo đóng db dù có lỗi hay không
        }
    }

    fun addWebhook(webHookBase:String?,webHookEndPoint:String?,statusAsync: Boolean,): Long {
        Log.d("check add", "$webHookBase")

        val db = this.writableDatabase
        val contentValues = ContentValues().apply {
            put(COLUMN_WEBHOOKS_BASE, webHookBase);
            put(COLUMN_WEBHOOKS_ENDPOINT, webHookEndPoint);
            put(COLUMN_STATUS_ASYNC, if (statusAsync == true) 0 else 1);
        }
        return try {
            val result = db.insert(TABLE_WEBHOOKS, null, contentValues)
            return result // Trả về kết quả chèn
        } catch (e: Exception) {
            Log.e("DatabaseError", "Lỗi khi chèn dữ liệu: ${e.message}")
            return -1 // Trả về -1 để báo lỗi khi chèn thất bại
        } finally {
            db.close() // Đảm bảo đóng db dù có lỗi hay không
        }
    }
    fun getWebhooks(): List<WebHook> {
        Log.d("check get","getall here");
        val wepHookList = mutableListOf<WebHook>();
        val selectQuery = "SELECT * FROM $TABLE_WEBHOOKS"
        val db = this.readableDatabase
        val cursor = db.rawQuery(selectQuery, null)

        if (cursor.moveToFirst()) {
            do {
                val id = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_WEBHOOKS_ID))
                val webHookBase = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_WEBHOOKS_BASE))
                val webhookEndPoint = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_WEBHOOKS_ENDPOINT))
                val statusAsync = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_STATUS_ASYNC))

                // Tạo đối tượng Message với timestamp là chuỗi
                val WebHook = WebHook(
                    id = id,
                    webHookBase = webHookBase,
                    webhookEndPoint= webhookEndPoint,
                    statusAsync = statusAsync
                )

                wepHookList.add(WebHook)
            } while (cursor.moveToNext())
        }

        cursor.close()
        db.close()
        return wepHookList
    }

    fun updateWebhooks(id: Int, webHookBase:String?,webHookEndPoint:String?) {
        Log.d("statusAsyncUpdate", "Boolean: ${webHookEndPoint} ")
        val db = this.writableDatabase
        val contentValues = ContentValues().apply {
            put(COLUMN_WEBHOOKS_BASE, webHookBase);
            put(COLUMN_WEBHOOKS_ENDPOINT, webHookEndPoint);
        }
        db.update(TABLE_WEBHOOKS, contentValues, "$COLUMN_WEBHOOKS_ID = ?", arrayOf(id.toString()))
        db.close()
    }
    fun updateStatusAsync(id: Int,statusAsync: Boolean){
        val db = this.writableDatabase
        Log.d("statusAsyncUpdate", "Boolean: ${statusAsync} ")
        val contentValues = ContentValues().apply {
            put(COLUMN_STATUS_ASYNC, if (statusAsync) 0 else 1) // Sử dụng if-else đúng cách
        }
        db.update(TABLE_WEBHOOKS, contentValues, "$COLUMN_WEBHOOKS_ID = ?", arrayOf(id.toString()))
        db.close()
    }
    // Lấy tất cả các thông báo (message)
    fun getAllMessages(): List<Message> {
        Log.d("check get","getall here");
        val messageList = mutableListOf<Message>()
        val selectQuery = "SELECT * FROM $TABLE_MESSAGES ORDER BY $COLUMN_ID DESC"
        val db = this.readableDatabase
        val cursor = db.rawQuery(selectQuery, null)

        if (cursor.moveToFirst()) {
            do {
                val id = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_ID))
                val author = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_AUTHOR))
                val messages = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_MESSAGES))
                val timestamp = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_TIMESTAMP))
                val serialnumber = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_SERIAL_NUMBER))
                val type = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_TYPE))
                val isSendMessage = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_CHECKSEND))


                // Tạo đối tượng Message với timestamp là chuỗi
                val message = Message(
                    id = id,
                    author = author,
                    message = messages,
                    timestamp = timestamp,
                    serialnumber= serialnumber,// Sử dụng chuỗi timestamp
                    isSendMessage = isSendMessage == 1,
                    type = type
                )

                messageList.add(message)
            } while (cursor.moveToNext())
        }

        cursor.close()
        db.close()
        return messageList
    }
    fun getAllMessagesNotSend(): List<Message> {
        val messageList = mutableListOf<Message>()
        val selectQuery = "SELECT * FROM $TABLE_MESSAGES WHERE $COLUMN_CHECKSEND = 0 ORDER BY $COLUMN_ID DESC"
        val db = this.readableDatabase
        val cursor = db.rawQuery(selectQuery, null)

        if (cursor.moveToFirst()) {
            do {
                val id = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_ID))
                val author = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_AUTHOR))
                val messages = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_MESSAGES))
                val timestamp = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_TIMESTAMP))
                val serialnumber = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_SERIAL_NUMBER))
                val type = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_TYPE))
                val isSendMessage = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_CHECKSEND))


                // Tạo đối tượng Message với timestamp là chuỗi
                val message = Message(
                    id = id,
                    author = author,
                    message = messages,
                    timestamp = timestamp,
                    serialnumber= serialnumber,// Sử dụng chuỗi timestamp
                    isSendMessage = isSendMessage == 1,
                    type = type
                )

                messageList.add(message)
            } while (cursor.moveToNext())
        }

        cursor.close()
        db.close()
        return messageList
    }

    // Cập nhật trạng thái checksend của thông báo
    fun updateMessageStatus(id: Int, checksend: Boolean) {
        val db = this.writableDatabase
        val contentValues = ContentValues().apply {
            put(COLUMN_CHECKSEND, if (checksend) 0 else 1)
        }
        db.update(TABLE_MESSAGES, contentValues, "$COLUMN_ID = ?", arrayOf(id.toString()))
        db.close()
    }

    // Xóa tất cả các thông báo
    fun deleteAllMessages() {
        val db = this.writableDatabase
        db.execSQL("DELETE FROM $TABLE_MESSAGES")
        db.close()
    }

     fun deleteMessage(id: Int) {
        val db = this.writableDatabase
        db.execSQL("DELETE FROM $TABLE_MESSAGES WHERE $COLUMN_ID = ?", arrayOf(id))
        db.close()
    }

    fun addRule(ruleName:String?,ruleType: String? ):Long{
        val db = this.writableDatabase
        val contentValues = ContentValues().apply {
            put(COLUMN_RULES_NAME, ruleName)
            put(COLUMN_RULES_TYPE, ruleType)
        }

        return try {
            val result = db.insert(TABLE_RULES, null, contentValues)
            return result // Trả về kết quả chèn
        } catch (e: Exception) {
            Log.e("DatabaseError", "Lỗi khi chèn dữ liệu: ${e.message}")
            return -1 // Trả về -1 để báo lỗi khi chèn thất bại
        } finally {
            db.close() // Đảm bảo đóng db dù có lỗi hay không
        }
    }

    fun getAllRules(): List<Rule> {
        val messageList = mutableListOf<Rule>()
        val selectQuery = "SELECT * FROM $TABLE_RULES ORDER BY $COLUMN_RULES_ID DESC"
        val db = this.readableDatabase
        val cursor = db.rawQuery(selectQuery, null)

        if (cursor.moveToFirst()) {
            do {
                val Rule = Rule(
                    id = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_RULES_ID
                    )),
                    rule = cursor.getString(cursor.getColumnIndexOrThrow( COLUMN_RULES_NAME )),
                    typeRule= cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_RULES_TYPE))
                )
                messageList.add(Rule)
            } while (cursor.moveToNext())
        }

        cursor.close()
        db.close()
        return messageList
    }

    fun deleteRule(id: Int) {
        val db = this.writableDatabase
        db.execSQL("DELETE FROM $TABLE_RULES WHERE $COLUMN_RULES_ID = ?", arrayOf(id.toString()))
        db.close()
    }

    fun updateRule(id: Int, ruleName: String,ruleType: String) {
        val db = this.writableDatabase
        val contentValues = ContentValues().apply {
            put(COLUMN_RULES_NAME, ruleName)
            put(COLUMN_RULES_TYPE, ruleType)
        }
        db.update(TABLE_RULES, contentValues, "$COLUMN_RULES_ID = ?", arrayOf(id.toString()))
        db.close()
    }
}

// Định nghĩa dữ liệu của thông báo (Message data class)
data class Message(
    val id: Int,
    val author: String,
    val message: String,
    val timestamp: String,
    val serialnumber: String,
    val isSendMessage: Boolean,
    val type: String,
)

data class Rule(
    val id: Int,
    val rule: String,
    val typeRule: String
)

data class WebHook(
    val id: Int,
    val webHookBase: String,
    val webhookEndPoint: String,
    val statusAsync: Int,
)