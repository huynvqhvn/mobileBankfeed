// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smsDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  SmsDao? _smsDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SmsModel` (`id` INTEGER, `author` TEXT NOT NULL, `message` TEXT NOT NULL, `timestamp` TEXT NOT NULL, `isSendMessage` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  SmsDao get smsDao {
    return _smsDaoInstance ??= _$SmsDao(database, changeListener);
  }
}

class _$SmsDao extends SmsDao {
  _$SmsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _smsModelInsertionAdapter = InsertionAdapter(
            database,
            'SmsModel',
            (SmsModel item) => <String, Object?>{
                  'id': item.id,
                  'author': item.author,
                  'message': item.message,
                  'timestamp': item.timestamp,
                  'isSendMessage': item.isSendMessage ? 1 : 0
                },
            changeListener),
        _smsModelUpdateAdapter = UpdateAdapter(
            database,
            'SmsModel',
            ['id'],
            (SmsModel item) => <String, Object?>{
                  'id': item.id,
                  'author': item.author,
                  'message': item.message,
                  'timestamp': item.timestamp,
                  'isSendMessage': item.isSendMessage ? 1 : 0
                },
            changeListener),
        _smsModelDeletionAdapter = DeletionAdapter(
            database,
            'SmsModel',
            ['id'],
            (SmsModel item) => <String, Object?>{
                  'id': item.id,
                  'author': item.author,
                  'message': item.message,
                  'timestamp': item.timestamp,
                  'isSendMessage': item.isSendMessage ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SmsModel> _smsModelInsertionAdapter;

  final UpdateAdapter<SmsModel> _smsModelUpdateAdapter;

  final DeletionAdapter<SmsModel> _smsModelDeletionAdapter;

  @override
  Future<List<SmsModel>> findAllSms() async {
    return _queryAdapter.queryList('SELECT * FROM SmsModel',
        mapper: (Map<String, Object?> row) => SmsModel(
            id: row['id'] as int?,
            author: row['author'] as String,
            message: row['message'] as String,
            timestamp: row['timestamp'] as String,
            isSendMessage: (row['isSendMessage'] as int) != 0));
  }

  @override
  Stream<SmsModel?> findSmsById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM SmsModel WHERE id = ?1',
        mapper: (Map<String, Object?> row) => SmsModel(
            id: row['id'] as int?,
            author: row['author'] as String,
            message: row['message'] as String,
            timestamp: row['timestamp'] as String,
            isSendMessage: (row['isSendMessage'] as int) != 0),
        arguments: [id],
        queryableName: 'SmsModel',
        isView: false);
  }

  @override
  Future<int?> getLastSms() async {
    return _queryAdapter.query(
        'SELECT id FROM SmsModel ORDER BY id DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> deleteAllSms() async {
    await _queryAdapter.queryNoReturn('DELETE FROM SmsModel');
  }

  @override
  Future<void> insertSms(SmsModel sms) async {
    await _smsModelInsertionAdapter.insert(sms, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateSms(SmsModel sms) async {
    await _smsModelUpdateAdapter.update(sms, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteSms(SmsModel sms) async {
    await _smsModelDeletionAdapter.delete(sms);
  }

  @override
  Future<int> deletSmsList(List<SmsModel> smsList) {
    return _smsModelDeletionAdapter.deleteListAndReturnChangedRows(smsList);
  }
}
