import 'dart:math' as math;

import 'package:alarmku/utils/database_helper.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'widgets/chartbar.dart';
import 'pages/home_page.dart';
import 'utils/notification_helper.dart';
import 'models/alarm.dart';
import 'utils/background_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  final dir = await path_provider.getApplicationDocumentsDirectory();

  Hive
    ..init(dir.path)
    ..registerAdapter(AlarmAdapter())
    ..openBox<Alarm>('alarm');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");
  @override
  void initState() {
    super.initState();
    NotificationHelper.init();
    listenNotifications();
  }

  void listenNotifications() =>
      NotificationHelper.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) {
    print(payload);
    final DateTime dateTimeAlarm =
        DateFormat('yyyy-MM-dd hh:mm:ss').parse(payload!);
    final DateTime dateTimeOpen = DateTime.now();
    final int differenceDate = dateTimeOpen.difference(dateTimeAlarm).inSeconds;
    print(dateTimeAlarm);
    print(dateTimeOpen);
    print(differenceDate);
    Boxes.getAlarm().add(Alarm(dateTimeAlarm, differenceDate));
    navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => HistoryAlarm(
          history: Alarm(dateTimeAlarm, differenceDate),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
    );
  }
}


