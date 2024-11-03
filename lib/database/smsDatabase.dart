import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import '../Dao/smsDAO.dart';
import '../model/smsModel.dart';
part 'smsDatabase.g.dart';

@Database(version: 1, entities: [SmsModel])
abstract class AppDatabase extends FloorDatabase {
  SmsDao get smsDao;
}
