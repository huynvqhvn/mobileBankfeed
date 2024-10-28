package com.example.bank_feed_vs1


import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.util.Log
// Định nghĩa thông tin của database
private const val DATABASE_NAME = "MessagesDB"
private const val DATABASE_VERSION = 1

// Định nghĩa bảng và các cột
private const val TABLE_MESSAGES = "messages"
private const val COLUMN_ID = "id"
private const val COLUMN_AUTHOR = "author"
private const val COLUMN_MESSAGES = "body"
private const val COLUMN_TIMESTAMP = "timestamp"
private const val COLUMN_CHECKSEND = "checksend"

class DatabaseHelper(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    // Tạo bảng messages
    override fun onCreate(db: SQLiteDatabase) {
        val createTable = ("CREATE TABLE " + TABLE_MESSAGES + "("
                + COLUMN_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                + COLUMN_AUTHOR + " TEXT, "
                + COLUMN_MESSAGES + " TEXT, "
                + COLUMN_TIMESTAMP + " DATETIME DEFAULT CURRENT_TIMESTAMP, "
                + COLUMN_CHECKSEND + " INTEGER"
                + ")")

        db.execSQL(createTable)
    }


    // Cập nhật database nếu phiên bản thay đổi
    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        db.execSQL("DROP TABLE IF EXISTS $TABLE_MESSAGES")
        onCreate(db)
    }

    // Phương thức để thêm một thông báo (message)
    fun addMessage(sender: String?, body: String?, checksend: Boolean = false): Long {
        Log.d("check add", "$sender")

        val db = this.writableDatabase
        val contentValues = ContentValues().apply {
            put(COLUMN_AUTHOR, sender)
            put(COLUMN_MESSAGES, body)
            put(COLUMN_CHECKSEND, if (checksend) 1 else 0)
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



    // Lấy tất cả các thông báo (message)
    fun getAllMessages(): List<Message> {
        Log.d("check get","getall here");
        val messageList = mutableListOf<Message>()
        val selectQuery = "SELECT * FROM $TABLE_MESSAGES ORDER BY $COLUMN_TIMESTAMP DESC"
        val db = this.readableDatabase
        val cursor = db.rawQuery(selectQuery, null)

        if (cursor.moveToFirst()) {
            do {
                val message = Message(
                    id = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_ID)),
                    author = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_AUTHOR)),
                    messages = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_MESSAGES)),
                    timestamp = cursor.getLong(cursor.getColumnIndexOrThrow(COLUMN_TIMESTAMP)),
                    checksend = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_CHECKSEND))
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
        val selectQuery = "SELECT * FROM $TABLE_MESSAGES WHERE $COLUMN_CHECKSEND = 0 ORDER BY $COLUMN_TIMESTAMP DESC"
        val db = this.readableDatabase
        val cursor = db.rawQuery(selectQuery, null)

        if (cursor.moveToFirst()) {
            do {
                val message = Message(
                    id = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_ID)),
                    author = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_AUTHOR)),
                    messages = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_MESSAGES)),
                    timestamp = cursor.getLong(cursor.getColumnIndexOrThrow(COLUMN_TIMESTAMP)),
                    checksend = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_CHECKSEND)) // Chuyển đổi Int sang Boolean
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
            put(COLUMN_CHECKSEND, if (checksend) 1 else 0)
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
}

// Định nghĩa dữ liệu của thông báo (Message data class)
data class Message(
    val id: Int,
    val author: String,
    val messages: String,
    val timestamp: Long,
    val checksend: Int
)
