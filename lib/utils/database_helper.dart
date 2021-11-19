import 'package:alarmku/models/alarm.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<Alarm> getAlarm() => Hive.box<Alarm>('alarm');
}
