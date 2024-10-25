// dao/person_dao.dart
import 'package:floor/floor.dart';
import '../model/smsModel.dart';

@dao
abstract class SmsDao {
  @Query('SELECT * FROM SmsModel')
  Future<List<SmsModel>> findAllSms();

  @Query('SELECT * FROM SmsModel WHERE id = :id')
  Stream<SmsModel?> findSmsById(int id);

  @insert
  Future<void> insertSms(SmsModel sms);

  @Query('SELECT id FROM SmsModel ORDER BY id DESC LIMIT 1')
  Future<int?> getLastSms();

  @Query('DELETE FROM SmsModel')
  Future<void> deleteAllSms();

  @delete
  Future<void> deleteSms(SmsModel sms);

  @delete
  Future<int> deletSmsList(List<SmsModel> smsList);
  
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateSms(SmsModel sms);
}
