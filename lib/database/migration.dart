import 'package:floor/floor.dart';

// create migration
final migrationUpdateTable = Migration(1, 2, (database) async {
  await database.execute('ALTER TABLE SmsModel ADD COLUMN timestamp INTEGER');
});

final droptable = Migration(2, 3, (database) async {
  await database.execute('DROP TABLE IF EXISTS SmsModel');
});

final createTableMigration = Migration(1,2 , (database) async {
  await database.execute('CREATE TABLE SmsModel (id INTEGER PRIMARY KEY, author TEXT, message TEXT, timestamp String, isSendMessage boolean)');
});