import 'dart:isolate';

import 'dart:ui';

import 'package:intl/intl.dart';

import 'notification_helper.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _service;
  static String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._createObject();
  factory BackgroundService() {
    return _service ?? BackgroundService._createObject();
  }
  void initializeService() {
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
  }

  static Future<void> callback() async {
    print('Alarm fired!');
    final NotificationHelper _notificationHelper = NotificationHelper();
    await _notificationHelper.showNotification(
        title: 'Alarm selesai!',
        body:
            'Alarm telah berdering pada ${DateFormat.Hms().format(DateTime.now())}',
        payload: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()));

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}