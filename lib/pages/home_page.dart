import 'dart:math' as math;

import 'package:alarmku/utils/background_service.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../widgets/clock_painter.dart';
import '../widgets/chartbar.dart';
import '../main.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color colorDial = Colors.amber;

  final ValueNotifier<DateTime> _dateTime = ValueNotifier(DateTime.now());

  String alarmText(DateTime date) {
    return DateFormat.jm().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<DateTime>(
              valueListenable: _dateTime,
              builder: (context, value, child) => Text(
                alarmText(value),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GestureDetector(
              onVerticalDragUpdate: (details) {
                _dateTime.value = _dateTime.value
                    .add(Duration(hours: details.delta.dy.round()));
              },
              onHorizontalDragUpdate: (details) {
                _dateTime.value = _dateTime.value
                    .add(Duration(minutes: details.delta.dx.round()));
              },
              onLongPressUp: () => {
                AndroidAlarmManager.oneShotAt(
                  _dateTime.value,
                  1,
                  BackgroundService.callback,
                  wakeup: true,
                  rescheduleOnReboot: true,
                  exact: true,
                  alarmClock: true,
                ),
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Alarm telah diatur ke ${alarmText(_dateTime.value)}"),
                  backgroundColor: Colors.pink,
                ))
              },
              onDoubleTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryAlarm(),
                    ));
              },
              child: Expanded(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          margin: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade300,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 64,
                                color: Colors.grey.withOpacity(0.5),
                                offset: const Offset(0, 0),
                              )
                            ],
                          ),
                          child: ValueListenableBuilder<DateTime>(
                            valueListenable: _dateTime,
                            builder: (context, _date, child) =>
                                Transform.rotate(
                              angle: -math.pi / 2,
                              child: CustomPaint(
                                painter: ClockPainter(_date),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    Hive.close();
  }
}
