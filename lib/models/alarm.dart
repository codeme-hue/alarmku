import 'package:hive/hive.dart';
part 'alarm_adapter.dart';

@HiveType(typeId: 0)
class Alarm extends HiveObject {
  @HiveField(0)
  final DateTime date;
  @HiveField(1)
  final int duration;

  Alarm(this.date, this.duration);
}