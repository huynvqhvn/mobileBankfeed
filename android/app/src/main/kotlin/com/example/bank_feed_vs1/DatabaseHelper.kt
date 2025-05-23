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
// Định nghĩa bảng các từ không được dùng
private const val TABLE_WORDS_FILTER = "words"
private const val COLUMN_WORDS_ID = "wordsID"
private const val COLUMN_WORDS_NAME = "wordsName"
private const val COLUMN_RULESS_ID = "rulesID"
// Định nghĩa bảng mới và các type
private const val TABLE_TYPES = "types"
private const val COLUMN_TYPES_ID = "typesID"
private const val COLUMN_TYPES_NAME = "typesName"
private const val COLUMN_TYPES_CONTENT = "typesContent"
private const val COLUMN_RULE_ID = "ruleID"
private const val COLUMN_RULE_TYPE_IS_SELECTED = "ruleTypeSelected"
//
private const val TABLE_WEBHOOKS = "webhooks"
private const val COLUMN_WEBHOOKS_ID = "webhooksID"
private const val COLUMN_WEBHOOKS_BASE = "webhookBase"
private const val COLUMN_WEBHOOKS_ENDPOINT = "webhookEndPoint"
private const val COLUMN_STATUS_ASYNC = "statusAsync"
// data base version manager
private const val TABLE_VERSION_APP = "versionapp"
private const val COLUMN_VERSION_APP_ID = "versionId"
private const val COLUMN_VERSION_APP = "version"
private const val COLUMN_VERSION_NOTE = "releaseNotes"
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
                + COLUMN_RULES_NAME + " TEXT "
                + ")")
        val createTableTypes = ("CREATE TABLE " + TABLE_TYPES + "("
                + COLUMN_TYPES_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                + COLUMN_TYPES_NAME + " TEXT, "
                + COLUMN_TYPES_CONTENT + " TEXT, "
                + COLUMN_RULE_ID + " INTEGER, "
                + COLUMN_RULE_TYPE_IS_SELECTED + " INTEGER DEFAULT 0, " // Đảm bảo có dấu phẩy ở đây
                + "FOREIGN KEY(" + COLUMN_RULE_ID + ") REFERENCES " + TABLE_RULES + "(id) ON DELETE CASCADE"
                + ")")
       val creataTableWordsFilter = ("CREATE TABLE " + TABLE_WORDS_FILTER + " ("
        + COLUMN_WORDS_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
        + COLUMN_WORDS_NAME + " TEXT, "
        + COLUMN_RULESS_ID + " INTEGER, "
        + "FOREIGN KEY(" + COLUMN_RULESS_ID + ") REFERENCES " + TABLE_RULES + "(" + COLUMN_RULES_ID + ") ON DELETE CASCADE"
        + ")")
        val createTableWebHooks = ("CREATE TABLE " + TABLE_WEBHOOKS + "("
                + COLUMN_WEBHOOKS_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                + COLUMN_WEBHOOKS_BASE + " TEXT, "
                + COLUMN_WEBHOOKS_ENDPOINT + " TEXT, "
                + COLUMN_STATUS_ASYNC + " INTEGER"
                + ")")
        val createTableVersionApp = ("CREATE TABLE " + TABLE_VERSION_APP + "("
                + COLUMN_VERSION_APP_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                + COLUMN_VERSION_APP + " TEXT, "
                + COLUMN_VERSION_NOTE + " TEXT "
                + ")")
        db.execSQL(createTableMessages)
        db.execSQL(createTableRules)
        db.execSQL(createTableTypes)
        db.execSQL(createTableWebHooks)
        db.execSQL(createTableVersionApp)
        db.execSQL(creataTableWordsFilter)
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
            put(COLUMN_CHECKSEND, if (checksend) 0 else 1)
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
    fun  checkMessagesExit(sender: String?,message: String?,timestamp: String): Boolean {
        Log.d("${sender}", "checkMessagesExit: ")
        val messageList = mutableListOf<Message>()
        val selectQuery = "SELECT * FROM $TABLE_MESSAGES WHERE $COLUMN_AUTHOR = ? AND $COLUMN_MESSAGES = ? AND $COLUMN_TIMESTAMP = ? ORDER BY $COLUMN_ID DESC"
        val db = this.readableDatabase
        val cursor = db.rawQuery(selectQuery,arrayOf(sender, message,timestamp))

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
                    isSendMessage = isSendMessage == 0,
                    type = type
                )

                messageList.add(message)
            } while (cursor.moveToNext())
        }

        cursor.close()
        db.close()
        Log.d("checkMessagesExit", "checkMessagesExit: ${messageList}")
        return messageList.isEmpty();
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
                    isSendMessage = isSendMessage == 0,
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
        val selectQuery = "SELECT * FROM $TABLE_MESSAGES WHERE $COLUMN_CHECKSEND = 1 ORDER BY $COLUMN_ID DESC"
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
                    isSendMessage = isSendMessage == 0,
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
        println("${id}, ${checksend}")
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
    /* Thêm rule vào database
    * ruleName: data tên quy tắc thêm vào
    * */
    fun addRule (ruleName:String?):Long{
        val db = this.writableDatabase
        val contentValues = ContentValues().apply {
            put(COLUMN_RULES_NAME, ruleName);
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
    /* Lấy Danh sách các quy tắc trong database
    *  Trả về danh sách quy tắc
    * */
    fun getAllRules(): List<RuleType> {
        val messageList = mutableListOf<RuleType>()

        val selectQuery = """
        SELECT TR.*, TT.* 
        FROM $TABLE_RULES TR 
        LEFT JOIN $TABLE_TYPES TT 
        ON TR.$COLUMN_RULES_ID = TT.$COLUMN_RULE_ID
        ORDER BY TR.$COLUMN_RULES_ID DESC
    """

        val db = this.readableDatabase
        val cursor = db.rawQuery(selectQuery, null);

        try {
            if (cursor.moveToFirst()) {
                do {
                    // Kiểm tra sự tồn tại của cột trước khi lấy giá trị
                    val ruleType = RuleType(
                        id = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_RULES_ID)),
                        rule = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_RULES_NAME)),
                        typeID = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_TYPES_ID)),
                        typesName = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_TYPES_NAME)),
                        typesContent = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_TYPES_CONTENT))
                    )
                    messageList.add(ruleType)
                } while (cursor.moveToNext())
            }
        } finally {
            cursor.close()
            db.close()
        }

        return messageList
    }
    /* Lấy Danh sách các quy tắc trong database
*  Trả về danh sách quy tắc
* */
    fun getAllRulesSelected(): List<RuleType> {
        val messageList = mutableListOf<RuleType>()

        val selectQuery = """
        SELECT TR.*, TT.* 
        FROM $TABLE_RULES TR 
        LEFT JOIN $TABLE_TYPES TT 
        ON TR.$COLUMN_RULES_ID = TT.$COLUMN_RULE_ID
         WHERE TT.$COLUMN_RULE_TYPE_IS_SELECTED = ?
        ORDER BY TR.$COLUMN_RULES_ID DESC
    """

        val db = this.readableDatabase
        val cursor = db.rawQuery(selectQuery, arrayOf("1"))

        try {
            if (cursor.moveToFirst()) {
                do {
                    // Kiểm tra sự tồn tại của cột trước khi lấy giá trị
                    val ruleType = RuleType(
                        id = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_RULES_ID)),
                        rule = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_RULES_NAME)),
                        typeID = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_TYPES_ID)),
                        typesName = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_TYPES_NAME)),
                        typesContent = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_TYPES_CONTENT))
                    )
                    messageList.add(ruleType)
                } while (cursor.moveToNext())
            }
        } finally {
            cursor.close()
            db.close()
        }

        return messageList
    }
    /* Lấy id mới nhất trong bảng rule
    *  trả về số id mới nhắt
    * */
    fun getNewRuleId(): Int {
        var ruleId = 0 // Khởi tạo biến ruleId
        val selectQuery = "SELECT * FROM $TABLE_RULES ORDER BY $COLUMN_RULES_ID DESC LIMIT 1" // Lấy bản ghi đầu tiên

        val db = this.readableDatabase
        val cursor = db.rawQuery(selectQuery, null)

        if (cursor.moveToFirst()) {
            ruleId = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_RULES_ID)) // Lấy ID
        }

        cursor.close() // Đóng cursor
        db.close() // Đóng cơ sở dữ liệu
        return ruleId // Trả về ID
    }

    /* Lấy quy tắc theo tên và theo kiểu của quy tắc
    *  ruleName: tên quy tắc
    *  typeName: tên kiểu quy tắc
    * */
    fun getRule(ruleName: String?, typeName: String?): RuleType? {
        // Kiểm tra tham số null
        if (ruleName.isNullOrBlank() || typeName.isNullOrBlank()) {
            return null
        }

        val selectQuery = """
        SELECT TR.*, TT.* 
        FROM $TABLE_RULES TR 
        LEFT JOIN $TABLE_TYPES TT 
        ON TR.$COLUMN_RULES_ID = TT.$COLUMN_RULE_ID
        WHERE TR.$COLUMN_RULES_NAME = ? AND TT.$COLUMN_TYPES_NAME = ?
        ORDER BY TR.$COLUMN_RULES_ID DESC
    """
        val db = this.readableDatabase
        val cursor = db.rawQuery(selectQuery, arrayOf(ruleName, typeName))

        var ruleType: RuleType? = null

        try {
            if (cursor.moveToFirst()) {
                // Chỉ lấy bản ghi đầu tiên
                ruleType = RuleType(
                    id = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_RULES_ID)),
                    rule = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_RULES_NAME)),
                    typeID = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_TYPES_ID)),
                    typesName = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_TYPES_NAME)),
                    typesContent = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_TYPES_CONTENT))
                )
            }
        } finally {
            cursor.close()
            db.close()
        }

        return ruleType
    }
    /* Lấy quy tắc theo id của quy tắc đó
   *  typeId : id của type đang được kích hoạt
   * */
    fun getRuleWithId(typeId: Int?): RuleType? {

        val selectQuery = """
        SELECT TR.*, TT.* 
        FROM $TABLE_RULES TR 
        LEFT JOIN $TABLE_TYPES TT 
        ON TR.$COLUMN_RULES_ID = TT.$COLUMN_RULE_ID
        WHERE TT.$COLUMN_TYPES_ID = ?
        ORDER BY TR.$COLUMN_RULES_ID DESC
    """
        val db = this.readableDatabase
        val cursor = db.rawQuery(selectQuery, arrayOf(typeId?.toString()))

        var ruleType: RuleType? = null

        try {
            if (cursor.moveToFirst()) {
                // Chỉ lấy bản ghi đầu tiên
                ruleType = RuleType(
                    id = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_RULES_ID)),
                    rule = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_RULES_NAME)),
                    typeID = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_TYPES_ID)),
                    typesName = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_TYPES_NAME)),
                    typesContent = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_TYPES_CONTENT))
                )
            }
        } finally {
            cursor.close()
            db.close()
        }

        return ruleType
    }
    /* Thêm từ vào bảng word filter
    * wordFilter: từ filter
    *  ruleID : sô id rule của type đó
    *
    * */
    fun addNewWord(wordFilter:String?,ruleID:Int?): Long {
        val db = this.writableDatabase
        val contentValues = ContentValues().apply {
            put(COLUMN_WORDS_NAME,wordFilter);
            put(COLUMN_RULESS_ID,ruleID);
        }
        return try {
            val result = db.insert(TABLE_WORDS_FILTER, null, contentValues)
            return result // Trả về kết quả chèn
        } catch (e: Exception) {
            Log.e("DatabaseError", "Lỗi khi chèn dữ liệu: ${e.message}")
            return -1 // Trả về -1 để báo lỗi khi chèn thất bại
        } finally {
            db.close() // Đảm bảo đóng db dù có lỗi hay không
        }
    }
    /*
    * Lấy các từ lọc theo từng rule
    * ruleID : sô id rule của type đó
    * */
    fun getWordbyRule (ruleID:Int?): List<WordFilter> {
        val wordList = mutableListOf<WordFilter>()
        val selectQuery = "SELECT * FROM $TABLE_WORDS_FILTER WHERE $COLUMN_RULESS_ID = ?"
        val db = this.readableDatabase
        val cursor = db.rawQuery(selectQuery, arrayOf(ruleID.toString()))
        Log.d("getWordbyRule", "getWordbyRule ${ruleID}")
        if (cursor.moveToFirst()) {
            do {
                val id = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_WORDS_ID))
                val wordsName = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_WORDS_NAME))
                val ruleId = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_RULESS_ID))

                // Tạo đối tượng Message với timestamp là chuỗi
                val wordFilter = WordFilter(
                    id = id,
                    wordsName = wordsName,
                    ruleID = ruleId
                )

                wordList.add(wordFilter)
            } while (cursor.moveToNext())
        }

        cursor.close()
        db.close()
        return wordList
    }
    /* Xóa các từ khóa
    *  wordID: id của wordID
    * */
    fun deleteWordbyId (wordsID: Int?) {
        val db = this.writableDatabase
        db.execSQL("DELETE FROM $TABLE_WORDS_FILTER WHERE $COLUMN_WORDS_ID = ?", arrayOf(wordsID.toString()))
        db.close()
    }
    /* Thêm tpye của các quy tắc
    * typeName : tên của tpye
    * typeContent: nội dung của type
    * ruleID : sô id rule của type đó
    * */
    fun addNewType(typeName:String?,typeContent:String?,ruleID:Int?): Long {
        val db = this.writableDatabase
        val contentValues = ContentValues().apply {
            put(COLUMN_TYPES_NAME, typeName);
            put(COLUMN_TYPES_CONTENT,typeContent);
            put(COLUMN_RULE_ID,ruleID);
        }

        return try {
            val result = db.insert(TABLE_TYPES, null, contentValues)
            return result // Trả về kết quả chèn
        } catch (e: Exception) {
            Log.e("DatabaseError", "Lỗi khi chèn dữ liệu: ${e.message}")
            return -1 // Trả về -1 để báo lỗi khi chèn thất bại
        } finally {
            db.close() // Đảm bảo đóng db dù có lỗi hay không
        }
    }
    /* Cập nhật type của các quy tắc
    * typeID: id của type
    * typeName: tên của type
    * typeContent: nội dung của type
    */
    fun updateType(typeName: String?, typeContent: String?, typeID: Int?) {
        // Kiểm tra xem typeID có null hay không
        if (typeID == null) {
            throw IllegalArgumentException("typeID không được null")
        }

        val db = this.writableDatabase
        val contentValues = ContentValues().apply {
            put(COLUMN_TYPES_NAME, typeName)
            put(COLUMN_TYPES_CONTENT, typeContent)
        }

        // Cập nhật bản ghi trong bảng Types
        val rowsAffected = db.update(
            TABLE_TYPES,
            contentValues,
            "$COLUMN_TYPES_ID = ?",
            arrayOf(typeID.toString())
        )

        // Kiểm tra xem có bản ghi nào được cập nhật không
        if (rowsAffected == 0) {
            // Có thể ném ra một ngoại lệ hoặc log thông báo nếu không tìm thấy bản ghi để cập nhật
            throw Exception("Không tìm thấy bản ghi với typeID: $typeID")
        }

        db.close() // Đóng cơ sở dữ liệu
    }
    /* deleteAllRule: Xóa hết các rule */
    fun deleteAllRule () { 
        val db = this.writableDatabase
        db.execSQL("DELETE FROM $TABLE_RULES")
        db.close()
    }
    fun deleteRuleWithId(id: Int?) {
        val db = this.writableDatabase
        db.execSQL("DELETE FROM $TABLE_RULES WHERE $COLUMN_RULES_ID = ?", arrayOf(id.toString()))
        db.close()
    }
    /* Update Rule Selected
    * typeID: Id type to selected
    * ruleTypeSelected: status selected true or false
    */
    fun updateRuleTypeSelected(typeID: Int?, ruleTypeSelected: Boolean?) {
        // Kiểm tra typeID và ruleTypeSelected có null hay không
        if (typeID == null) {
            throw IllegalArgumentException("typeID không được null")
        }

        val db = this.writableDatabase
        val contentValues = ContentValues().apply {
            put(COLUMN_RULE_TYPE_IS_SELECTED, if (ruleTypeSelected == true) 1 else 0) // Dùng if-else để xác định giá trị
        }

        // Cập nhật bản ghi trong bảng Types
        val rowsAffected = db.update(
            TABLE_TYPES,
            contentValues,
            "$COLUMN_TYPES_ID = ?", // Đảm bảo sử dụng COLUMN_TYPES_ID thay vì COLUMN_RULES_ID
            arrayOf(typeID.toString())
        )

        // Kiểm tra xem có bản ghi nào được cập nhật hay không
        if (rowsAffected == 0) {
            throw Exception("Không tìm thấy bản ghi với typeID: $typeID")
        }
        db.close() // Đóng cơ sở dữ liệu
    }
    /* Khởi tạo data khi người dùng truy cập lần đầu
    * */

    /* Thêm dữ liệu phiên bản vào cơ sở dữ liệu hệ thống
 * version: phiên bản ứng dụng
 * releaseNotes: ghi chứ ứng dụng
 * */
    fun addNewVersion(version:String?,releaseNotes:String?): Long {
        val db = this.writableDatabase
        val contentValues = ContentValues().apply {
            put(COLUMN_VERSION_APP, version);
            put(COLUMN_VERSION_NOTE,releaseNotes);
        }

        return try {
            val result = db.insert(TABLE_VERSION_APP, null, contentValues)
            return result // Trả về kết quả chèn
        } catch (e: Exception) {
            Log.e("DatabaseError", "Lỗi khi chèn dữ liệu: ${e.message}")
            return -1 // Trả về -1 để báo lỗi khi chèn thất bại
        } finally {
            db.close() // Đảm bảo đóng db dù có lỗi hay không
        }
    }

    /* Lấy quy tắc theo id của quy tắc đó
    * */
    fun getVersion(): Version? {
        val selectQuery = """
        SELECT *
        FROM $TABLE_VERSION_APP
        ORDER BY $COLUMN_VERSION_APP_ID DESC
        LIMIT 1
    """
        val db = this.readableDatabase
        val cursor = db.rawQuery(selectQuery, null)

        var versionModel: Version? = null

        try {
            if (cursor.moveToFirst()) {
                // Chỉ lấy bản ghi đầu tiên
                versionModel = Version(
                    id = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_VERSION_APP_ID)),
                    version = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_VERSION_APP)),
                    releaseNotes = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_VERSION_NOTE)),
                )
            }
        } finally {
            cursor.close()
            db.close()
        }

        return versionModel
    }

    /* updateVersion
 * versionID: id của bản ghi version
 * version: phiên bản mới cần cập nhật
 * releaseNotes: ghi chú từ phiên bản mới
 */
    fun updateVersion(versionID: Int?, version: String?,releaseNotes: String?) {
        // Kiểm tra typeID và ruleTypeSelected có null hay không
        if (versionID == null) {
            throw IllegalArgumentException("typeID không được null")
        }

        val db = this.writableDatabase
        val contentValues = ContentValues().apply {
            put(COLUMN_VERSION_APP,version);
            put(COLUMN_VERSION_NOTE,releaseNotes);
        }

        // Cập nhật bản ghi trong bảng Types
        val rowsAffected = db.update(
            TABLE_VERSION_APP,
            contentValues,
            "$COLUMN_VERSION_APP_ID = ?", // Đảm bảo sử dụng COLUMN_TYPES_ID thay vì COLUMN_RULES_ID
            arrayOf(versionID.toString())
        )

        // Kiểm tra xem có bản ghi nào được cập nhật hay không
        if (rowsAffected == 0) {
            throw Exception("Không tìm thấy bản ghi với typeID: $versionID")
        }
        db.close() // Đóng cơ sở dữ liệu
    }
    fun initializeData() {
        val ruleTypeList = getAllRules();
        val versionCheck = getVersion();
        val version_curent = "1.0.6";
        val note = "Update mới chức năng cập nhật";
        if(versionCheck == null){
            Log.d("checkdataExit", "initializeData: ${versionCheck}")
            addNewVersion(version_curent,"demoupdate");
        }
        else if(versionCheck.version != version_curent){
            updateVersion(versionCheck.id,version_curent,note);
            deleteAllRule();
        }
        // check database rule exit
        if(ruleTypeList.isEmpty()){
            Log.d("checkdataExit", "initializeData: ${ruleTypeList}")
            // add new rule bidv
            addRule("BIDV");
            val ruleBidv = getNewRuleId();
            addNewType("sms","BIDV",ruleBidv);
            addNewType("app","com.vnpay.bidv",ruleBidv);
            // add new rule ACB
            addRule("ACB");
            val ruleAcb = getNewRuleId();
            addNewType("sms","ACB",ruleAcb);
            addNewType("app","mobile.acb.com.vn",ruleAcb);
            //add new rule VietinBank
            addRule("VietinBank");
            val ruleVietinBank = getNewRuleId();
            addNewType("sms","Vietinbank",ruleVietinBank);
            addNewType("app","com.vietinbank.ipay",ruleVietinBank);
            //add new rule Vietcombank
            addRule("Vietcombank");
            val ruleVietcombank = getNewRuleId();
            addNewType("sms","Vietcombank",ruleVietcombank);
            addNewType("app","com.VCB",ruleVietcombank);
            //add new rule Agribank
            addRule("Agribank");
            val ruleAgribank = getNewRuleId();
            addNewType("sms","Agribank",ruleAgribank);
            addNewType("app","com.vnpay.Agribank3g",ruleAgribank);
            //add new rule OCB
            addRule("OCB");
            val ruleOCB = getNewRuleId();
            addNewType("sms","OCB",ruleOCB);
            addNewType("app","vn.com.ocb.awe",ruleOCB);
            //add new rule MBBank
            addRule("MBBank");
            val ruleMBBank = getNewRuleId();
            addNewType("sms","MBBank",ruleMBBank);
            addNewType("app","com.mbmobile",ruleMBBank);
            //add new rule Techcombank
            addRule("Techcombank");
            val ruleTechcombank = getNewRuleId();
            addNewType("sms","Techcombank",ruleTechcombank);
            addNewType("app","vn.com.techcombank.bb.app",ruleTechcombank);
            //add new rule VPBank
            addRule("VPBank");
            val ruleVPBank = getNewRuleId();
            addNewType("sms","VPBank",ruleVPBank);
            addNewType("app","com.vnpay.vpbankonline",ruleVPBank);
            //add new rule VPBank
            addRule("TPBank");
            val ruleTPBank = getNewRuleId();
            addNewType("sms","TPBank",ruleTPBank);
            addNewType("app","com.tpb.mb.gprsandroid",ruleTPBank );
            //add new rule Sacombank
            addRule("Sacombank");
            val ruleSacombank = getNewRuleId();
            addNewType("sms","Sacombank",ruleSacombank);
            addNewType("app","com.sacombank.ewallet",ruleSacombank );
            addRule("VIB");
            val ruleVIB = getNewRuleId();
            addNewType("sms","VIB",ruleVIB);
            addNewType("app","com.vib.myvib2",ruleVIB );
            addRule("MSB");
            val ruleMSB = getNewRuleId();
            addNewType("sms","MSB",ruleMSB);
            addNewType("app","vn.com.msb.smartBanking",ruleMSB );
            addRule("SHB");
            val ruleSHB = getNewRuleId();
            addNewType("sms","SHB",ruleSHB);
            addNewType("app","vn.shb.mbanking",ruleSHB );
        }
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

data class RuleType(
    val id: Int,
    val rule: String,
    val typeID: Int,
    val typesName:String,
    val typesContent: String,
);

data class WebHook(
    val id: Int,
    val webHookBase: String,
    val webhookEndPoint: String,
    val statusAsync: Int,
)

data class Version(
    val id: Int,
    val version: String,
    val releaseNotes: String,
)
data class WordFilter(
    val id: Int,
    val wordsName: String,
    val ruleID: Int,
)